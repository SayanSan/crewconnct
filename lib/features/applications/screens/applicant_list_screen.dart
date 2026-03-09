import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../providers/application_provider.dart';

class ApplicantListScreen extends ConsumerStatefulWidget {
  final String gigId;

  const ApplicantListScreen({super.key, required this.gigId});

  @override
  ConsumerState<ApplicantListScreen> createState() =>
      _ApplicantListScreenState();
}

class _ApplicantListScreenState extends ConsumerState<ApplicantListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(applicationProvider.notifier).loadApplications());
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(applicationProvider);
    final applicants =
        appState.applications.where((a) => a.gigId == widget.gigId).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Applicants')),
      body: applicants.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline_rounded,
                      size: 64, color: AppColors.darkTextTertiary),
                  const SizedBox(height: 16),
                  Text('No applicants yet',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final app = applicants[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: AppColors.darkBorder, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                              child: Text(
                                app.studentName[0].toUpperCase(),
                                style: const TextStyle(
                                    color: AppColors.primaryLight,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(app.studentName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Text(
                                    'Applied ${_timeAgo(app.appliedAt)}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _statusColor(app.status)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(app.status.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          color: _statusColor(app.status))),
                            ),
                          ],
                        ),
                        if (app.coverNote != null &&
                            app.coverNote!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(app.coverNote!,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => context
                                    .push('/applicants/${app.studentId}'),
                                icon: const Icon(Icons.person_outlined,
                                    size: 18),
                                label: const Text('View Profile'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (app.isApplied) ...[
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => ref
                                      .read(applicationProvider.notifier)
                                      .updateStatus(
                                          app.id, 'shortlisted'),
                                  icon: const Icon(Icons.star_rounded,
                                      size: 18),
                                  label: const Text('Shortlist'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.shortlisted,
                                  ),
                                ),
                              ),
                            ],
                            if (app.isShortlisted) ...[
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => ref
                                      .read(applicationProvider.notifier)
                                      .updateStatus(app.id, 'accepted'),
                                  icon: const Icon(Icons.check_rounded,
                                      size: 18),
                                  label: const Text('Accept'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accepted,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
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

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'just now';
  }
}
