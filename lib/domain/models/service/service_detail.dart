import 'package:equatable/equatable.dart';

class ServiceDetail extends Equatable {
  const ServiceDetail();
  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() {
    return {};
  }

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return const ServiceDetail();
  }

  ServiceDetail copyWith() {
    return const ServiceDetail();
  }
}
