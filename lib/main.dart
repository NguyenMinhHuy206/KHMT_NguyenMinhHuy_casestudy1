import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/ui_helpers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExpenseManagerApp());
}

class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Expense Manager',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: blue), scaffoldBackgroundColor: canvasColor),
    home: const WelcomeScreen(),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      const Spacer(),
      Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: const Color(0xFFE9F2FF), borderRadius: BorderRadius.circular(25)),
        child: const Icon(Icons.account_balance_wallet_rounded, color: blue, size: 84)),
      const SizedBox(height: 28),
      const Text('Expense Manager', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: navy)),
      const SizedBox(height: 12),
      const Text('Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4)),
      const Spacer(),
      SizedBox(width: double.infinity, height: 52, child: FilledButton(
        style: FilledButton.styleFrom(backgroundColor: blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage())),
        child: const Text('Bắt đầu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      )),
      const SizedBox(height: 14),
    ]))),
  );
}
