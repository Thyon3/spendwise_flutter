import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/category.dart';
import '../domain/repositories/category_repository.dart';
import '../infrastructure/categories_infrastructure_providers.dart';

class CategoryListNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final CategoryRepository _repository;

  CategoryListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getCategories());
  }

  Future<void> addCategory(String name, String color) async {
    try {
      final newCategory = Category(id: '', name: name, color: color, userId: '');
      await _repository.createCategory(newCategory);
      loadCategories();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateCategory(String id, String name, String color) async {
    try {
      final updatedCategory = Category(id: id, name: name, color: color, userId: '');
      await _repository.updateCategory(id, updatedCategory);
      loadCategories();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
      loadCategories();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final categoryListProvider = StateNotifierProvider<CategoryListNotifier, AsyncValue<List<Category>>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryListNotifier(repository);
});
