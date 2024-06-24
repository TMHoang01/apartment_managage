import 'package:flutter/material.dart';
import 'package:apartment_managage/domain/models/service/service.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết dịch vụ'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text('Chi tiết dịch vụ$service'),
        ),
      ),
    );
  }
}
