import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pro_service.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proService = ref.watch(proServiceProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Upgrade to PRO 👑')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SMART FARMER ZW PRO', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('One-time payment. Unlock everything forever.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            _featureTile('🐄', 'All 17 Animals + Fish + Crops'),
            _featureTile('📊', 'Unlimited Records + Multi-Farm'),
            _featureTile('📅', 'Breeding, Gestation, Vaccination Alerts'),
            _featureTile('💰', 'Expenses, Sales, Profit/Loss Reports'),
            _featureTile('🌱', 'Zimbabwe Planting Calendar'),
            _featureTile('📱', 'Full Offline Mode + Data Backup'),
            const Spacer(),
            if(proService.products.isNotEmpty)
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                onPressed: () => proService.buyPro(),
                child: Text('Get PRO - ${proService.products.first.price}')
              ),
            TextButton(
              onPressed: () => proService.restorePurchases(),
              child: const Center(child: Text('Restore Purchase'))
            )
          ],
        ),
      ),
    );
  }

  Widget _featureTile(String emoji, String text) => 
    ListTile(leading: Text(emoji, style: const TextStyle(fontSize: 24)), title: Text(text));
}
