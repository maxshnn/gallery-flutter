part of 'popular_bloc.dart';

abstract class PopularEvent extends Equatable {
  const PopularEvent();

  @override
  List<Object> get props => [];
}

class GetPopularPost extends PopularEvent {
  const GetPopularPost();

  @override
  List<Object> get props => [];
}

class RefreshPopularPost extends PopularEvent {
  const RefreshPopularPost();

  @override
  List<Object> get props => [];
}

class GetUserData extends PopularEvent {
  final String id;
  const GetUserData({
    required this.id,
  });
}

class GetPopularCacheData extends PopularEvent {}

class CleanPopularCacheData extends PopularEvent {}
