import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/domain/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'select_resident_event.dart';
part 'select_resident_state.dart';

class SelectResidentBloc
    extends Bloc<SelectResidentEvent, SelectResidentState> {
  final UserRepository userRepository;
  SelectResidentBloc(this.userRepository) : super(const SelectResidentState()) {
    on<SelectResidentEvent>((event, emit) {});
    on<SelectResidentStarted>(_onStarted);
    on<SelectResidentSelectSave>(_onSelectSave);
    on<SelectResidentSelectReset>(_onSelectReset);
    on<SelectResidentSelect>(_onSelect);
  }

  void _onStarted(
      SelectResidentStarted event, Emitter<SelectResidentState> emit) async {
    emit(state.copyWith(status: SelectResidentStatus.loading));
    try {
      final list = await userRepository.getListUsers('resident');
      emit(state.copyWith(status: SelectResidentStatus.loaded, list: list));
    } catch (e) {
      emit(
        state.copyWith(
            status: SelectResidentStatus.error, message: e.toString()),
      );
    }
  }

  void _onSelect(
      SelectResidentSelect event, Emitter<SelectResidentState> emit) {
    emit(state.copyWith(
      select: event.resident,
      statusSelect: SelectResidentStatus.loading,
    ));
  }

  void _onSelectSave(
      SelectResidentSelectSave event, Emitter<SelectResidentState> emit) {
    emit(state.copyWith(statusSelect: SelectResidentStatus.loaded));
  }

  void _onSelectReset(
      SelectResidentSelectReset event, Emitter<SelectResidentState> emit) {
    emit(state.emptySelect());
  }
}
