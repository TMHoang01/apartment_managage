import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter/material.dart';

class ItemParkingCard extends StatelessWidget {
  final VehicleTicket item;
  final bool selelect;
  const ItemParkingCard({super.key, required this.item, this.selelect = false});

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
        selected: selelect,
        selectedTileColor: kSecondaryColor,
        leading: CircleAvatar(
            child: Icon(item.vehicleType == 'car'
                ? Icons.directions_car
                : Icons.motorcycle)),
        title: Text(item.vehicleLicensePlate ?? ""),
        subtitle: item.parkingLotName != null
            ? Text(
                '${item.parkingLotName}',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              )
            : null,
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
