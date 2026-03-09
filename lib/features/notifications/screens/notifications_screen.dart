import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = ref.read(authProvider).user?.id;
      if (userId != null) {
        ref.read(notificationProvider.notifier).loadNotifications(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifState.unreadCount > 0)
            TextButton(
              onPressed: () =>
                  ref.read(notificationProvider.notifier).markAllAsRead(),
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: notifState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifState.notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_off_outlined,
                          size: 64, color: AppColors.darkTextTertiary),
                      const SizedBox(height: 16),
                      Text('No notifications',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: notifState.notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifState.notifications[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () => ref
                            .read(notificationProvider.notifier)
                            .markAsRead(notif.id),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: notif.read
                                ? AppColors.darkSurface
                                : AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: notif.read
                                  ? AppColors.darkBorder
                                  : AppColors.primary.withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _typeColor(notif.type)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(_typeIcon(notif.type),
                                    color: _typeColor(notif.type), size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notif.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 4),
                                    Text(notif.body,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    const SizedBox(height: 6),
                                    Text(_timeAgo(notif.createdAt),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ],
                                ),
                              ),
                              if (!notif.read)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'shortlisted':
        return AppColors.shortlisted;
      case 'new_gig':
        return AppColors.info;
      case 'application_update':
        return AppColors.secondary;
      default:
        return AppColors.darkTextSecondary;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'shortlisted':
        return Icons.star_rounded;
      case 'new_gig':
        return Icons.work_rounded;
      case 'application_update':
        return Icons.assignment_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'just now';
  }
}
