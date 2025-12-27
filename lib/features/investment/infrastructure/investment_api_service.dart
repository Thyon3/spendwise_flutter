import 'package:dio/dio.dart';
import '../domain/investment.dart';

class InvestmentApiService {
  final Dio _dio;
  InvestmentApiService(this._dio);

  Future<List<Investment>> getAll() async {
    final res = await _dio.get('/investments');
    return (res.data as List).map((e) => Investment.fromJson(e)).toList();
  }

  Future<Investment> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/investments', data: data);
    return Investment.fromJson(res.data);
  }

  Future<Investment> updatePrice(String id, double currentPrice) async {
    final res = await _dio.put('/investments/$id', data: {'currentPrice': currentPrice});
    return Investment.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/investments/$id');
  }

  Future<Map<String, dynamic>> getPortfolio() async {
    final res = await _dio.get('/investments/portfolio');
    return res.data as Map<String, dynamic>;
  }
}
