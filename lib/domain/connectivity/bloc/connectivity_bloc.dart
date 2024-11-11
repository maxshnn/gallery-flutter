import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  StreamSubscription? _connectivityStream;
  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<Connected>(
      (event, emit) {
        emit(ConnectivitySucces());
      },
    );
    on<NotConnected>(
      (event, emit) {
        emit(ConnectivityError());
      },
    );
    on<CheckConnection>((event, emit) async {
      ConnectivityResult result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        add(Connected());
      } else {
        add(NotConnected());
      }
    });

    _connectivityStream = _checkConnection();
  }
  _checkConnection() {
    return Connectivity()
        .onConnectivityChanged
        .asBroadcastStream()
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        add(Connected());
      } else {
        add(NotConnected());
      }
    });
  }

  @override
  Future<void> close() async {
    _connectivityStream?.cancel();
    return super.close();
  }
}
