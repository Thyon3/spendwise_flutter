import '../../../../core/network/api_client.dart';
import '../../domain/entities/tag.dart';
import '../../domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final ApiClient _client;

  TagRepositoryImpl(this._client);

  @override
  Future<List<Tag>> getTags() async {
    final response = await _client.get('/tags');
    return (response.data as List).map((t) => Tag.fromJson(t)).toList();
  }

  @override
  Future<Tag> createTag(String name) async {
    final response = await _client.post('/tags', data: {'name': name});
    return Tag.fromJson(response.data);
  }

  @override
  Future<void> deleteTag(String id) async {
    await _client.delete('/tags/$id');
  }
}
