import 'package:hive/hive.dart';

import '../domain/entity/post.dart';

class LocalData {
  final _popularBox = Hive.openBox('popular_post');
  final _newBox = Hive.openBox('new_post');

  Future<void> addPosts(
      {required String typePosts, required List<Post> posts}) async {
    var box = _typeBox(typePosts);
    for (var post in posts) {
      (await box).add(post);
    }
  }

  Future<List<Post>> getPosts({required String typePosts}) async {
    var box = _typeBox(typePosts);

    List<Post> list = [];
    for (var i = 0; i < (await box).length; i++) {
      if ((await box).getAt(i) != null) {
        list.add((await box).getAt(i));
      }
    }
    return list;
  }

  Future<void> clearPosts({required String typePosts}) async {
    var box = _typeBox(typePosts);
    (await box).deleteFromDisk();
  }

  Future<Box> _typeBox(String typePosts) async {
    if (typePosts == 'new') {
      return _newBox;
    } else {
      return _popularBox;
    }
  }
}
