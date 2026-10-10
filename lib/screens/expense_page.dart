
import 'package:flutter/material.dart';

import '../database/expense_database.dart';
import '../models/transaction_model.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<TransactionModel> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final data =
      await ExpenseDatabase.instance.getTransactions();

      if (!mounted) return;

      setState(() {
        transactions = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage('Lỗi tải dữ liệu: $e');
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  double get totalIncome {
    return transactions
        .where((item) => item.type == 'income')
        .fold<double>(
      0,
          (sum, item) => sum + item.amount,
    );
  }

  double get totalExpense {
    return transactions
        .where((item) => item.type == 'expense')
        .fold<double>(
      0,
          (sum, item) => sum + item.amount,
    );
  }

  String formatMoney(double amount) {
    final number = amount.toStringAsFixed(0);

    final formatted = number.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );

    return '$formatted đ';
  }

  Future<void> openTransactionForm([
    TransactionModel? transaction,
  ]) async {
    final result = await showDialog<TransactionModel>(
      context: context,
      builder: (context) => TransactionFormDialog(
        transaction: transaction,
      ),
    );

    if (result == null) return;

    try {
      if (transaction == null) {
        await ExpenseDatabase.instance
            .insertTransaction(result);
      } else {
        await ExpenseDatabase.instance
            .updateTransaction(result);
      }

      await loadTransactions();

      showMessage(
        transaction == null
            ? 'Thêm giao dịch thành công'
            : 'Cập nhật thành công',
      );
    } catch (e) {
      showMessage('Lỗi lưu giao dịch: $e');
    }
  }

  Future<void> deleteTransaction(
      TransactionModel transaction,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn muốn xóa "${transaction.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm != true || transaction.id == null) {
      return;
    }

    try {
      await ExpenseDatabase.instance
          .deleteTransaction(transaction.id!);

      await loadTransactions();
      showMessage('Đã xóa giao dịch');
    } catch (e) {
      showMessage('Lỗi xóa giao dịch: $e');
    }
  }

  Widget buildSummaryCard(
      String title,
      double amount,
      Color color,
      ) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  formatMoney(amount),
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thu chi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Hiển thị tổng thu và tổng chi
          Row(
            children: [
              buildSummaryCard(
                'Tổng thu',
                totalIncome,
                Colors.green,
              ),
              buildSummaryCard(
                'Tổng chi',
                totalExpense,
                Colors.red,
              ),
            ],
          ),

          // Hiển thị số dư
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: const Text('Số dư hiện tại'),
              subtitle: Text(
                formatMoney(balance),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: balance >= 0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              leading: const Icon(
                Icons.account_balance_wallet,
                color: Colors.blue,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh sách giao dịch',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Danh sách lưu trong SQLite
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : transactions.isEmpty
                ? const Center(
              child: Text(
                'Chưa có giao dịch nào.\n'
                    'Nhấn + để thêm giao dịch.',
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final item = transactions[index];
                final isIncome =
                    item.type == 'income';

                return Card(
                  margin:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isIncome
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      child: Icon(
                        isIncome
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: isIncome
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    title: Text(item.title),
                    subtitle: Text(
                      '${item.date.substring(0, 10)}\n'
                          '${isIncome ? "Thu" : "Chi"}: '
                          '${formatMoney(item.amount)}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            openTransactionForm(item);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteTransaction(item);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openTransactionForm(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Form thêm / sửa giao dịch
class TransactionFormDialog extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionFormDialog({
    super.key,
    this.transaction,
  });

  @override
  State<TransactionFormDialog> createState() =>
      _TransactionFormDialogState();
}

class _TransactionFormDialogState
    extends State<TransactionFormDialog> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController amountController;

  String type = 'expense';

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    titleController = TextEditingController(
      text: transaction?.title ?? '',
    );

    amountController = TextEditingController(
      text: transaction == null
          ? ''
          : transaction.amount.toStringAsFixed(0),
    );

    type = transaction?.type ?? 'expense';
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void saveTransaction() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(
      amountController.text.trim().replaceAll(',', '.'),
    );

    final transaction = TransactionModel(
      id: widget.transaction?.id,
      title: titleController.text.trim(),
      amount: amount,
      type: type,
      date: widget.transaction?.date ??
          DateTime.now().toIso8601String(),
    );

    Navigator.pop(context, transaction);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;

    return AlertDialog(
      title: Text(
        isEditing ? 'Sửa giao dịch' : 'Thêm giao dịch',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Tên giao dịch',
                  hintText: 'Ví dụ: Ăn sáng',
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: amountController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Số tiền (VNĐ)',
                  hintText: 'Ví dụ: 30000',
                ),
                validator: (value) {
                  final amount = double.tryParse(
                    (value ?? '').trim().replaceAll(
                      ',',
                      '.',
                    ),
                  );

                  if (amount == null ||
                      !amount.isFinite ||
                      amount <= 0) {
                    return 'Nhập số tiền hợp lệ';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(
                  labelText: 'Loại giao dịch',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'income',
                    child: Text('Thu nhập'),
                  ),
                  DropdownMenuItem(
                    value: 'expense',
                    child: Text('Chi tiêu'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      type = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: saveTransaction,
          child: Text(isEditing ? 'Cập nhật' : 'Lưu'),
        ),
      ],
    );
  }
}
