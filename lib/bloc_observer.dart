import 'package:apartment_managage/utils/logger.dart';
import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    logger.d('bloc transition  ${bloc.runtimeType}:\n'
        'bloc   ${transition.currentState.runtimeType} ->'
        'event ${transition.event.runtimeType} '
        'bloc -> ${transition.nextState.runtimeType}');
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    // logger.d('event ${bloc.runtimeType}: $event');
    super.onEvent(bloc, event);
  }

  @override
  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
  }
}
