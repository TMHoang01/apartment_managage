import 'package:apartment_managage/presentation/blocs/admins/users_approve/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/blocs/admins/users/users_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/utils.dart';

class UsersApproveScreen extends StatefulWidget {
  const UsersApproveScreen({super.key});

  @override
  State<UsersApproveScreen> createState() => _UsersApproveScreenState();
}

class _UsersApproveScreenState extends State<UsersApproveScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<UsersApproveBloc>().add(UsersApproveGetAll());
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  void _loadMore() {
    // context.read<UsersApproveBloc>().add(UsersApproveLoadMore());
  }

  void _refresh() {
    // context.read<UsersApproveBloc>().add(UsersGetAllUsers('resident'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách người dùng'),
      ),
      body: BlocBuilder<UsersApproveBloc, UsersApproveState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is UsersApproveLoaded && state.users.isEmpty) {
            return const Center(
              child: Text('Không có người dùng cần duyệt'),
            );
          }
          if (state is UsersApproveError) {
            return Center(
              child: Text(state.message),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                if (state is UsersApproveLoaded)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          controller: scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            if (index == state.users.length) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final user = state.users[index];
                            return UserItem(user: user);
                          },
                        ),
                      ],
                    ),
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
  const UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Map<StatusUser?, Color> colorStatus = {
      StatusUser.active: user.roles == Role.resident
          ? Colors.green
          : user.roles == Role.provider
              ? kSecondaryColor
              : Colors.blue,
      StatusUser.locked: Colors.red,
      StatusUser.pending: Colors.grey,
      null: Colors.grey,
    };
    final Map<Role?, Icon> roleIcons = {
      Role.admin: const Icon(Icons.admin_panel_settings, color: Colors.red),
      Role.provider: Icon(Icons.store, color: colorStatus[user.status]),
      Role.resident: Icon(Icons.person, color: colorStatus[user.status]),
      Role.user: const Icon(Icons.person),
      null: const Icon(Icons.person),
    };
    final iconRoleUser = roleIcons[user.roles];

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
            trailing: iconRoleUser,
          ),
        ),
        if ((user.status == StatusUser.pending || user.status == null) &&
            user.roles != Role.admin)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                onPressed: () {
                  context.read<UsersApproveBloc>().add(UsersApproveAcceptUser(
                      user.id ?? '', StatusUser.rejected));
                },
                title: 'Từ chối',
                backgroundColor: kSecondaryColor,
                height: size.width * 0.1,
                width: size.width * 0.4,
              ),
              CustomButton(
                onPressed: () {
                  context.read<UsersApproveBloc>().add(
                      UsersApproveAcceptUser(user.id ?? '', StatusUser.active));
                },
                title: 'Chấp nhận',
                height: size.width * 0.1,
                width: size.width * 0.4,
              ),
            ],
          ),
        const Divider(),
      ],
    );
  }
}
