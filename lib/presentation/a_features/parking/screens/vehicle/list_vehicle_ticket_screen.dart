import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/blocs/vehicle/vehicle_list_bloc.dart';

import 'widgets/item_vehicle_card.dart';

class ListVehicleTikectScreen extends StatefulWidget {
  const ListVehicleTikectScreen({super.key});

  @override
  State<ListVehicleTikectScreen> createState() =>
      _ListVehicleTikectScreenState();
}

class _ListVehicleTikectScreenState extends State<ListVehicleTikectScreen> {
  @override
  void initState() {
    super.initState();
    _initFetch();
  }

  _initFetch() {
    context.read<ManageVehicleTicketBloc>().add(ManageVehicleTicketStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vé xe tháng'),
        actions: [],
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
          return RefreshIndicator(
            onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
              _initFetch();
            }),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    final item = state.list[index];
                    return ItemVehicleCard(item: item);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
