import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/domain/models/ecom/infor_contact.dart';
import 'package:apartment_managage/domain/models/service/booking_service.dart';
import 'package:apartment_managage/domain/models/service/enum_service.dart';
import 'package:apartment_managage/presentation/a_features/service/blocs/service_booking/service_booking_bloc.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/utils.dart';

class ServiceBookingDetailScreen extends StatelessWidget {
  const ServiceBookingDetailScreen({super.key, required this.booking});
  final BookingService booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lịch'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InforContactCard(
                infor: booking?.inforContact ?? const InforContactModel()),
            // infor service
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Thông tin dịch vụ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tên dịch vụ: ${booking?.serviceName}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Nhà chu cấp: ${booking?.providerId}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Giá cơ bản: ${TextFormat.formatMoney(booking?.servicePriceBase ?? 0)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Gói đăng ký: ${booking?.servicePriceItem?.name}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Giá dịch vụ: ${TextFormat.formatMoney(booking?.servicePriceItem?.price ?? 0)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // infor cheulde
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Lịch đăng ký',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thời gian bắt đầu: ${TextFormat.formatDate(booking.schedule?.startDate)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Thời gian kết thúc: ${TextFormat.formatDate(booking.schedule?.endDate)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Lặp lại hàng tuần: ${booking.schedule?.isReapeat == false ? 'Không' : 'Có'}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Số buổi: ${booking.schedule?.scheduleCount}',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Ghi chú',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(booking?.note ?? ''),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 8),

            CustomContainer(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Tổng tiền',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      '${TextFormat.formatMoney(booking?.total ?? 0)}đ',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            serviceFormStateBlocSelector<BookingStatus?>(
              selector: (state) {
                return state.bookingSelected!.status;
              },
              builder: (context, status) {
                final textColor = status == BookingStatus.accepted
                    ? Colors.green
                    : status == BookingStatus.rejected
                        ? Colors.red
                        : const Color.fromARGB(255, 234, 234, 53);
                Widget childStatus = CustomContainer(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Trạng thái',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            status?.toName() ?? '',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                if (status != BookingStatus.pending || status == null) {
                  return childStatus;
                }
                return Column(
                  children: [
                    childStatus,
                    const SizedBox(height: 8),
                    CustomButton(
                      onPressed: () {
                        context.read<ServiceBookingBloc>().add(
                              ServiceBookingUpdateStatus(
                                booking.id,
                                BookingStatus.accepted,
                              ),
                            );
                      },
                      title: 'Xác nhận',
                    ),
                    const SizedBox(height: 8),
                    CustomButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        // show Dilo
                        _dialogBuilder(context);
                      },
                      title: 'Hủy bỏ',
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Thông báo'),
          content: const Text(
            'Bạn có xác nhận muốn hủy bỏ đơn đặt này không?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Hủy bỏ'),
              onPressed: () {
                navService.pop(ctx);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Xác nhận'),
              onPressed: () async {
                context.read<ServiceBookingBloc>().add(
                      ServiceBookingUpdateStatus(
                        booking.id,
                        BookingStatus.rejected,
                      ),
                    );
                navService.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }

  serviceFormStateBlocSelector<T>({
    required T Function(ServiceBookingState) selector,
    required Widget Function(BuildContext, T) builder,
  }) =>
      BlocSelector<ServiceBookingBloc, ServiceBookingState, T>(
        selector: selector,
        builder: builder,
      );
}
