import 'package:apartment_managage/presentation/a_features/parking/blocs/parking_checkin/parking_checkin_bloc.dart';
import 'package:apartment_managage/presentation/a_features/parking/screens/paking/widgets/parking_in_widget.dart';
import 'package:apartment_managage/presentation/a_features/parking/screens/paking/widgets/parking_out_widget.dart';
import 'package:apartment_managage/presentation/widgets/show_snackbar.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParkingInOutScreen extends StatefulWidget {
  const ParkingInOutScreen({super.key});

  @override
  State<ParkingInOutScreen> createState() => _ParkingInOutScreenState();
}

class _ParkingInOutScreenState extends State<ParkingInOutScreen> {
  bool isParkingIn = true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ParkingCheckInBloc>()
      ..add(ParkingCheckInStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Xe vào ra '),
      ),
      body: BlocConsumer<ParkingCheckInBloc, ParkingCheckInState>(
        listener: (context, state) {
          if (state.status == ParkingCheckInStatus.error) {
            showSnackBarError(context, state.message);
            print('error ${state.message}');
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                // Container(
                //   height: 200,
                //   color: Colors.blue,
                // ),
                Container(
                  height: 50,
                  color: Colors.red,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isParkingIn = true;
                            });
                          },
                          child: Container(
                            color: isParkingIn ? Colors.white : kPrimaryColor,
                            child: const Center(
                              child: Text('Xe vào'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isParkingIn = false;
                            });
                          },
                          child: Container(
                            color: isParkingIn ? kPrimaryColor : Colors.white,
                            child: const Center(
                              child: Text('Xe ra'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isParkingIn)
                  const ParkingInWidget()
                else
                  const ParkingOutWidget()
              ],
            ),
          );
        },
      ),
    );
  }
}
