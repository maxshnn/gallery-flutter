import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../const.dart';
import '../../../data/local_data.dart';
import '../../../data/repository.dart';
import '../../entity/post.dart';
import '../../entity/user.dart';

part 'new_event.dart';
part 'new_state.dart';

class NewBloc extends Bloc<NewEvent, NewState> {
  NewBloc() : super(NewLoading()) {
    on<GetNewPost>(_onGetNewPost);
    on<RefreshNewPost>(_onRefreshNewPost);
    on<GetUserData>(_onGetUserData);
    on<GetNewCacheData>(_onGetNewCacheData);
    on<CleanNewCacheData>(_onCleanNewCacheData);
  }
  final _repository = Repository();
  final _cacheData = LocalData();

  _onGetNewCacheData(GetNewCacheData event, Emitter emit) async {
    List<Post> posts = await _cacheData.getPosts(typePosts: 'new');
    posts.isNotEmpty
        ? emit(NewCache(posts: posts))
        : emit(NewError(error: state.error.toString()));
  }

  _onCleanNewCacheData(CleanNewCacheData event, Emitter emit) {
    state.posts?.clear();
    emit(NewLoading());
  }

  _onGetNewPost(GetNewPost event, Emitter emit) async {
    Map<String, dynamic> data = await _getPost(
        'new', state.page != null ? state.page! + 1 : 1,
        emit: emit);
    if (_getStatus(data) == 200) {
      List<Post> post = data['data'];
      emit(NewLoaded(
          page: state.page != null ? state.page! + 1 : 1,
          posts: state.posts != null ? state.posts! + post : post));
      var cachePosts = await _cacheData.getPosts(typePosts: 'new');
      if (cachePosts.length < (state.posts?.length ?? 10) &&
          cachePosts.hashCode != state.posts.hashCode) {
        _cacheData.addPosts(typePosts: 'new', posts: post);
      }
    }
  }

  _onRefreshNewPost(RefreshNewPost event, Emitter emit) async {
    emit(NewLoading());
    Map<String, dynamic> data = await _getPost('new', 1, emit: emit);
    if (_getStatus(data) == 200) {
      List<Post> post = data['data'];
      emit(NewLoaded(page: 1, posts: post));
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
    emit(NewLoaded(page: state.page, posts: state.posts, user: user));
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
      emit(NewError(error: data['data'].toString()));
      Future.delayed(
        const Duration(seconds: 3),
        () => add(GetNewCacheData()),
      );
      return {'status': '400'};
    }
  }
}
