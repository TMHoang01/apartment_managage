part of 'services_bloc.dart';

sealed class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

final class ServicesStarted extends ServicesEvent {}
