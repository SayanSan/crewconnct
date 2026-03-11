import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import 'base_repository.dart';
import 'mock_repository.dart';

class MockNotificationRepository implements INotificationRepository {
  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockRepository.mockNotifications;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

class ApiNotificationRepository implements INotificationRepository {
  final String baseUrl;
  final String token;

  ApiNotificationRepository({required this.baseUrl, this.token = 'dev-token'});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/notifications'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List notifsJson = json.decode(response.body);
      return notifsJson.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch notifications: ${response.statusCode}');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }
}
