import 'package:dio/dio.dart';
import '../domain/wishlist_item.dart';

class WishlistApiService {
  final Dio _dio;
  WishlistApiService(this._dio);

  Future<List<WishlistItem>> getAll({bool pendingOnly = false}) async {
    final res = await _dio.get('/wishlist', queryParameters: {if (pendingOnly) 'pending': true});
    return (res.data as List).map((e) => WishlistItem.fromJson(e)).toList();
  }

  Future<WishlistItem> create(Map<String, dynamic> data) async {
    final res = await _dio.post('/wishlist', data: data);
    return WishlistItem.fromJson(res.data);
  }

  Future<WishlistItem> markPurchased(String id) async {
    final res = await _dio.post('/wishlist/$id/mark-purchased');
    return WishlistItem.fromJson(res.data);
  }

  Future<void> delete(String id) async {
    await _dio.delete('/wishlist/$id');
  }
}
