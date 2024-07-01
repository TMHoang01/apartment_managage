import 'package:apartment_managage/presentation/blocs/admins/user_detail/user_detail_bloc.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel user;
  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    context.read<UserDetailBloc>().add(UserDetailStarted(user: widget.user));
  }

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
            url: widget.user.avatar,
            width: 140,
            height: 140,
            borderRadius: BorderRadius.circular(90),
          ),
          const SizedBox(height: 10),
          _buildItem('Tên:', widget.user.username ?? ''),
          const Divider(),
          _buildItem('Email:', widget.user.email ?? ''),
          const Divider(),
          _buildItem('Số điện thoại:', widget.user.phone ?? ''),
          const Divider(),
          _buildItemIcon('Vai trò:', widget.user.roles?.toName() ?? ''),
          const Divider(),
          const SizedBox(height: 20),
          BlocConsumer<UserDetailBloc, UserDetailState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              bool isLoading = state.status == UserDatailStatus.loading;
              String status =
                  state.item?.status != StatusUser.active ? "active" : "locked";
              String btnTitle =
                  status != "active" ? "Khóa tài khoản" : "Mở khóa tài khoản";
              return CustomButton(
                backgroundColor:
                    status == "active" ? kPrimaryColor : kSecondaryColor,
                isDisable: isLoading,
                title: '$btnTitle',
                onPressed: () {
                  context
                      .read<UserDetailBloc>()
                      .add(UserDetailUpdateStatus(status));
                },
              );
            },
          )
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
      subtitle: Row(
        children: [
          Container(
            // width: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),

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
          const Spacer(),
        ],
      ),
    );
  }
}
