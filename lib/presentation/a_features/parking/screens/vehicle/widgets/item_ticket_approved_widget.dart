import 'package:apartment_managage/presentation/a_features/parking/blocs/vehicle/vehicle_list_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';
import 'package:apartment_managage/presentation/widgets/custom_button.dart';
import 'package:apartment_managage/router.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemTicketRegisterdWidget extends StatelessWidget {
  final VehicleTicket ticket;

  const ItemTicketRegisterdWidget({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      // onTap: () => onTicketSelected(ticket),
      child: Container(
        width: size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(
          //   color: kPrimaryColor.withOpacity(0.3),
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.vehicleOwner ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  'Biển số: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  ticket.vehicleLicensePlate ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (ticket.ticketCode != null)
              Row(
                children: [
                  const Text(
                    'Biển số: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ticket.vehicleLicensePlate ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Ngày đăng ký: ',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  TextFormat.formatDate(ticket.createdAt),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Loại xe: ',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  ticket.vehicleType == 'car' ? 'Ô tô' : 'Xe máy',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 26),
                const Text(
                  'Kiểu xe: ',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  ticket.vehicleBarnd ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (ticket.status == TicketStatus.active)
              const Text(
                'Trạng thái: Đã xác nhận',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (ticket.status == TicketStatus.rejected)
              const Text(
                'Trạng thái: Đã từ chối',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (ticket.status == TicketStatus.pending)
              Row(
                children: [
                  CustomButton(
                    title: 'Từ chối',
                    backgroundColor: kSecondaryColor,
                    height: size.width * 0.1,
                    width: size.width * 0.34,
                    onPressed: () {
                      context.read<ManageVehicleTicketBloc>().add(
                            ManageVehicleUpdateStatus(
                              ticket.id ?? '',
                              TicketStatus.rejected,
                            ),
                          );
                    },
                  ),
                  CustomButton(
                      title: 'Xác nhận',
                      height: size.width * 0.1,
                      width: size.width * 0.34,
                      onPressed: () {
                        context.read<ManageVehicleTicketBloc>().add(
                              ManageVehicleConfirmRegister(ticket.id ?? ''),
                            );
                        navService.pushNamed(
                            context, AppRouter.parkingVehicleEdit);
                      }),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
