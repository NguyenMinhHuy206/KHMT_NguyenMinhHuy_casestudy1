import 'package:flutter/material.dart';
import '../database/expense_database.dart';
import 'ui_helpers.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Người dùng';
  String email = '';
  String budget = '';
  int count = 0;
  bool loading = true;

  @override
  void initState() { super.initState(); refresh(); }

  Future<void> refresh() async {
    try {
      final db = ExpenseDatabase.instance;
      final rows = await db.getTransactions();
      final n = await db.getSetting('user_name');
      final e = await db.getSetting('user_email');
      final b = await db.getSetting('monthly_budget');
      if (mounted) setState(() {
        count = rows.length;
        name = n?.isNotEmpty == true ? n! : 'Người dùng';
        email = e ?? '';
        budget = b ?? '';
        loading = false;
      });
    } catch (e) {
      if (mounted) { setState(() => loading = false); snack(context, 'Lỗi SQLite: $e'); }
    }
  }

  Future<void> editProfile() async {
    final nameInput = TextEditingController(text: name);
    final emailInput = TextEditingController(text: email);
    final values = await showDialog<List<String>>(context: context, builder: (c) => AlertDialog(
      title: const Text('Thông tin cá nhân'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameInput, decoration: const InputDecoration(labelText: 'Họ tên')),
        TextField(controller: emailInput, decoration: const InputDecoration(labelText: 'Email')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Hủy')),
        TextButton(onPressed: () => Navigator.pop(c, [nameInput.text.trim(), emailInput.text.trim()]), child: const Text('Lưu')),
      ],
    ));
    if (values == null || values[0].isEmpty) return;
    await ExpenseDatabase.instance.setSetting('user_name', values[0]);
    await ExpenseDatabase.instance.setSetting('user_email', values[1]);
    refresh();
  }

  Future<void> editBudget() async {
    final input = TextEditingController(text: budget);
    final value = await showDialog<String>(context: context, builder: (c) => AlertDialog(
      title: const Text('Cài đặt ngân sách'),
      content: TextField(controller: input, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Ngân sách tháng (đ)')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Hủy')),
        TextButton(onPressed: () => Navigator.pop(c, input.text.trim()), child: const Text('Lưu')),
      ],
    ));
    if (value == null) return;
    final parsed = double.tryParse(value);
    if (parsed == null || !parsed.isFinite || parsed < 0) { if (mounted) snack(context, 'Ngân sách không hợp lệ'); return; }
    await ExpenseDatabase.instance.setSetting('monthly_budget', parsed.toStringAsFixed(0));
    refresh();
  }

  Widget menu(IconData icon, String label, VoidCallback action, {Color? color}) => Card(
    elevation: 0, color: Colors.white, margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(leading: Icon(icon, color: color ?? const Color(0xFF4876AE)), title: Text(label, style: TextStyle(color: color ?? navy, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey), onTap: action),
  );

  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: canvasColor, body: SafeArea(child: RefreshIndicator(
    onRefresh: refresh,
    child: ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Cá nhân', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navy)),
      const SizedBox(height: 18),
      Card(elevation: 0, color: Colors.white, child: ListTile(
        leading: const CircleAvatar(radius: 24, backgroundColor: Color(0xFFDDEBFF), child: Icon(Icons.person, color: blue)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(email.isEmpty ? 'Chưa cập nhật email' : email),
        trailing: IconButton(icon: const Icon(Icons.edit_outlined, color: blue), onPressed: editProfile),
      )),
      const SizedBox(height: 18),
      menu(Icons.person_outline, 'Thông tin cá nhân', editProfile),
      menu(Icons.account_balance_wallet_outlined, 'Cài đặt ngân sách', editBudget),
      menu(Icons.refresh, 'Làm mới dữ liệu', refresh),
      const SizedBox(height: 15),
      Card(elevation: 0, color: Colors.white, child: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Tổng quan tài khoản', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(loading ? 'Đang tải...' : 'Số giao dịch: $count', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 7),
          Text('Ngân sách tháng: ${budget.isEmpty ? 'Chưa thiết lập' : money(double.tryParse(budget) ?? 0)}', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 7),
          const Text('Dữ liệu được lưu cục bộ bằng SQLite.', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ))),
    ]),
  )));
}
