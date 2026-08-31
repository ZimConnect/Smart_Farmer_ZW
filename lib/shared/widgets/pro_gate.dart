import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/pro/pro_service.dart';

class ProGate extends ConsumerWidget {
  final Widget child;
  final String featureName;
  const ProGate({required this.child, required this.featureName, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proService = ref.watch(proServiceProvider);
    
    if (proService.isPro) return child;
    
    return GestureDetector(
      onTap: () => _showPaywall(context, proService),
      child: Stack(
        children: [
          Opacity(opacity: 0.3, child: child),
          Center(child: Chip(label: Text('$featureName - PRO $5')))
        ],
      ),
    );
  }

  void _showPaywall(BuildContext context, ProService service) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Unlock SMART FARMER PRO', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('One-time $5. Unlock everything forever.'),
          ElevatedButton(
            onPressed: () => service.buyPro(),
            child: const Text('Buy Pro - $5')
          )
        ]),
      )
    );
  }
}

final proServiceProvider = ChangeNotifierProvider((ref) => ProService()..init());
