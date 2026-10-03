import 'package:flutter/material.dart';
import 'expense_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Expanded(
                    child: Text(
                      'Quản lý thu chi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          size: 30,
                        ),
                      ),

                      Positioned(
                        right: 2,
                        top: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // SỐ DƯ
              Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4D8CF7),
                      Color(0xFF1769E0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'SỐ DƯ HIỆN TẠI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            '5.000.000 đ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),

                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 7),
                              _dot(),
                              const SizedBox(width: 7),
                              _dot(),
                              const SizedBox(width: 7),
                              _dot(),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Positioned(
                      right: 20,
                      bottom: 28,
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 90,
                        color: Color(0x88FFFFFF),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // THU / CHI
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      title: 'TỔNG THU NHẬP',
                      amount: '8.000.000 đ',
                      icon: Icons.arrow_downward,
                      iconColor: const Color(0xFF2EAD4B),
                      backgroundColor: const Color(0xFFEAF8EB),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _summaryCard(
                      title: 'TỔNG CHI TIÊU',
                      amount: '3.000.000 đ',
                      icon: Icons.arrow_upward,
                      iconColor: const Color(0xFFE53935),
                      backgroundColor: const Color(0xFFFFEFF0),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // GIAO DỊCH GẦN ĐÂY
              Row(
                children: [
                  const Text(
                    'Giao dịch gần đây',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const ExpenseListScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1769E0),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              _transactionItem(
                title: 'Ăn trưa',
                category: 'Ăn uống',
                date: '03/09/2024',
                amount: '-50.000 đ',
                icon: Icons.restaurant,
                color: Colors.orange,
              ),

              _transactionItem(
                title: 'Xăng xe',
                category: 'Di chuyển',
                date: '03/09/2024',
                amount: '-100.000 đ',
                icon: Icons.directions_car,
                color: Colors.blue,
              ),

              _transactionItem(
                title: 'Lương tháng 9',
                category: 'Thu nhập',
                date: '01/09/2024',
                amount: '+8.000.000 đ',
                icon: Icons.attach_money,
                color: Colors.green,
                isIncome: true,
              ),

              _transactionItem(
                title: 'Mua sắm',
                category: 'Mua sắm',
                date: '31/08/2024',
                amount: '-300.000 đ',
                icon: Icons.shopping_cart,
                color: Colors.purple,
              ),

              _transactionItem(
                title: 'Học phí',
                category: 'Giáo dục',
                date: '30/08/2024',
                amount: '-500.000 đ',
                icon: Icons.school,
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF1769E0),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExpenseListScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF1769E0),
        unselectedItemColor: const Color(0xFF263238),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0x88FFFFFF),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF374151),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionItem({
    required String title,
    required String category,
    required String date,
    required String amount,
    required IconData icon,
    required Color color,
    bool isIncome = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '$category     $date',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFF2EAD4B)
                  : const Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }
}