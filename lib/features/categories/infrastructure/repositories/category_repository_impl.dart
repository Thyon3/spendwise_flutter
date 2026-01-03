import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../data_sources/categories_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoriesRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Category>> getCategories() => _remoteDataSource.getCategories();

  @override
  Future<Category> createCategory(Category category) => _remoteDataSource.createCategory(category);

  @override
  Future<Category> updateCategory(String id, Category category) => _remoteDataSource.updateCategory(id, category);

  @override
  Future<void> deleteCategory(String id) => _remoteDataSource.deleteCategory(id);
}
