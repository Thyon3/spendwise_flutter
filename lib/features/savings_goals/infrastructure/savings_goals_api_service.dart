import 'package:dio/dio.dart';
import '../domain/savings_goal.dart';

class SavingsGoalsApiService {
  final Dio _dio;
  SavingsGoalsApiService(this._dio);

  Future<List<SavingsGoal>> getAll() async {
    final res = await _dio.get('/savings-goals');
    return (res.data as List).map((e) => SavingsGoal.fromJson(e)).toList();
  }

  Future<SavingsGoal> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/savings-goals', data: data);
    return SavingsGoal.fromJson(res.data);
  }

  Future<SavingsGoal> contribute(String id, double amount) async {
    final res = await _dio.post('/savings-goals/$id/contribute', data: {'amount': amount});
    return SavingsGoal.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/savings-goals/$id');
  }
}
