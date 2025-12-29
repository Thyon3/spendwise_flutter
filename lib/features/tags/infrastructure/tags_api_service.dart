import 'package:dio/dio.dart';
import '../domain/tag.dart';

class TagsApiService {
  final Dio _dio;

  TagsApiService(this._dio);

  Future<List<Tag>> getTags() async {
    final response = await _dio.get('/tags');
    return (response.data as List).map((e) => Tag.fromJson(e)).toList();
  }

  Future<Tag> createTag(String name) async {
    final response = await _dio.post('/tags', data: {'name': name});
    return Tag.fromJson(response.data);
  }

  Future<void> deleteTag(String id) async {
    await _dio.delete('/tags/$id');
  }
}
