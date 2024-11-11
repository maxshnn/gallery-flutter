import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gallery/data/local_data.dart';
import 'package:gallery/data/repository.dart';
import 'package:gallery/domain/entity/post.dart';
import 'package:gallery/domain/entity/user.dart';

import '../../../const.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  PopularBloc() : super(PopularLoading()) {
    on<GetPopularPost>(_onGetPopularPost);
    on<RefreshPopularPost>(_onRefreshPopularPost);
    on<GetUserData>(_onGetUserData);
    on<GetPopularCacheData>(_onGetPopularCacheData);
    on<CleanPopularCacheData>(_onCleanPopularCacheData);
  }

  final _repository = Repository();
  final _cacheData = LocalData();

  _onGetPopularCacheData(GetPopularCacheData event, Emitter emit) async {
    List<Post> posts = await _cacheData.getPosts(typePosts: 'popular');
    posts.isNotEmpty
        ? emit(PopularCache(posts: posts))
        : emit(PopularError(error: state.error.toString()));
  }

  _onCleanPopularCacheData(CleanPopularCacheData event, Emitter emit) {
    state.posts?.clear();
    emit(PopularLoading());
  }

  _onGetPopularPost(GetPopularPost event, Emitter emit) async {
    Map<String, dynamic> data = await _getPost(
        'popular', state.page != null ? state.page! + 1 : 1,
        emit: emit);
    if (_getStatus(data) == 200) {
      List<Post> post = data['data'];
      emit(PopularLoaded(
          page: state.page != null ? state.page! + 1 : 1,
          posts: state.posts != null ? state.posts! + post : post));
      var cachePosts = await _cacheData.getPosts(typePosts: 'popular');
      if (cachePosts.length < (state.posts?.length ?? 10) &&
          cachePosts.hashCode != state.posts.hashCode) {
        _cacheData.addPosts(typePosts: 'popular', posts: post);
      }
    }
  }

  _onRefreshPopularPost(RefreshPopularPost event, Emitter emit) async {
    emit(PopularLoading());
    Map<String, dynamic> data = await _getPost('popular', 1, emit: emit);
    if (_getStatus(data) == 200) {
      List<Post> post = data['data'];
      emit(PopularLoaded(page: 1, posts: post));
    }
  }

  _getPost(String trend, int page, {required Emitter emit}) async {
    Map<String, dynamic> data =
        await _repository.getPosts(trend: trend, limit: 10, page: page);
    if (_getStatus(data) == 200) {
      var post = data['data'];
      for (int i = 0; i < post.length; i++) {
        if (post[i].image?.name == null) {
          post.removeAt(i);
        } else {
          post[i].image?.name = baseUrl + mediaUrl + post[i].image!.name;
        }
      }
      return {'status': '200', 'data': post};
    } else {
      emit(PopularError(error: data['data'].toString()));
      Future.delayed(
        const Duration(seconds: 3),
        () => add(GetPopularCacheData()),
      );
      return {'status': '400'};
    }
  }

  int _getStatus(Map<String, dynamic> data) {
    if (data['status'] == 200 && data['status'] != null ||
        data['status'] == '200') {
      return 200;
    } else {
      return 400;
    }
  }

  _onGetUserData(GetUserData event, Emitter emit) async {
    int id = int.parse(event.id.split('/').last);
    User user = await _repository.getUserInfo(id);
    emit(PopularLoaded(page: state.page, posts: state.posts, user: user));
  }
}
