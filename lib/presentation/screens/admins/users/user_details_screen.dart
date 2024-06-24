import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;
  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CustomImageView(
            url: user.avatar,
            width: 140,
            height: 140,
            borderRadius: BorderRadius.circular(90),
          ),
          const SizedBox(height: 10),
          _buildItem('Tên:', user.username ?? ''),
          _buildItem('Email:', user.email ?? ''),
          _buildItem('Số điện thoại:', user.phone ?? ''),
          _buildItemIcon('Vai trò:', user.roles?.toJson() ?? ''),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          '$value ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildItemIcon(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 180),
          child: Container(
            width: 50,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  '$value ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.admin_panel_settings),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
