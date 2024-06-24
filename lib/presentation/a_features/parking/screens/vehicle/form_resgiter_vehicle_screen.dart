import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/blocs/vehicle/vehicle_list_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';
import 'package:apartment_managage/presentation/widgets/custom_button.dart';
import 'package:apartment_managage/presentation/widgets/custom_input.dart';
import 'package:apartment_managage/presentation/widgets/select_widget.dart';
import 'package:apartment_managage/presentation/widgets/show_snackbar.dart';
import 'package:apartment_managage/utils/utils.dart';

class FormResgitterVehicleScreen extends StatefulWidget {
  const FormResgitterVehicleScreen({super.key});

  @override
  State<FormResgitterVehicleScreen> createState() =>
      _FormResgitterVehicleScreenState();
}

class _FormResgitterVehicleScreenState
    extends State<FormResgitterVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _licensePlateController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _brandController = TextEditingController();
  final _ownerController = TextEditingController();
  final _ticketCodeController = TextEditingController();

  @override
  void dispose() {
    _licensePlateController.dispose();
    _vehicleTypeController.dispose();
    _brandController.dispose();
    _ownerController.dispose();
    _ticketCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizebox = SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký vé xe xe'),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BlocConsumer<ManageVehicleTicketBloc, ManageVehicleState>(
          listener: (context, state) {
            if (state.createStatus == ManageVehicleStatus.loaded) {
              showSnackBarSuccess(context, 'Đăng ký thành công');
              Navigator.of(context).pop();
            }
            if (state.createStatus == ManageVehicleStatus.error) {
              showSnackBarError(context, state.message);
            }
          },
          builder: (context, state) {
            final ticketSelect = state.ticketSelect;
            if (ticketSelect != null) {
              _licensePlateController.text =
                  ticketSelect.vehicleLicensePlate ?? '';
              _vehicleTypeController.text =
                  ticketSelect.vehicleType == 'motorbike' ? 'Xe máy' : 'Ô tô';
              _brandController.text = ticketSelect.vehicleBarnd ?? '';
              _ownerController.text = ticketSelect.vehicleOwner ?? '';
            }
            bool isLoading = state.createStatus == ManageVehicleStatus.loading;
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizebox,
                  // CustomTextFormField(
                  //   controller: _vehicleTypeController,
                  //   hintText: 'Loại xe',
                  //   validator: (value) => Validators.validateEmpty(value),
                  // ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Loại xe',
                      style: TextStyle(
                        fontSize: 16.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //   ),
                  //   child: StatefulBuilder(
                  //       builder: (BuildContext ctx, StateSetter setState) {
                  //     return Row(
                  //       children: [
                  //         Expanded(
                  //           child: SelectWidget(
                  //             text: 'Xe máy',
                  //             warp: true,
                  //             isSelect:
                  //                 _vehicleTypeController.text == 'motorbike',
                  //             onChanged: () {
                  //               setState(() {
                  //                 _vehicleTypeController.text = 'motorbike';
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //         Expanded(
                  //           child: SelectWidget(
                  //             text: 'Ô tô',
                  //             warp: true,
                  //             isSelect: _vehicleTypeController.text == 'car',
                  //             onChanged: () {
                  //               setState(() {
                  //                 _vehicleTypeController.text = 'car';
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     );
                  //   }),
                  // ),

                  sizebox,
                  CustomTextFormField(
                    controller: _vehicleTypeController,
                    hintText: 'Loại xe xe',
                    readOnly: true,
                    validator: (value) => Validators.validateEmpty(value),
                  ),
                  sizebox,
                  CustomTextFormField(
                    controller: _brandController,
                    readOnly: true,
                    hintText: 'Hãng xe',
                    validator: (value) => Validators.validateEmpty(value),
                  ),
                  sizebox,
                  CustomTextFormField(
                    controller: _licensePlateController,
                    readOnly: true,
                    hintText: 'Biển số xe',
                    validator: (value) => Validators.validateEmpty(value),
                  ),
                  sizebox,
                  CustomTextFormField(
                    controller: _ownerController,
                    readOnly: true,
                    hintText: 'Chủ sở hữu',
                    validator: (value) => Validators.validateEmpty(value),
                  ),
                  sizebox,
                  CustomTextFormField(
                    controller: _ticketCodeController,
                    hintText: 'Mã thẻ xe',
                    validator: (value) => Validators.validateEmpty(value),
                  ),
                  sizebox,

                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CustomButton(
                      isDisable: isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // submit
                          final vehicle = state.ticketSelect?.copyWith(
                                ticketCode: _ticketCodeController.text,
                              ) ??
                              VehicleTicket(
                                vehicleLicensePlate:
                                    _licensePlateController.text,
                                vehicleType: _vehicleTypeController.text,
                                vehicleBarnd: _brandController.text,
                                vehicleOwner: _ownerController.text,
                                ticketCode: _ticketCodeController.text,
                              );

                          context
                              .read<ManageVehicleTicketBloc>()
                              .add(ManageVehicleCreate(vehicle: vehicle));
                        }
                      },
                      title: 'Xác nhận',
                      prefixWidget: isLoading
                          ? Transform.scale(
                              scale: 0.5,
                              child: const CircularProgressIndicator(),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
