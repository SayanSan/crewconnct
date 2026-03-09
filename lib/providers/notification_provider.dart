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
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
    );
  }

  int get unreadCount => notifications.where((n) => !n.read).length;
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState());

  Future<void> loadNotifications(String userId) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 400));
    final userNotifs = MockRepository.mockNotifications
        .where((n) => n.userId == userId)
        .toList();
    state = state.copyWith(isLoading: false, notifications: userNotifs);
  }

  void markAsRead(String notificationId) {
    final updated = state.notifications.map((n) {
      if (n.id == notificationId) return n.copyWith(read: true);
      return n;
    }).toList();
    state = state.copyWith(notifications: updated);
  }

  void markAllAsRead() {
    final updated = state.notifications.map((n) => n.copyWith(read: true)).toList();
    state = state.copyWith(notifications: updated);
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});
