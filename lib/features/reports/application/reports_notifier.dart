import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/report.dart';
import '../domain/repositories/reports_repository.dart';
import '../infrastructure/reports_infrastructure_providers.dart';

class ReportsSummaryNotifier extends StateNotifier<AsyncValue<TimeRangeReport>> {
  final ReportsRepository _repository;

  ReportsSummaryNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadSummary({
    required DateTime from,
    required DateTime to,
    List<String>? categoryIds,
    List<String>? tagIds,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getSpendingSummary(
          from: from,
          to: to,
          categoryIds: categoryIds,
          tagIds: tagIds,
        ));
  }
}

class ReportsTrendsNotifier extends StateNotifier<AsyncValue<TrendReport>> {
  final ReportsRepository _repository;

  ReportsTrendsNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadTrends({
    required DateTime from,
    required DateTime to,
    required String granularity,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getSpendingTrends(
          from: from,
          to: to,
          granularity: granularity,
        ));
  }
}

final reportsSummaryProvider = StateNotifierProvider<ReportsSummaryNotifier, AsyncValue<TimeRangeReport>>((ref) {
  final repository = ref.watch(reportsRepositoryProvider);
  return ReportsSummaryNotifier(repository);
});

final reportsTrendsProvider = StateNotifierProvider<ReportsTrendsNotifier, AsyncValue<TrendReport>>((ref) {
  final repository = ref.watch(reportsRepositoryProvider);
  return ReportsTrendsNotifier(repository);
});
