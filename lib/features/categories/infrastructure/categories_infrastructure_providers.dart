import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../../domain/repositories/category_repository.dart';
import '../data_sources/categories_remote_data_source.dart';
import '../repositories/category_repository_impl.dart';

final categoriesRemoteDataSourceProvider = Provider<CategoriesRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CategoriesRemoteDataSource(apiClient);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remoteDataSource = ref.watch(categoriesRemoteDataSourceProvider);
  return CategoryRepositoryImpl(remoteDataSource);
});
