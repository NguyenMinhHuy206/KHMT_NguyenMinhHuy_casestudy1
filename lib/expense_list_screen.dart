import 'package:flutter/material.dart';
import 'add_edit_transaction_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final List<Map<String, dynamic>> _expenses = [];

  double get _totalExpense {
    double total = 0;

    for (final expense in _expenses) {
      total += expense['amount'] as double;
    }

    return total;
  }

  String _formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    )} đ';
  }

  void _addExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddEditTransactionScreen(
            isEditing: false,
            onSave: (expense) {
              setState(() {
                _expenses.add(expense);
              });
            },
          );
        },
      ),
    );
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Color(0xFF27374A),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Expense Manager',
          style: TextStyle(
            color: Color(0xFF17263A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 4),

            // =========================
            // TỔNG CHI TIÊU
            // =========================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng chi tiêu',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _formatMoney(_totalExpense),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B9BD3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // TIÊU ĐỀ
            // =========================

            const Text(
              'Danh sách khoản chi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17263A),
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // DANH SÁCH
            // =========================

            Expanded(
              child: _expenses.isEmpty
                  ? const Center(
                child: Text(
                  'Chưa có khoản chi nào',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [

                        // ICON
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            color: Color(0xFFFF5B62),
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // THÔNG TIN
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                expense['category'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                (expense['note'] as String).isEmpty
                                    ? 'Không có ghi chú'
                                    : expense['note'] as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 3),

                              Text(
                                expense['date'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SỐ TIỀN + NÚT
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatMoney(
                                expense['amount'] as double,
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFFFF6B6B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                const Icon(
                                  Icons.edit,
                                  size: 17,
                                  color: Colors.blue,
                                ),

                                const SizedBox(width: 10),

                                GestureDetector(
                                  onTap: () {
                                    _deleteExpense(index);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    size: 17,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // =========================
            // THÊM KHOẢN CHI
            // =========================

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _addExpense,

                  icon: const Icon(
                    Icons.add,
                    size: 18,
                  ),

                  label: const Text(
                    'Thêm khoản chi',
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2878E8),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}