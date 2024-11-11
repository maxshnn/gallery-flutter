part of 'new_bloc.dart';

abstract class NewState extends Equatable {
  final int? page;
  final List<Post>? posts;
  final User? user;
  final String? error;
  const NewState({
    this.page,
    this.posts,
    this.user,
    this.error,
  });
}

class NewLoading extends NewState {
  @override
  List<Object?> get props => [];
}

class NewLoaded extends NewState {
  const NewLoaded({
    required super.page,
    required super.posts,
    super.user,
  });

  @override
  List<Object?> get props => [posts, page];

  NewLoaded copyWith({
    int? page,
    List<Post>? posts,
  }) {
    return NewLoaded(
      page: page ?? this.page,
      posts: posts ?? this.posts,
    );
  }
}

class NewCache extends NewState {
  final List<Post>? posts;
  const NewCache({
    required this.posts,
  });

  @override
  List<Object?> get props => [posts];
}

class NewError extends NewState {
  final String error;
  const NewError({
    required this.error,
  });
  @override
  List<Object?> get props => [error];
}
