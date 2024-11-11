part of 'connectivity_bloc.dart';

enum ConnectivityStatus { notAllowInternet, succes, notConnected }

abstract class ConnectivityState extends Equatable {
  final ConnectivityStatus? status;
  final String? error;
  const ConnectivityState({
    this.status,
    this.error,
  });

  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivitySucces extends ConnectivityState {}

class ConnectivityError extends ConnectivityState {}
