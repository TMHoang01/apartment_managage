import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final bool value;
  final double? height;
  final Function(bool?)? onChanged;
  const CustomCheckBox({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: SizedBox(
        height: height ?? 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
