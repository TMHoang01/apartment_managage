import 'package:apartment_managage/presentation/a_features/parking/blocs/parking/parking_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/blocs/vehicle/vehicle_list_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_lot.dart';
import 'package:apartment_managage/presentation/a_features/parking/screens/paking/widgets/item_parking_card.dart';
import 'package:apartment_managage/presentation/a_features/parking/screens/paking/widgets/parking_slot_widget.dart';
import 'package:apartment_managage/presentation/a_features/parking/screens/vehicle/widgets/item_vehicle_card.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParkingMapScreen extends StatefulWidget {
  const ParkingMapScreen({super.key});

  @override
  State<ParkingMapScreen> createState() => _ParkingMapScreenState();
}

class _ParkingMapScreenState extends State<ParkingMapScreen> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    context.read<ParkingBloc>().add(ParkingStarted());
    final myVehicleBloc = context.read<ManageVehicleTicketBloc>();
    if (myVehicleBloc.state.status == ManageVehicleStatus.initial) {
      myVehicleBloc.add(ManageVehicleRegisterlStarted());
    }
  }

  final imgWight = 406.7;
  final imgHeight = 240.8;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Map<String, List<ParkingLot>> map = {};
  Map<String, int> mapSlot = {};
  String? zoneSelect;

  void moveCenter(Offset point) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = screenWidth * imgHeight / imgWight;
    // double screenWidth = 406.7;
    // double screenHeight = 240.8;

    // double dx = newCenter.dx - screenWidth / 2;
    // double dy = newCenter.dy - screenHeight / 2;

    final scale = 3.0;

    final newCenter =
        getNewCenter(point.dx, point.dy, scale, screenWidth, screenHeight);
    final double xOffset = -(newCenter.dx * scale) + screenWidth / 2;
    final double yOffset = -(newCenter.dy * scale) + screenHeight / 2;
    _transformationController.value = Matrix4.identity()
      ..translate(xOffset, yOffset)
      ..scale(scale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ bãi đỗ xe'),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<ParkingBloc, ParkingState>(
          builder: (context, state) {
            Widget child = const SizedBox();

            if (state.status == ParkingStatus.loading) {
              child = const Center(child: CircularProgressIndicator());
            }
            if (state.status == ParkingStatus.error) {
              child = const Center(child: Text('Có lỗi xảy ra'));
            } else if (state.status == ParkingStatus.loaded) {
              map = {};
              mapSlot = {};
              for (var element in state.list) {
                if (map.containsKey(element.zone)) {
                  map[element.zone]!.add(element);

                  if (element.status == ParkingLotStatus.available ||
                      element.ticketId == null) {
                    mapSlot[element.zone] = mapSlot[element.zone]! + 1;

                    // if (map[element.zone]!.contains(element)) {
                    //   print('contain ${element.zone} ${element.slot}');
                    // }
                  }
                } else {
                  map[element.zone] = [element];
                  mapSlot[element.zone] = 1;
                }
              }

              child = Stack(
                children: [
                  Image.asset(
                    ImageConstant.imgMapF1,
                  ),
                  ...state.list.map((slot) {
                    return PakingSlotWidget(slot);
                  }),
                ],
              );
            }

            // listVehicle in Parking
            final listVehicle = state.listVehicleInParking;
            logger.w(listVehicle);
            return Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    // panEnabled: true,
                    minScale: 0.1,
                    maxScale: 6.0,
                    child: child,
                  ),
                ),
                if (state.lotSelect != null) const SizedBox(height: 10),
                // Text('Đã chọn: ${state.lotSelect?.slot}'),
                const SizedBox(height: 10),
                if (state.status == ParkingStatus.loaded) ...[
                  Text(
                    'Hầm để xe F${state.list[0].floor}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        Center(
                          child: Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: map.keys.map(
                              (key) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      zoneSelect = key;
                                      // final lot not ticketId first
                                      final lot = map[key]!.firstWhere(
                                          (element) =>
                                              element.ticketId == null);
                                      if (lot != null) {
                                        context
                                            .read<ParkingBloc>()
                                            .add(ParkingSelectLot(lot));
                                        moveCenter(Offset(lot.x, lot.y));
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 56,
                                    color: mapSlot[key]! > 0
                                        ? Colors.green
                                        : Colors.red,
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$key',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '${mapSlot[key]}/${map[key]!.length}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: 10),
                if (state.lotSelect != null)
                  Column(
                    children: [
                      Container(
                        height: 60,
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('Slot: ${state.lotSelect?.name}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                            Expanded(child: Container()),
                            if (state.vehicleSelect != null &&
                                state.vehicleSelect?.parkingLotId == null &&
                                state.lotSelect?.isAvailable == true)
                              CustomCircleButton(
                                icon: Icons.add_circle_outline_outlined,
                                iconSize: 30,
                                onPressed: () {
                                  context
                                      .read<ParkingBloc>()
                                      .add(ParkingInProccess());
                                },
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listVehicle.length,
                      itemBuilder: (context, index) {
                        final item = listVehicle[index];
                        return InkWell(
                          onTap: () => context
                              .read<ParkingBloc>()
                              .add(ParkingSelectVehicle(item)),
                          child: ItemParkingCard(
                            item: item,
                            selelect: item.id == state.vehicleSelect?.id,
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Offset getNewCenter(
      double dx, double dy, double scale, double width, double height) {
    Offset ponitA = Offset(width / scale / 2, height / scale / 2);
    Offset ponitB = Offset(width - width / scale / 2, height / scale / 2);
    Offset ponitD = Offset(width / scale / 2, height - height / scale / 2);
    Offset ponitC =
        Offset(width - width / scale / 2, height - height / scale / 2);

    Offset point = Offset(dx, dy);

    if (point.dx > ponitA.dx &&
        point.dx < ponitB.dx &&
        point.dy > ponitA.dy &&
        point.dy < ponitD.dy) {
      return point;
    }

    if (point.dx < ponitA.dx && point.dy < ponitA.dy) {
      return ponitA;
    }

    if (point.dx > ponitB.dx && point.dy < ponitB.dy) {
      return ponitB;
    }

    if (point.dx > ponitC.dx && point.dy > ponitC.dy) {
      return ponitC;
    }

    if (point.dx < ponitD.dx && point.dy > ponitD.dy) {
      return ponitD;
    }
    if (point.dx < ponitA.dx) {
      return Offset(ponitA.dx, point.dy);
    }
    if (point.dx > ponitB.dx) {
      return Offset(ponitB.dx, point.dy);
    }
    if (point.dy < ponitA.dy) {
      return Offset(point.dx, ponitA.dy);
    }
    if (point.dy > ponitD.dy) {
      return Offset(point.dx, ponitD.dy);
    }
    return Offset(width / 2, height / 2);
  }
}
