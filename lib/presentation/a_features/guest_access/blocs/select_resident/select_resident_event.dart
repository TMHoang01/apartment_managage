part of 'select_resident_bloc.dart';

sealed class SelectResidentEvent extends Equatable {
  const SelectResidentEvent();

  @override
  List<Object> get props => [];
}

class SelectResidentStarted extends SelectResidentEvent {}

class SelectResidentSelect extends SelectResidentEvent {
  final UserModel resident;
  const SelectResidentSelect({required this.resident});
}

class SelectResidentSelectSave extends SelectResidentEvent {}

class SelectResidentSelectReset extends SelectResidentEvent {}
