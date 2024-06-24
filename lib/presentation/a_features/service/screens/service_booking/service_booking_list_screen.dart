import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/service/booking_service.dart';
import 'package:apartment_managage/domain/models/service/enum_service.dart';
import 'package:apartment_managage/presentation/a_features/service/blocs/service_booking/service_booking_bloc.dart';
import 'package:apartment_managage/presentation/screens/admins/router_admin.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/utils.dart';

class ServiceBookingListScreen extends StatelessWidget {
  const ServiceBookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ServiceBookingBloc>().add(ServiceBookingStarted());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn đặt dịch vụ'),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
            context.read<ServiceBookingBloc>().add(ServiceBookingStarted());
          }),
          child: Column(
            children: [
              BlocBuilder<ServiceBookingBloc, ServiceBookingState>(
                builder: (context, state) {
                  if (state.status == ServiceBookingStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.status == ServiceBookingStatus.error) {
                    return const Center(
                      child: Text('Có lỗi xảy ra'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      final item = state.list[index];
                      return ItemBookingCard(item: item);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemBookingCard extends StatelessWidget {
  final BookingService item;
  const ItemBookingCard({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    final Color bgColor = switch (item.status) {
      BookingStatus.pending => Colors.yellow,
      BookingStatus.accepted => Colors.green,
      BookingStatus.rejected => Colors.red,
      _ => Colors.white,
    };
    return Card(
      child: InkWell(
        onTap: () {
          context
              .read<ServiceBookingBloc>()
              .add(ServiceBookingDetailStarted(item.id));
          navService.pushNamed(
            context,
            RouterAdmin.bookingDetail,
            args: item,
          );
        },
        child: ListTile(
          title: Row(
            children: [
              Text(TextFormat.formatDate(item.createdAt!,
                  formatType: 'dd/MM/yyyy HH:mm')),
              const Spacer(),
              Text(
                '${TextFormat.formatMoney(item.total)}đ',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.serviceName ?? ''),
              Text('Người đặt: ${item.userName ?? ''}'),
            ],
          ),
          trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // color: item.status!.toColor(),
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(item.status!.toName())),
        ),
      ),
    );
  }
}
