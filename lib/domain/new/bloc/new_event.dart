part of 'new_bloc.dart';

abstract class NewEvent extends Equatable {
  const NewEvent();

  @override
  List<Object> get props => [];
}

class GetNewPost extends NewEvent {
  const GetNewPost();

  @override
  List<Object> get props => [];
}

class RefreshNewPost extends NewEvent {
  const RefreshNewPost();

  @override
  List<Object> get props => [];
}

class GetUserData extends NewEvent {
  final String id;
  const GetUserData({
    required this.id,
  });
}

class GetNewCacheData extends NewEvent {}

class CleanNewCacheData extends NewEvent {}
