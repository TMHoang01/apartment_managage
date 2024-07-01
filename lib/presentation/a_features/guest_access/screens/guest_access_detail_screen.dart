import 'package:apartment_managage/presentation/a_features/guest_access/blocs/guest_access/guest_access_bloc.dart';
import 'package:apartment_managage/presentation/widgets/custom_button.dart';
import 'package:apartment_managage/presentation/widgets/show_snackbar.dart';
import 'package:apartment_managage/utils/text_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuestAccessDetailScreen extends StatelessWidget {
  const GuestAccessDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late GuestAccessBloc bloc = context.read<GuestAccessBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết phiếu thăm '),
      ),
      body: BlocConsumer<GuestAccessBloc, GuestAccessState>(
        listener: (BuildContext context, GuestAccessState state) {
          if (state.status == GuestAccessStatus.error) {
            // ignore: avoid_print
            print(' GuestAccessDetailScreen Error');
            showSnackBarError(context, state.message ?? 'Xảy ra lỗi');
          }
        },
        builder: (context, state) {
          final item = state.select;
          final bloc = context.read<GuestAccessBloc>();
          Widget? btn = Container();
          if (item == null) {
            return const Center(
              child: Text('Không có dữ liệu'),
            );
          }
          print(item.status);
          if (item.isPending) {
            btn = CustomButton(
              isDisable: state.statusProcess == GuestAccessStatus.loading,
              onPressed: () {
                bloc.add(
                  GuestAccessEventUpdateStatus(item.copyWith(
                    status: 'checkIn',
                    checkInTime: DateTime.now(),
                  )),
                );
              },
              title: 'Check-In',
            );
          }
          if (item.isCheckIn) {
            btn = CustomButton(
              isDisable: state.statusProcess == GuestAccessStatus.loading,
              onPressed: () {
                bloc.add(
                  GuestAccessEventUpdateStatus(item.copyWith(
                    status: 'checkOut',
                    checkOutTime: DateTime.now(),
                  )),
                );
              },
              title: 'Check-Out',
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildItem('Tên khách', item?.guestName),
                const Divider(),
                _buildItem('Số điện thoại', item?.guestPhone),
                const Divider(),
                _buildItem('Số CCCD', item?.guestCccd),
                const Divider(),
                _buildItem('Mục đích', item?.purpose),
                const Divider(),
                _buildItem('Thời gian dự kiến',
                    TextFormat.formatDate(item.expectedTime ?? DateTime.now())),
                const Divider(),
                _buildItem('Trạng thái', item.statusText),
                const Divider(),
                const SizedBox(height: 20),
                btn!,
              ],
            ),
          );
        },
      ),
      // bottomNavigationBar: CustomButton(
      //   onPressed: () {
      //     bloc.add(GuestAccessEventCancel(bloc.state.select!.id ?? ''));
      //   },
      //   title: 'Check-In',
      // ),
    );
  }

  Widget _buildItem(String title, String? value) {
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
}
