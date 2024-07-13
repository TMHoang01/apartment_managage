import 'package:apartment_managage/domain/models/guest_access/guest_access.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/presentation/a_features/guest_access/blocs/guest_access/guest_access_bloc.dart';
import 'package:apartment_managage/presentation/a_features/guest_access/blocs/select_resident/select_resident_bloc.dart';
import 'package:apartment_managage/presentation/widgets/custom_button.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuestAccessSelectResident extends StatefulWidget {
  const GuestAccessSelectResident({super.key});

  @override
  State<GuestAccessSelectResident> createState() =>
      _GuestAccessSelectResidentState();
}

class _GuestAccessSelectResidentState extends State<GuestAccessSelectResident> {
  UserModel? select;

  @override
  void initState() {
    super.initState();
    final _bloc = context.read<SelectResidentBloc>();
    print(_bloc.state.select);
    if (_bloc.state.status == SelectResidentStatus.initial) {
      _bloc.add(SelectResidentStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cư dân mời'),
      ),
      body: BlocConsumer<SelectResidentBloc, SelectResidentState>(
        builder: (context, state) {
          if (state.status == SelectResidentStatus.initial) {
            return const Center(child: Text('Khởi tạo'));
          }
          if (state.status == SelectResidentStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == SelectResidentStatus.error) {
            return const Center(child: Text('Xảy ra lỗi'));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    if (state.list.isEmpty) {
                      return const Center(
                        child: Text('Không có dữ liệu'),
                      );
                    }
                    final user = state.list[index];
                    return Item(
                        user: user,
                        isSelect: user.id == state.select?.id &&
                            state.select != null);
                  },
                ),
              ],
            ),
          );

          return Container();
        },
        listener: (BuildContext context, SelectResidentState state) {},
      ),
      bottomNavigationBar: CustomButton(
        onPressed: () {
          context.read<SelectResidentBloc>().add(SelectResidentSelectSave());
          navService.pop(context);
        },
        title: 'Xác nhận',
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.user,
    required this.isSelect,
  });

  final UserModel user;
  final bool isSelect;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelect,
      selectedTileColor: kSecondaryColor.withOpacity(0.8),
      leading: CircleAvatar(
        radius: 30,
        child: Text(
          user.username != null && user.username!.isNotEmpty
              ? user.username![0].toUpperCase()
              : '',
          style: const TextStyle(
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(user.username ?? ''),
          const SizedBox(width: 4),
        ],
      ),
      subtitle: Text(user.email ?? ''),
      onTap: () {
        context
            .read<SelectResidentBloc>()
            .add(SelectResidentSelect(resident: user));
      },
    );
  }
}
