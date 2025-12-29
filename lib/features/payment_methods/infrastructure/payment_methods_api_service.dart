import 'package:dio/dio.dart';
import '../domain/payment_method.dart';

class PaymentMethodsApiService {
  final Dio _dio;
  PaymentMethodsApiService(this._dio);

  Future<List<PaymentMethod>> getAll() async {
    final res = await _dio.get('/payment-methods');
    return (res.data as List).map((e) => PaymentMethod.fromJson(e)).toList();
  }

  Future<PaymentMethod> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/payment-methods', data: data);
    return PaymentMethod.fromJson(res.data);
  }

  Future<PaymentMethod> update(String id, Map<String, dynamic> data) async {
    final res = await _dio.put('/payment-methods/$id', data: data);
    return PaymentMethod.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/payment-methods/$id');
  }

  Future<PaymentMethod> setDefault(String id) async {
    final res = await _dio.post('/payment-methods/$id/set-default');
    return PaymentMethod.fromJson(res.data);
  }
}
