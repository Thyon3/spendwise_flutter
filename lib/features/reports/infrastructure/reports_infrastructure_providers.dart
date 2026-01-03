import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/repositories/reports_repository.dart';
import 'data_sources/reports_remote_data_source.dart';
import 'repositories/reports_repository_impl.dart';

final reportsRemoteDataSourceProvider = Provider<ReportsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReportsRemoteDataSource(apiClient);
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  final remoteDataSource = ref.watch(reportsRemoteDataSourceProvider);
  return ReportsRepositoryImpl(remoteDataSource);
});
