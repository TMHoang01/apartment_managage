part of 'select_resident_bloc.dart';

enum SelectResidentStatus { initial, loading, loaded, error }

class SelectResidentState extends Equatable {
  final SelectResidentStatus status;
  final List<UserModel> list;
  final UserModel? select;
  final SelectResidentStatus? statusSelect;
  final String? message;
  const SelectResidentState(
      {this.status = SelectResidentStatus.initial,
      this.list = const [],
      this.select,
      this.statusSelect,
      this.message});

  @override
  List<Object?> get props =>
      [...list, list.length, status, select, statusSelect, message];

  SelectResidentState copyWith({
    SelectResidentStatus? status,
    List<UserModel>? list,
    UserModel? select,
    SelectResidentStatus? statusSelect,
    String? message,
  }) {
    return SelectResidentState(
      status: status ?? this.status,
      list: list ?? this.list,
      select: select ?? this.select,
      statusSelect: statusSelect ?? this.statusSelect,
      message: message,
    );
  }

  SelectResidentState emptySelect() {
    return SelectResidentState(
      status: status,
      list: list,
      select: null,
      statusSelect: null,
    );
  }
}
