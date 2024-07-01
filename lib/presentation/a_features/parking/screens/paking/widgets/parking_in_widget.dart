import 'package:apartment_managage/presentation/a_features/parking/blocs/parking_checkin/parking_checkin_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_checkin.dart';
import 'package:apartment_managage/presentation/a_features/parking/screens/vehicle/widgets/item_vehicle_card.dart';
import 'package:apartment_managage/presentation/widgets/widgets.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParkingInWidget extends StatefulWidget {
  const ParkingInWidget({super.key});

  @override
  State<ParkingInWidget> createState() => _ParkingInWidgetState();
}

class _ParkingInWidgetState extends State<ParkingInWidget> {
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _ticketCodeController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const sizebox = SizedBox(height: 12);
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          sizebox,
          sizebox,
          sizebox,
          BlocBuilder<ParkingCheckInBloc, ParkingCheckInState>(
            buildWhen: (previous, current) => current.ticket != null,
            builder: (context, state) {
              if (state.ticket == null) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ItemVehicleCard(item: state.ticket!),
              );
            },
          ),
          sizebox,
          sizebox,
          CustomTextFormField(
            controller: _licensePlateController,
            hintText: 'Biển số xe',
            // validator: (value) => Validators.validateEmpty(value),
          ),
          sizebox,
          CustomTextFormField(
            controller: _ticketCodeController,
            textInputType: TextInputType.number,
            hintText: 'Mã thẻ xe',
            validator: (value) => Validators.validateEmpty(value),
          ),
          // sizebox,
          // Center(
          //   child: Column(
          //     children: [
          //       ImageInputPiker(
          //         onFileSelected: (file) {
          //           _imageController.text = file!.path;
          //         },
          //       ),
          //       const Text('Ảnh xe vào'),
          //     ],
          //   ),
          // ),
          sizebox,

          sizebox,
          BlocConsumer<ParkingCheckInBloc, ParkingCheckInState>(
            buildWhen: (previous, current) =>
                previous.statusIn != current.statusIn,
            listenWhen: (previous, current) =>
                previous.statusIn != current.statusIn,
            listener: (context, state) {
              print('Xác nhận xe vào:${state.status} ${state.statusIn}');

              if (state.statusIn == ParkingCheckInStatus.error) {
                showSnackBarError(context, state.message);
              } else if (state.statusIn == ParkingCheckInStatus.loaded) {
                showSnackBarSuccess(context, 'Xe vào thành công');
                _licensePlateController.clear();
                _ticketCodeController.clear();
                _imageController.clear();
              }
            },
            builder: (context, state) {
              bool isLoading = state.statusIn == ParkingCheckInStatus.loading;
              return CustomButton(
                isDisable: isLoading,
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    final history = ParkingCheckIn(
                      vehicleLicensePlate: _licensePlateController.text,
                      ticketCode: _ticketCodeController.text,
                      imgIn: _imageController.text,
                    );

                    context
                        .read<ParkingCheckInBloc>()
                        .add(ParkingCheckInCheckInStarted(history));
                  }
                },
                title: 'Xác nhận',
              );
            },
          )
        ],
      ),
    );
  }
}
