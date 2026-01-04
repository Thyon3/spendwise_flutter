import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/reports_remote_data_source.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../domain/entities/financial_summary.dart';

final reportsRemoteDataSourceProvider = Provider<ReportsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReportsRemoteDataSourceImpl(apiClient);
});

final reportsRepositoryProvider = Provider<ReportsRepositoryImpl>((ref) {
  final remote = ref.watch(reportsRemoteDataSourceProvider);
  return ReportsRepositoryImpl(remote);
});

final financialSummaryProvider = FutureProvider.family<FinancialSummary, DateTimeRange>((ref, range) async {
  final repository = ref.watch(reportsRepositoryProvider);
  return repository.getFinancialSummary(from: range.start, to: range.end);
});
