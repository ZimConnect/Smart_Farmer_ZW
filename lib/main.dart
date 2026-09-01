import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// 1. BILLING SERVICE
class BillingService with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  static const String kProProductId = 'smart_farmer_pro';
  static const String _proKey = 'isPro';
  
  bool isPro = false;
  bool isLoading = true;
  List<ProductDetails> products = [];
  
  BillingService() { _init(); }

  Future<void> _init() async {
    await _loadProStatus();
    bool available = await _iap.isAvailable();
    if (available) {
      final response = await _iap.queryProductDetails({kProProductId});
      products = response.productDetails;
    }
    _iap.purchaseStream.listen(_listenToPurchases);
    await _iap.restorePurchases();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadProStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isPro = prefs.getBool(_proKey) ?? false;
  }

  Future<void> _saveProStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_proKey, value);
    isPro = value;
    notifyListeners();
  }

  void _listenToPurchases(List<PurchaseDetails> list) async {
    for (var purchase in list) {
      if (purchase.status == PurchaseStatus.purchased && purchase.productID == kProProductId) {
        await _saveProStatus(true);
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<void> buyPro() async {
    if (products.isEmpty) return;
    final product = products.firstWhere((p) => p.id == kProProductId);
    await _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => BillingService(),
      child: const SmartFarmerApp(),
    ),
  );
}

class SmartFarmerApp extends StatelessWidget {
  const SmartFarmerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farmer ZW Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32), // Green for farming
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const DashboardPage(),
    const LivestockPage(),
    const CropsPage(),
    const CalendarPage(),
    const FinancePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final billing = context.watch<BillingService>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Farmer ZW Pro'),
        actions: [
          if (!billing.isPro && !billing.isLoading)
            TextButton(
              onPressed: billing.buyPro, // REAL PURCHASE NOW
              child: Text(
                billing.products.isEmpty ? 'GO PRO' : 'GO PRO ${billing.products.first.price}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          else if (billing.isPro)
            const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.verified, color: Colors.amber))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text('Smart Farmer ZW', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(title: const Text('🐄 Livestock'), onTap: () => setState(() => _selectedIndex = 1)),
            ListTile(title: const Text('🌽 Crops & Horticulture'), onTap: () => setState(() => _selectedIndex = 2)),
            ListTile(title: const Text('📅 Farm Calendar'), onTap: () => setState(() => _selectedIndex = 3)),
            ListTile(title: const Text('💰 Finance & Sales'), onTap: () => setState(() => _selectedIndex = 4)),
            if(billing.isPro) const ListTile(title: Text('⭐ PRO FEATURES UNLOCKED')),
            ListTile(title: const Text('Restore Purchase'), onTap: () => InAppPurchase.instance.restorePurchases()),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Livestock'),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Crops'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Finance'),
        ],
      ),
    );
  }
}

// YOUR PAGES STAY THE SAME
class DashboardPage extends StatelessWidget { const DashboardPage({super.key}); @override Widget build(BuildContext context) { return ListView(padding: const EdgeInsets.all(16), children: [Card(child: ListTile(title: Text('Welcome to Smart Farmer ZW 🇿🇼'), subtitle: Text('Track livestock, crops, and profits offline'))), const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Wrap(spacing: 10, children: [Chip(label: Text('Add Animal')), Chip(label: Text('Add Crop')), Chip(label: Text('Add Task')), Chip(label: Text('Record Sale')),])]);}}
class LivestockPage extends StatelessWidget { const LivestockPage({super.key}); final List<String> cattle = const ['Mashona', 'Tuli', 'Brahman', 'Hereford', 'Angus', 'Simmental', 'Jersey', 'Holstein', 'Ayrshire']; final List<String> other = const ['Pigs', 'Sheep', 'Goats', 'Rabbits', 'Broilers', 'Layers', 'Roadrunners', 'Turkeys', 'Ducks', 'Geese', 'Tilapia', 'Catfish', 'Dogs', 'Horses']; @override Widget build(BuildContext context) { return ListView(children: [const ListTile(title: Text('CATTLE / MOMBE', style: TextStyle(fontWeight: FontWeight.bold))), ...cattle.map((e) => ListTile(title: Text(e), trailing: const Icon(Icons.add))), const Divider(), const ListTile(title: Text('OTHER ANIMALS', style: TextStyle(fontWeight: FontWeight.bold))), ...other.map((e) => ListTile(title: Text(e), trailing: const Icon(Icons.add))),]);}}
class CropsPage extends StatelessWidget { const CropsPage({super.key}); final List<String> crops = const ['Maize', 'Wheat', 'Soybeans', 'Tobacco', 'Tomatoes', 'Onions', 'Potatoes', 'Butternut', 'Cabbage', 'Carrots']; @override Widget build(BuildContext context) { return ListView(children: [const ListTile(title: Text('CROP / HORTICULTURE CATALOGUE', style: TextStyle(fontWeight: FontWeight.bold))), ...crops.map((e) => ListTile(title: Text(e), trailing: const Icon(Icons.add))),]);}}
class CalendarPage extends StatelessWidget { const CalendarPage({super.key}); @override Widget build(BuildContext context) { return const Center(child: Text('📅 Breeding, Feeding, Vaccination, Deworming Tasks\nAdd tasks and get notifications'));}}
class FinancePage extends StatelessWidget { const FinancePage({super.key}); @override Widget build(BuildContext context) { return ListView(padding: const EdgeInsets.all(16), children: const [Card(child: ListTile(title: Text('Farm Sales'), subtitle: Text('Track income'))), Card(child: ListTile(title: Text('Expenses'), subtitle: Text('Track costs'))), Card(child: ListTile(title: Text('Profit'), subtitle: Text('Income - Expenses'))),]);}}

// NOTIFICATION SERVICE
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static Future init() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }
}
