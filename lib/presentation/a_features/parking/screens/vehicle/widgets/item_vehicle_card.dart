import 'package:flutter/material.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';

class ItemVehicleCard extends StatelessWidget {
  final VehicleTicket item;
  const ItemVehicleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color color = item.status == TicketStatus.pending
        ? Colors.orange
        : item.status == TicketStatus.active
            ? Colors.green
            : Colors.red;
    final Size size = MediaQuery.of(context).size;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            child: Icon(item.vehicleType == 'car'
                ? Icons.directions_car
                : Icons.motorcycle)),
        title: Text(item.vehicleLicensePlate ?? ""),
        subtitle: Text(
          item.status?.toName() ?? '',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        // children: [
        //   Container(
        //     width: size.width,
        //     height: 200,
        //     child: Row(
        //       children: [
        //         ListTile(
        //           title: Text('Hãng: ${item.vehicleBarnd}'),
        //         ),
        //         ListTile(
        //           title: Text('Chủ sở hữu: ${item.vehicleOwner}'),
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
      ),
    );
  }
}
