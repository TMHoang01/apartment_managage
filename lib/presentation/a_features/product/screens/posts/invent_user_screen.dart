import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/blocs/admins/users/users_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/sl.dart';

class InventUserScreen extends StatefulWidget {
  final List<String>? userIds;
  const InventUserScreen({super.key, this.userIds});

  @override
  State<InventUserScreen> createState() => _InventUserScreenState();
}

class _InventUserScreenState extends State<InventUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách người dùng'),
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        bloc: sl<UsersBloc>()..add(UsersGetListNotInClude(widget.userIds)),
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Text('data'),
                if (state is UsersLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (state is UsersLoaded)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      if (index == state.users.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final user = state.users[index];
                      return UserItem(user: user, isSelect: index % 2 == 0);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  final UserModel user;
  final bool isSelect;

  const UserItem({super.key, required this.user, required this.isSelect});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListBody(
      children: [
        InkWell(
          onTap: () {
            navService.pushNamed(context, RouterAdmin.userDetail, args: user);
          },
          child: ListTile(
            leading: CustomImageView(
              borderRadius: BorderRadius.circular(40),
              url: user.avatar,
              width: 50,
              height: 50,
            ),
            title: Text('${user.username} '),
            subtitle: Text('${user.email} '),
            trailing: isSelect
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.check_circle_outline, color: Colors.grey),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
