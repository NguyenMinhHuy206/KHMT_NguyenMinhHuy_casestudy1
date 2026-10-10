
import 'package:flutter/material.dart';

import '../database/expense_database.dart';
import '../models/transaction_model.dart';
import 'transaction_form_page.dart';

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

  // Lấy danh sách giao dịch từ SQLite
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

  // Hiển thị thông báo
  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Tính tổng thu
  double get totalIncome {
    return transactions
        .where((item) => item.type == 'income')
        .fold<double>(
      0,
          (sum, item) => sum + item.amount,
    );
  }

  // Tính tổng chi
  double get totalExpense {
    return transactions
        .where((item) => item.type == 'expense')
        .fold<double>(
      0,
          (sum, item) => sum + item.amount,
    );
  }

  // Định dạng tiền Việt Nam
  String formatMoney(double amount) {
    final number = amount.toStringAsFixed(0);

    final formatted = number.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );

    return '$formatted đ';
  }

  // Định dạng ngày
  String formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) return value;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // Mở màn hình thêm hoặc sửa giao dịch
  Future<void> openTransactionForm([
    TransactionModel? transaction,
  ]) async {
    final result = await Navigator.push<TransactionModel>(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFormPage(
          transaction: transaction,
        ),
      ),
    );

    if (result == null || !mounted) return;

    try {
      if (transaction == null) {
        // Thêm giao dịch vào SQLite
        await ExpenseDatabase.instance
            .insertTransaction(result);
      } else {
        // Cập nhật giao dịch trong SQLite
        await ExpenseDatabase.instance
            .updateTransaction(result);
      }

      // Tải lại dữ liệu sau khi lưu
      await loadTransactions();

      if (!mounted) return;

      showMessage(
        transaction == null
            ? 'Thêm giao dịch thành công'
            : 'Cập nhật giao dịch thành công',
      );
    } catch (e) {
      showMessage('Lỗi lưu giao dịch: $e');
    }
  }

  // Xóa giao dịch
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

    if (confirm != true ||
        transaction.id == null ||
        !mounted) {
      return;
    }

    try {
      await ExpenseDatabase.instance
          .deleteTransaction(transaction.id!);

      await loadTransactions();

      if (!mounted) return;

      showMessage('Đã xóa giao dịch');
    } catch (e) {
      showMessage('Lỗi xóa giao dịch: $e');
    }
  }

  // Card tổng thu và tổng chi
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

  // Hiển thị từng giao dịch
  Widget buildTransactionItem(
      TransactionModel item,
      ) {
    final isIncome = item.type == 'income';

    return Card(
      margin: const EdgeInsets.symmetric(
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
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${item.category} - ${formatDate(item.date)}\n'
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

          // Tổng thu và tổng chi
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

          // Số dư hiện tại
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(
                Icons.account_balance_wallet,
                color: Colors.blue,
              ),
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

          // Danh sách giao dịch từ SQLite
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
                : RefreshIndicator(
              onRefresh: loadTransactions,
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return buildTransactionItem(
                    transactions[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Nút thêm giao dịch
      floatingActionButton: FloatingActionButton(
        onPressed: () => openTransactionForm(),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
