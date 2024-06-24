import 'package:apartment_managage/utils/utils.dart';
import 'package:flutter/material.dart';

class ChipCard extends StatelessWidget {
  final Color? backgroundColor;
  final String label;
  final Function? onTap;
  const ChipCard({
    super.key,
    this.backgroundColor,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? kGrayLight,
        border: Border.all(
          color: backgroundColor ?? kGrayLight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
