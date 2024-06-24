import 'package:flutter/material.dart';
import 'package:apartment_managage/router.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            if (navService.canPop(context)) {
              navService.pop(context);
            } else {
              navService.pushNamedAndRemoveUntil(context, '/');
            }
          },
          child: const Text('Not Found'),
        ),
      ),
    );
  }
}
