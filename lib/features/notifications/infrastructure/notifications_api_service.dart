import 'package:dio/dio.dart';
import '../domain/notification_item.dart';

class NotificationsApiService {
  final Dio _dio;
  NotificationsApiService(this._dio);

  Future<List<NotificationItem>> getAll({bool unreadOnly = false}) async {
    final res = await _dio.get('/notifications', queryParameters: {if (unreadOnly) 'unreadOnly': true});
    return (res.data as List).map((e) => NotificationItem.fromJson(e)).toList();
  }

  Future<int> getUnreadCount() async {
    final res = await _dio.get('/notifications/unread-count');
    return res.data['count'] as int;
  }

  Future<void> markAsRead(String id) async {
    await _dio.put('/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _dio.put('/notifications/read-all');
  }

  Future<void> delete(String id) async {
    await _dio.delete('/notifications/$id');
  }

  Future<void> clearRead() async {
    await _dio.delete('/notifications/clear-read');
  }
}
