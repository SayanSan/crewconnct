import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/application_provider.dart';

class MyApplicationsScreen extends ConsumerStatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  ConsumerState<MyApplicationsScreen> createState() =>
      _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends ConsumerState<MyApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(applicationProvider.notifier).loadApplications());
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(applicationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: appState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : appState.applications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.assignment_outlined,
                          size: 64, color: AppColors.darkTextTertiary),
                      const SizedBox(height: 16),
                      Text('No applications yet',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Apply to gigs to see them here',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: appState.applications.length,
                  itemBuilder: (context, index) {
                    final app = appState.applications[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => context.push('/gigs/${app.gigId}'),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.darkBorder, width: 0.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _statusColor(app.status)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(_statusIcon(app.status),
                                    color: _statusColor(app.status), size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(app.gigTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _statusColor(app.status)
                                            .withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        app.status.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                color: _statusColor(app.status)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: AppColors.darkTextTertiary),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'applied':
        return AppColors.applied;
      case 'shortlisted':
        return AppColors.shortlisted;
      case 'accepted':
        return AppColors.accepted;
      case 'rejected':
        return AppColors.rejected;
      default:
        return AppColors.darkTextSecondary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'applied':
        return Icons.send_rounded;
      case 'shortlisted':
        return Icons.star_rounded;
      case 'accepted':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline;
    }
  }
}
