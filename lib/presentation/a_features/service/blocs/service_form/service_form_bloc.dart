import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/service/enum_service.dart';
import 'package:apartment_managage/domain/models/service/service.dart';
import 'package:apartment_managage/domain/repository/file_repository.dart';
import 'package:apartment_managage/domain/repository/service/service_repository.dart';
import 'package:apartment_managage/utils/logger.dart';

part 'service_form_event.dart';
part 'service_form_state.dart';

class ServiceFormBloc extends Bloc<ServiceFormEvent, ServiceFormState> {
  final ServiceRepository serviceRepository;
  final FileRepository fileRepository;
  ServiceFormBloc(this.serviceRepository, this.fileRepository)
      : super(const ServiceFormState()) {
    on<ServiceFormEditStarted>(_onServiceFormEditStarted);
    on<ServiceFormAddStarted>(_onServiceFormAddStarted);
    on<ServiceFormSubmit>(_onServiceFormSubmit);

    on<ServiceFormPriceTypeChanged>(_onServiceFormPriceTypeChanged);
    on<ServiceFormPriceBaseChanged>(_onServiceFormPriceBaseChanged);
  }

  void _onServiceFormEditStarted(
    ServiceFormEditStarted event,
    Emitter<ServiceFormState> emit,
  ) async {
    emit(state.copyWith(
      service: event.service,
    ));
  }

  void _onServiceFormAddStarted(
    ServiceFormAddStarted event,
    Emitter<ServiceFormState> emit,
  ) async {
    emit(state.copyWith(
      service: ServiceModel(),
    ));
  }

  void _onServiceFormSubmit(
    ServiceFormSubmit event,
    Emitter<ServiceFormState> emit,
  ) async {
    emit(state.copyWith(status: ServiceFormStatus.loading));
    try {
      final url = await _uploadFile(
        imagePath: event.file,
      );
      ServiceModel service = event.service.copyWith(
        image: url,
      );
      if (state.isAddForm) {
        service = service.copyWith(
          createdAt: DateTime.now(),
          createdBy: 'admin',
        );
        await serviceRepository.add(service: service);
      } else {
        service = service.copyWith(
          updatedAt: DateTime.now(),
          updatedBy: 'admin',
        );
        Map<String, dynamic> serviceJson = state.service!.toJson();
        serviceJson.addAll(service.toJson());
        service = ServiceModel.fromJson(serviceJson);

        await serviceRepository.update(service: service);
      }
      emit(state.copyWith(
        status: ServiceFormStatus.success,
        service: service,
      ));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: ServiceFormStatus.failure));
    }
  }

  Future<String?> _uploadFile(
      {required String imagePath, String? urlOld}) async {
    try {
      if (imagePath.isEmpty) return urlOld;
      File file = File(imagePath);
      String name = DateTime.now().millisecondsSinceEpoch.toString();
      name = '$name.${imagePath.split('.').last}';

      String imageUrl = await fileRepository.uploadFile(
        file: file,
        path: 'images/services/$name',
        urlOld: urlOld,
      );
      return imageUrl;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  void _onServiceFormPriceTypeChanged(
    ServiceFormPriceTypeChanged event,
    Emitter<ServiceFormState> emit,
  ) async {
    final service = state.service!.copyWith(
      priceType: event.priceType,
    );
    emit(state.copyWith(service: service));
  }

  void _onServiceFormPriceBaseChanged(
    ServiceFormPriceBaseChanged event,
    Emitter<ServiceFormState> emit,
  ) async {
    final service = state.service!.copyWith(
      priceBase: event.priceBase,
    );
    emit(state.copyWith(service: service));
  }
}
