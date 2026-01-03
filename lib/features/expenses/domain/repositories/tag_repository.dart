import '../entities/tag.dart';

abstract class TagRepository {
  Future<List<Tag>> getTags();
  Future<Tag> createTag(String name);
  Future<void> deleteTag(String id);
}
