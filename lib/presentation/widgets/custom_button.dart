import 'package:flutter/material.dart';
import 'package:apartment_managage/utils/constants.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      this.margin,
      this.isDisable = false,
      this.onPressed,
      this.width,
      this.height,
      this.title,
      this.backgroundColor,
      this.prefixWidget,
      this.suffixWidget});

  EdgeInsetsGeometry? margin;

  bool? isDisable;

  VoidCallback? onPressed;

  double? width;

  double? height;

  String? title;

  Color? backgroundColor;

  Widget? prefixWidget;

  Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      // padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 48,
        child: ElevatedButton(
          onPressed: isDisable == true ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? kPrimaryColor.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              prefixWidget ?? const SizedBox.shrink(),
              Text(
                title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              suffixWidget ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
