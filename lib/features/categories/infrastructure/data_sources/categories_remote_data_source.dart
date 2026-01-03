import '../../../../core/network/api_client.dart';
import '../entities/category.dart';

class CategoriesRemoteDataSource {
  final ApiClient _client;

  CategoriesRemoteDataSource(this._client);

  Future<List<Category>> getCategories() async {
    final response = await _client.get('/categories');
    return (response.data as List).map((c) => Category.fromJson(c)).toList();
  }

  Future<Category> createCategory(Category category) async {
    final response = await _client.post('/categories', data: category.toJson());
    return Category.fromJson(response.data);
  }

  Future<Category> updateCategory(String id, Category category) async {
    final response = await _client.put('/categories/$id', data: category.toJson());
    return Category.fromJson(response.data);
  }

  Future<void> deleteCategory(String id) async {
    await _client.delete('/categories/$id');
  }
}
