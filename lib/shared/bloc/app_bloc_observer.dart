import 'package:Dividex/shared/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.i('[Bloc Event] ${bloc.runtimeType}: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.i('[Bloc Transition] $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e('[Bloc Error] ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
