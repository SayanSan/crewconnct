import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../repositories/mock_repository.dart';

class NotificationState {
  final bool isLoading;
  final List<NotificationModel> notifications;

  const NotificationState({
    this.isLoading = false,
    this.notifications = const [],
  });

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationModel>? notifications,
    String? error,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      error: error,
    );
  }

  int get unreadCount => notifications.where((n) => !n.read).length;
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final INotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const NotificationState());

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final notifs = await _repository.fetchNotifications();
      state = state.copyWith(
        isLoading: false,
        notifications: notifs,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markAsRead(String notificationId) async {
    state = state.copyWith(error: null);
    try {
      await _repository.markAsRead(notificationId);
      final updated = state.notifications.map((n) {
        if (n.id == notificationId) return n.copyWith(read: true);
        return n;
      }).toList();
      state = state.copyWith(notifications: updated);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});
