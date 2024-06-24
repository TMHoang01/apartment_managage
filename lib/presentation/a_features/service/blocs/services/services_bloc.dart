import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/service/service.dart';
import 'package:apartment_managage/domain/repository/service/service_repository.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServiceRepository serviceRepository;
  ServicesBloc(this.serviceRepository) : super(ServicesInitial()) {
    on<ServicesEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ServicesStarted>((event, emit) async {
      emit(ServicesLoading());
      try {
        await emit.forEach(
          serviceRepository.getAll(),
          onData: (List<ServiceModel> services) {
            if (services.isEmpty) {
              return ServicesFailure('Danh sách dịch vụ trống');
            }
            return ServicesLoaded(services: services);
          },
          onError: (e, stackTrace) => ServicesFailure(e.toString()),
        );
      } catch (e) {
        emit(ServicesFailure(e.toString()));
      }
    });
  }
}
