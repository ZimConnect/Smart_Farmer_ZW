import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class ProService extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  final _storage = const FlutterSecureStorage();
  static const String productId = 'smart_farmer_pro';

  bool _isPro = false;
  bool get isPro => _isPro;
  List<ProductDetails> products = [];

  Future<void> init() async {
    _isPro = await _storage.read(key: 'isPro') == 'true';
    await _loadProducts();
    _iap.purchaseStream.listen(_listenToPurchases);
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails({productId});
    products = response.productDetails;
  }

  Future<void> buyPro() async {
    if (products.isEmpty) return;
    final purchaseParam = PurchaseParam(productDetails: products.first);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _listenToPurchases(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.productID == productId && purchase.status == PurchaseStatus.purchased) {
        // TODO: Verify with your backend here for security
        if (purchase.verificationData.source == 'google_play') {
          await _storage.write(key: 'isPro', value: 'true');
          _isPro = true;
          notifyListeners();
        }
        await _iap.completePurchase(purchase);
      }
    }
  }
}
