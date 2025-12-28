import 'package:dio/dio.dart';
import '../domain/subscription.dart';

class SubscriptionsApiService {
  final Dio _dio;
  SubscriptionsApiService(this._dio);

  Future<List<Subscription>> getAll({bool? isActive}) async {
    final res = await _dio.get('/subscriptions', queryParameters: {if (isActive != null) 'isActive': isActive});
    return (res.data as List).map((e) => Subscription.fromJson(e)).toList();
  }

  Future<Subscription> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/subscriptions', data: data);
    return Subscription.fromJson(res.data);
  }

  Future<void> cancel(String id) async {
    await _dio.post('/subscriptions/$id/cancel');
  }

  Future<void> delete(String id) async {
    await _dio.delete('/subscriptions/$id');
  }

  Future<Map<String, dynamic>> getAnalytics() async {
    final res = await _dio.get('/subscriptions/analytics');
    return res.data as Map<String, dynamic>;
  }
}
