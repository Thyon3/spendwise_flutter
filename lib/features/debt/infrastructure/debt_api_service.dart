import 'package:dio/dio.dart';
import '../domain/debt.dart';

class DebtApiService {
  final Dio _dio;
  DebtApiService(this._dio);

  Future<List<Debt>> getAll() async {
    final res = await _dio.get('/debts');
    return (res.data as List).map((e) => Debt.fromJson(e)).toList();
  }

  Future<Debt> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/debts', data: data);
    return Debt.fromJson(res.data);
  }

  Future<void> addPayment(String debtId, Map<String, dynamic> data) async {
    await _dio.post('/debts/$debtId/payments', data: data);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/debts/$id');
  }

  Future<Map<String, dynamic>> getSummary() async {
    final res = await _dio.get('/debts/summary');
    return res.data as Map<String, dynamic>;
  }
}
