import 'dart:math';

import 'package:apartment_managage/presentation/a_features/parking/blocs/parking_checkin/parking_checkin_bloc.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ParkingOutWidget extends StatefulWidget {
  const ParkingOutWidget({super.key});

  @override
  State<ParkingOutWidget> createState() => _ParkingOutWidgetState();
}

class _ParkingOutWidgetState extends State<ParkingOutWidget> {
  final TextEditingController _qController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _qController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        StatefulBuilder(
          builder: ((context, setState) {
            return CustomTextFormField(
                controller: _qController,
                onFieldSubmitted: (value) {
                  setState(() {
                    context.read<ParkingCheckInBloc>().add(
                          ParkingCheckInSearchInParking(value),
                        );
                  });
                },
                onChanged: (p0) => setState,
                margin: const EdgeInsets.all(10),
                hintText: 'Nhập biển số xe, mã thẻ xe',
                suffix: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context
                        .read<ParkingCheckInBloc>()
                        .add(ParkingCheckInSearchInParking(_qController.text));
                  },
                ));
          }),
        ),
        BlocBuilder<ParkingCheckInBloc, ParkingCheckInState>(
          builder: (context, state) {
            print('state ${state.status}');
            if (state.status == ParkingCheckInStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == ParkingCheckInStatus.error) {
              return Center(
                child: Text('Error ${state.message}'),
              );
            } else if (state.status == ParkingCheckInStatus.loaded) {
              int length = state.list.length;
              if (length == 0) {
                return const Center(
                  child: Text('Không có kết quả tìm kiếm xe trong bãi'),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: length,
                itemBuilder: (context, index) {
                  final parkingHistory = state.list[index];
                  if (length == 0) {
                    return const Center(
                      child: Text('Không có dữ liệu xe trong bãi'),
                    );
                  }
                  bool isLoading =
                      state.statusOut == ParkingCheckInStatus.loading &&
                          state.select == parkingHistory;
                  bool visibool = parkingHistory.timeOut == null;
                  String type =
                      parkingHistory.isMonthlyTicket == true ? "tháng" : '';
                  return ListTile(
                    title: Text('BSX: ${parkingHistory.vehicleLicensePlate} '),
                    subtitle: Text('MT $type: ${parkingHistory.ticketCode}  '),
                    trailing: SizedBox(
                      width: 120,
                      child: Visibility(
                        // visible: visibool,
                        child: visibool
                            ? CustomButton(
                                isDisable: isLoading,
                                onPressed: () {
                                  context.read<ParkingCheckInBloc>().add(
                                        ParkingCheckInCheckOutStarted(
                                          parkingHistory,
                                        ),
                                      );
                                },
                                title: 'Ra ',
                              )
                            : Text(
                                'Đã ra: ${TextFormat.formatMoney(parkingHistory.price)} ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              );
            }
            return Container(
              height: 200,
              color: Colors.red,
            );
          },
        ),
      ],
    );
  }
}
