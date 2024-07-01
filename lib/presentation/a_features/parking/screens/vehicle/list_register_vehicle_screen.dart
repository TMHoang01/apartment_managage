import 'package:apartment_managage/presentation/a_features/parking/screens/vehicle/widgets/item_ticket_approved_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/blocs/vehicle/vehicle_list_bloc.dart';

import 'widgets/item_vehicle_card.dart';

class ListVehicleTikectRegisterScreen extends StatefulWidget {
  const ListVehicleTikectRegisterScreen({super.key});

  @override
  State<ListVehicleTikectRegisterScreen> createState() =>
      _ListVehicleTikectRegisterScreenState();
}

class _ListVehicleTikectRegisterScreenState
    extends State<ListVehicleTikectRegisterScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<ManageVehicleTicketBloc>()
        .add(ManageVehicleRegisterlStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đăng ký gửi xe'),
      ),
      body: BlocBuilder<ManageVehicleTicketBloc, ManageVehicleState>(
        builder: (context, state) {
          if (state.status == ManageVehicleStatus.loading ||
              state.status == ManageVehicleStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == ManageVehicleStatus.error) {
            return const Center(
              child: Text('Có lỗi xảy ra'),
            );
          }
          if (state.list.isEmpty) {
            return const Center(
              child: Text('Không có dữ liệu'),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  final item = state.list[index];
                  return ItemTicketRegisterdWidget(ticket: item);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
