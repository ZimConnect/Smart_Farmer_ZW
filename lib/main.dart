import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// TODO: Before Play Store release, replace demo unlock with package:in_app_purchase
// import 'package:in_app_purchase/in_app_purchase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const SmartFarmerApp());
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
  bool isPro = false;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const LivestockPage(),
    const CropsPage(),
    const CalendarPage(),
    const FinancePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadProStatus();
  }

  _loadProStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isPro = prefs.getBool('isPro') ?? false;
    });
  }

  _unlockProDemo() async {
    // LOCAL DEMO UNLOCK - REPLACE THIS BEFORE PLAY STORE
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPro', true);
    setState(() => isPro = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Pro Unlocked! Demo Mode Active')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Farmer ZW Pro'),
        actions: [
          if (!isPro)
            TextButton(
              onPressed: _unlockProDemo,
              child: const Text('GO PRO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
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

// 1. DASHBOARD
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(child: ListTile(title: Text('Welcome to Smart Farmer ZW 🇿🇼'), subtitle: Text('Track livestock, crops, and profits offline'))),
        const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Wrap(spacing: 10, children: [
          Chip(label: Text('Add Animal')),
          Chip(label: Text('Add Crop')),
          Chip(label: Text('Add Task')),
          Chip(label: Text('Record Sale')),
        ])
      ],
    );
  }
}

// 2. LIVESTOCK PAGE
class LivestockPage extends StatelessWidget {
  const LivestockPage({super.key});
  final List<String> cattle = const ['Mashona', 'Tuli', 'Brahman', 'Hereford', 'Angus', 'Simmental', 'Jersey', 'Holstein', 'Ayrshire'];
  final List<String> other = const ['Pigs', 'Sheep', 'Goats', 'Rabbits', 'Broilers', 'Layers', 'Roadrunners', 'Turkeys', 'Ducks', 'Geese', 'Tilapia', 'Catfish', 'Dogs', 'Horses'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(title: Text('CATTLE / MOMBE', style: TextStyle(fontWeight: FontWeight.bold))),
        ...cattle.map((e) => ListTile(title: Text(e), trailing: const Icon(Icons.add))),
        const Divider(),
        const ListTile(title: Text('OTHER ANIMALS', style: TextStyle(fontWeight: FontWeight.bold))),
        ...other.map((e) => ListTile(title: Text(e), trailing: const Icon(Icons.add))),
      ],
    );
  }
}

// 3. CROPS PAGE
class CropsPage extends StatelessWidget {
  const CropsPage({super.key});
  final List<String> crops = const ['Maize', 'Wheat', 'Soybeans', 'Tobacco', 'Tomatoes', 'Onions', 'Potatoes', 'Butternut', 'Cabbage', 'Carrots'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(title: Text('CROP / HORTICULTURE CATALOGUE', style: TextStyle(fontWeight: FontWeight.bold))),
        ...crops.map((e) => ListTile(title: Text(e), trailing: const Icon(Icons.add))),
      ],
    );
  }
}

// 4. CALENDAR PAGE
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('📅 Breeding, Feeding, Vaccination, Deworming Tasks\nAdd tasks and get notifications'),
    );
  }
}

// 5. FINANCE PAGE
class FinancePage extends StatelessWidget {
  const FinancePage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Card(child: ListTile(title: Text('Farm Sales'), subtitle: Text('Track income'))),
        Card(child: ListTile(title: Text('Expenses'), subtitle: Text('Track costs'))),
        Card(child: ListTile(title: Text('Profit'), subtitle: Text('Income - Expenses'))),
      ],
    );
  }
}

// NOTIFICATION SERVICE
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  static Future init() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }
}
