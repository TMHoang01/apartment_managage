import 'package:flutter/material.dart';

class ParkingInOutScreen extends StatelessWidget {
  const ParkingInOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xe vào ra '),
      ),
      body: const Center(
        child: Text('Quản lý vào ra xe'),
      ),
    );
  }
}
