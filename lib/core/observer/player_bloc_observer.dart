import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';

class PlayerBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (bloc is PlayerBloc) {
      developer.log('event=${event.runtimeType}', name: 'PlayerObserver');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (bloc is PlayerBloc) {
      developer.log(
        'track=${transition.nextState.currentTrack?.id} '
        'requestId=${transition.nextState.activeRequestId} '
        'status=${transition.nextState.status} '
        'duration=${transition.nextState.duration.inSeconds}s',
        name: 'PlayerObserver',
      );
    }
  }
}
