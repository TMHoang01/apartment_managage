import 'package:flutter/material.dart';
import 'package:apartment_managage/utils/constants.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({super.key, required this.child});
  BoxDecoration _boxdecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: kGrayLight.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0.0, 8),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      decoration: _boxdecoration(),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: child,
    );
  }
}
