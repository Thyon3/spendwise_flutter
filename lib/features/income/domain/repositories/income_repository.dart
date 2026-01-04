import '../entities/income.dart';

abstract class IncomeRepository {
  Future<List<Income>> getIncomes({DateTime? from, DateTime? to});
  Future<Income> createIncome(Income income);
  Future<Income> updateIncome(Income income);
  Future<void> deleteIncome(String id);
}
