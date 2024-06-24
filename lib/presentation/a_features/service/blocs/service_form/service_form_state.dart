part of 'service_form_bloc.dart';

enum ServiceFormStatus { initial, loading, success, failure }

final class ServiceFormState extends Equatable {
  const ServiceFormState({
    this.service,
    this.status = ServiceFormStatus.initial,
    this.message = '',
  });
  final ServiceFormStatus status;
  final ServiceModel? service;
  get isAddForm => service == null || service!.id == null;
  final String message;

  ServiceFormState copyWith({
    ServiceModel? service,
    ServiceFormStatus? status,
    String? message,
  }) {
    return ServiceFormState(
      service: service ?? this.service,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, service, message];
}
