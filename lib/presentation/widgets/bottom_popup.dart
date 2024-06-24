import 'package:flutter/material.dart';
import 'package:apartment_managage/utils/constants.dart';

void showBottomSheetApp({
  required BuildContext context,
  required Widget child,
  String title = '',
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Wrap(
      children: [
        BottomPopup(child: child, title: title),
      ],
    ),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  );
}

class BottomPopup extends StatelessWidget {
  final Widget child;
  final String title;

  const BottomPopup({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var fullWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: _theme.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      width: fullWidth,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: kDark,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          title.isEmpty
              ? Text(title, style: _theme.textTheme.titleMedium)
              : Container(),
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
          ),
          child
        ],
      ),
    );
  }
}
