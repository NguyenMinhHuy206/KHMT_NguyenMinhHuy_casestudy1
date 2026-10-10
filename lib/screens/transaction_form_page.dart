
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionFormPage extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionFormPage({
    super.key,
    this.transaction,
  });

  @override
  State<TransactionFormPage> createState() =>
      _TransactionFormPageState();
}

class _TransactionFormPageState
    extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  String _type = 'expense';
  String _category = 'Ăn uống';
  late DateTime _selectedDate;

  final List<String> _expenseCategories = [
    'Ăn uống',
    'Di chuyển',
    'Mua sắm',
    'Hóa đơn',
    'Giải trí',
    'Khác',
  ];

  final List<String> _incomeCategories = [
    'Lương',
    'Thưởng',
    'Kinh doanh',
    'Thu nhập khác',
    'Khác',
  ];

  List<String> get _categories {
    return _type == 'expense'
        ? _expenseCategories
        : _incomeCategories;
  }

  @override
  void initState() {
    super.initState();

    final item = widget.transaction;

    _type = item?.type ?? 'expense';

    _category = item?.category ?? 'Ăn uống';

    if (!_categories.contains(_category)) {
      _category = _categories.first;
    }

    _selectedDate =
        DateTime.tryParse(item?.date ?? '') ??
            DateTime.now();

    _amountController = TextEditingController(
      text: item == null
          ? ''
          : item.amount.toStringAsFixed(0),
    );

    _noteController = TextEditingController(
      text: item?.note ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Chuyển giữa chi tiêu và thu nhập
  void _changeType(String value) {
    setState(() {
      _type = value;
      _category = _categories.first;
    });
  }

  // Chọn ngày giao dịch
  Future<void> _chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null && mounted) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  // Định dạng ngày
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // Lưu thông tin giao dịch
  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    final note = _noteController.text.trim();

    final transaction = TransactionModel(
      id: widget.transaction?.id,
      title: note.isEmpty ? _category : note,
      amount: amount,
      type: _type,
      date: _selectedDate.toIso8601String(),
      category: _category,
      note: note,
    );

    // Trả giao dịch về Dashboard để lưu vào SQLite
    Navigator.pop(context, transaction);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch',
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Loại giao dịch
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _changeType('expense');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _type == 'expense'
                            ? const Color(0xFFFF626A)
                            : Colors.white,
                        foregroundColor: _type == 'expense'
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: const Text('Chi tiêu'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _changeType('income');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _type == 'income'
                            ? Colors.green
                            : Colors.white,
                        foregroundColor: _type == 'income'
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: const Text('Thu nhập'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Danh mục
              const Text(
                'Danh mục',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.category_outlined,
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // Số tiền
              const Text(
                'Số tiền',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _amountController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Nhập số tiền',
                  suffixText: 'đ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final amount = double.tryParse(
                    (value ?? '').trim().replaceAll(',', '.'),
                  );

                  if (amount == null ||
                      !amount.isFinite ||
                      amount <= 0) {
                    return 'Vui lòng nhập số tiền hợp lệ';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Ngày giao dịch
              const Text(
                'Ngày giao dịch',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              InkWell(
                onTap: _chooseDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                    ),
                  ),
                  child: Text(
                    _formatDate(_selectedDate),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Ghi chú
              const Text(
                'Ghi chú',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Nhập ghi chú (tùy chọn)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 28),

              // Nút lưu
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF1976F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
