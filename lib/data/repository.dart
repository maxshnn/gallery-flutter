import 'package:dio/dio.dart';
import '../const.dart';
import '../domain/entity/post.dart';
import '../domain/entity/user.dart';

class Repository {
  final Dio _dio = Dio();
  final String _urlPhoto = baseUrl + photosUrl;

  Future<Map<String, dynamic>> getPosts(
      {required String trend, required int page, required limit}) async {
    try {
      var response = await _dio.get(_urlPhoto,
          queryParameters: {trend: true, 'page': page, 'limit': limit});
      return {
        'status': response.statusCode,
        'data':
            (response.data['data'] as List).map((e) => Post.fromMap(e)).toList()
      };
      // return (response.data['data'] as List).map((e) => Post.fromMap(e)).toList();
    } on DioError catch (e) {
      if (e.message != null && e.response != null) {
        return {'status': e.response?.statusCode, 'data': e.message};
      } else {
        return {'status': null, 'data': e.error};
      }
    }
  }

  Future<User> getUserInfo(int id) async {
    var response = await _dio.get(baseUrl + userUrl + id.toString());
    return User.fromMap(response.data);
  }

  Future<List<User>> getAllUser() async {
    try {
      var response = await _dio
          .get(baseUrl + userUrl, queryParameters: {'limit': 1000000});
      return (response.data['data'] as List)
          .map((e) => User.fromMap(e))
          .toList();
    } on DioError catch (e) {
      return [];
    }
  }
}
