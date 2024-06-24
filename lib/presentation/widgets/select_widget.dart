import 'package:flutter/material.dart';
import 'package:apartment_managage/utils/constants.dart';

class SelectWidget extends StatelessWidget {
  final String text;
  final String? subTitle;
  final Function? onChanged;
  final bool warp;
  final bool isSelect;
  final double? fontSize;
  final Color color;
  final TextAlign? textAlign;
  const SelectWidget(
      {super.key,
      required this.text,
      this.subTitle,
      this.onChanged,
      required this.isSelect,
      this.warp = false,
      this.fontSize = 16,
      this.color = kSecondaryColor,
      this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: InkWell(
        onTap: () {
          if (onChanged != null) {
            onChanged!();
          }
        },
        child: Container(
          width: !warp ? size.width : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelect ? color.withOpacity(0.3) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelect ? color : Colors.grey,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                text,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontSize: fontSize,
                ),
                textAlign: textAlign,
              ),
              // show if subTitle
              if (subTitle != null) Text(subTitle ?? '')
            ],
          ),
        ),
      ),
    );
  }
}
