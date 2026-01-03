import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/tag.dart';
import '../domain/repositories/tag_repository.dart';
import '../infrastructure/expenses_infrastructure_providers.dart';

class TagListNotifier extends StateNotifier<AsyncValue<List<Tag>>> {
  final TagRepository _repository;

  TagListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadTags();
  }

  Future<void> loadTags() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getTags());
  }

  Future<void> addTag(String name) async {
    try {
      await _repository.createTag(name);
      loadTags();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTag(String id) async {
    try {
      await _repository.deleteTag(id);
      loadTags();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final tagListProvider = StateNotifierProvider<TagListNotifier, AsyncValue<List<Tag>>>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return TagListNotifier(repository);
});
