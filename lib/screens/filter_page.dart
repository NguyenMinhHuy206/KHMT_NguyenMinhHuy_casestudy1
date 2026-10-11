import 'package:flutter/material.dart';
import 'ui_helpers.dart';

class TransactionFilter {
  final String type;
  final String? category;
  final String period;
  const TransactionFilter({this.type = 'all', this.category, this.period = 'all'});
}

class FilterPage extends StatefulWidget {
  final TransactionFilter initial;
  const FilterPage({super.key, required this.initial});
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late String type;
  late String? category;
  late String period;

  @override
  void initState() {
    super.initState();
    type = widget.initial.type;
    category = widget.initial.category;
    period = widget.initial.period;
  }

  Widget section(String title) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
  );

  @override
  Widget build(BuildContext context) {
    final available = <String>[...expenseCategories, ...incomeCategories].toSet().toList();
    return Scaffold(
      backgroundColor: canvasColor,
      appBar: AppBar(title: const Text('Bộ lọc'), backgroundColor: canvasColor),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        section('Loại giao dịch'),
        for (final option in [('all', 'Tất cả'), ('income', 'Thu nhập'), ('expense', 'Chi tiêu')])
          RadioListTile<String>(title: Text(option.$2), value: option.$1, groupValue: type,
            onChanged: (v) => setState(() => type = v!)),
        section('Danh mục'),
        DropdownButtonFormField<String>(
          value: category ?? '_all',
          decoration: const InputDecoration(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
          items: [
            const DropdownMenuItem(value: '_all', child: Text('Tất cả danh mục')),
            ...available.map((v) => DropdownMenuItem(value: v, child: Text(v))),
          ],
          onChanged: (v) => setState(() => category = v == '_all' ? null : v),
        ),
        section('Khoảng thời gian'),
        for (final option in [('all', 'Hôm nay và trước đó'), ('week', '7 ngày qua'), ('month', 'Tháng này'), ('custom', 'Tùy chọn (30 ngày qua)')])
          RadioListTile<String>(title: Text(option.$2), value: option.$1, groupValue: period,
            onChanged: (v) => setState(() => period = v!)),
        const SizedBox(height: 18),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: blue),
          onPressed: () => Navigator.pop(context, TransactionFilter(type: type, category: category, period: period)),
          child: const Text('Áp dụng'),
        ),
      ]),
    );
  }
}
