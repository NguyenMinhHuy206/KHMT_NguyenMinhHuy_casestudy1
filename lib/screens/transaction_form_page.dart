import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'ui_helpers.dart';

class TransactionFormPage extends StatefulWidget {
  final TransactionModel? transaction;
  const TransactionFormPage({super.key, this.transaction});
  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late String _type;
  late String _category;
  late DateTime _date;

  List<String> get _categories => _type == 'income' ? incomeCategories : expenseCategories;

  @override
  void initState() {
    super.initState();
    final item = widget.transaction;
    _type = item?.type ?? 'expense';
    _category = item?.category ?? (_type == 'income' ? incomeCategories.first : expenseCategories.first);
    if (!_categories.contains(_category)) _category = _categories.first;
    _date = DateTime.tryParse(item?.date ?? '') ?? DateTime.now();
    _amount = TextEditingController(text: item == null ? '' : item.amount.toStringAsFixed(0));
    _note = TextEditingController(text: item?.note ?? '');
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    final amount = double.parse(_amount.text.trim().replaceAll(',', '.'));
    final note = _note.text.trim();
    Navigator.pop(context, TransactionModel(
      id: widget.transaction?.id,
      title: note.isEmpty ? _category : note,
      amount: amount,
      type: _type,
      date: _date.toIso8601String(),
      category: _category,
      note: note,
    ));
  }

  InputDecoration decoration({String? hint, IconData? suffix}) => InputDecoration(
    hintText: hint,
    suffixIcon: suffix == null ? null : Icon(suffix, size: 20),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDFE5EE))),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );

  Widget label(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: navy)),
  );

  @override
  Widget build(BuildContext context) {
    final edit = widget.transaction != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, centerTitle: true,
        title: Text(edit ? 'Sửa giao dịch' : 'Thêm giao dịch', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
      body: SafeArea(child: Form(key: _form, child: ListView(padding: const EdgeInsets.all(20), children: [
        Row(children: [
          for (final option in ['expense', 'income'])
            Expanded(child: Padding(padding: const EdgeInsets.only(right: 8), child: OutlinedButton(
              onPressed: () => setState(() {
                _type = option;
                _category = _categories.first;
              }),
              style: OutlinedButton.styleFrom(
                foregroundColor: _type == option ? Colors.white : navy,
                backgroundColor: _type == option ? (option == 'expense' ? const Color(0xFFFF5E6C) : blue) : Colors.white,
                side: BorderSide(color: _type == option ? Colors.transparent : const Color(0xFFE1E6F0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ), child: Text(option == 'expense' ? 'Chi tiêu' : 'Thu nhập'),
            ))),
        ]),
        const SizedBox(height: 23),
        label('Danh mục'),
        DropdownButtonFormField<String>(
          value: _category,
          decoration: decoration(),
          items: _categories.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) { if (v != null) setState(() => _category = v); },
        ),
        const SizedBox(height: 20),
        label('Số tiền'),
        TextFormField(
          controller: _amount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: decoration(hint: 'Nhập số tiền').copyWith(suffixText: 'đ'),
          validator: (s) {
            final n = double.tryParse((s ?? '').trim().replaceAll(',', '.'));
            if (n == null || !n.isFinite || n <= 0) return 'Nhập số tiền hợp lệ (ví dụ: 100000)';
            return null;
          },
        ),
        const SizedBox(height: 20),
        label('Ngày giao dịch'),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (date != null && mounted) setState(() => _date = date);
          },
          child: InputDecorator(decoration: decoration(suffix: Icons.calendar_month), child: Text(displayDate(_date.toIso8601String()))),
        ),
        const SizedBox(height: 20),
        label('Ghi chú'),
        TextFormField(controller: _note, maxLines: 3, decoration: decoration(hint: 'Nhập ghi chú (tùy chọn)')),
        const SizedBox(height: 24),
        SizedBox(height: 50, child: FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(backgroundColor: blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold)),
        )),
      ]))),
    );
  }
}
