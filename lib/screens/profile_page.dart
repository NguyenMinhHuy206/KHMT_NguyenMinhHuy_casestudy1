
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Cá nhân'),
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thông tin đã được làm mới'),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Cá nhân',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Card(
            color: Colors.white,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3EFFF),
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
              title: const Text(
                'Người dùng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Dữ liệu được lưu trên thiết bị',
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            color: Colors.white,
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.storage),
                  title: Text('Dữ liệu SQLite'),
                  subtitle: Text(
                    'Quản lý các giao dịch',
                  ),
                ),

                const Divider(height: 1),

                const ListTile(
                  leading: Icon(Icons.save_outlined),
                  title: Text('Lưu trữ cục bộ'),
                  subtitle: Text(
                    'Chưa có tài khoản đăng nhập / '
                        'đồng bộ đám mây',
                  ),
                ),

                const Divider(height: 1),

                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Expense Manager'),
                  subtitle: Text(
                    'Bài thực hành Flutter - Buổi 6',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
