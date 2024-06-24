import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Function? onPressed;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? backgroundColor;

  const CustomCircleButton({
    super.key,
    required this.icon,
    required this.iconSize,
    this.onPressed,
    this.margin,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: iconSize,
        color: color,
        onPressed: () => onPressed!(),
      ),
    );
  }
}
