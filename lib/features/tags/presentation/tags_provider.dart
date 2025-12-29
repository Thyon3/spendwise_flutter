import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/tag.dart';
import '../infrastructure/tags_api_service.dart';

final tagsApiServiceProvider = Provider<TagsApiService>(
  (ref) => TagsApiService(ref.watch(dioProvider)),
);

final tagsProvider = AsyncNotifierProvider<TagsNotifier, List<Tag>>(TagsNotifier.new);

class TagsNotifier extends AsyncNotifier<List<Tag>> {
  @override
  Future<List<Tag>> build() async {
    return ref.read(tagsApiServiceProvider).getTags();
  }

  Future<void> createTag(String name) async {
    final service = ref.read(tagsApiServiceProvider);
    final newTag = await service.createTag(name);
    state = AsyncData([...state.value ?? [], newTag]);
  }

  Future<void> deleteTag(String id) async {
    await ref.read(tagsApiServiceProvider).deleteTag(id);
    state = AsyncData((state.value ?? []).where((t) => t.id != id).toList());
  }
}
