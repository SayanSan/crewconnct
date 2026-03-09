import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/gig_provider.dart';
import '../../../providers/application_provider.dart';
import '../../../providers/notification_provider.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends ConsumerState<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(gigProvider.notifier).loadGigs();
      ref.read(applicationProvider.notifier).loadApplications();
      final userId = ref.read(authProvider).user?.id;
      if (userId != null) {
        ref.read(notificationProvider.notifier).loadNotifications(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final gigState = ref.watch(gigProvider);
    final appState = ref.watch(applicationProvider);
    final notifState = ref.watch(notificationProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hey, ${user?.name?.split(' ').first ?? 'there'} 👋',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Find your next gig today',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    // Notification bell
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () => context.push(AppRoutes.notifications),
                          icon: const Icon(Icons.notifications_outlined, size: 28),
                        ),
                        if (notifState.unreadCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${notifState.unreadCount}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Stats Cards ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    _StatCard(
                      icon: Icons.assignment_turned_in_rounded,
                      label: 'Applied',
                      value: '${appState.applications.length}',
                      color: AppColors.applied,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      icon: Icons.star_rounded,
                      label: 'Shortlisted',
                      value: '${appState.applications.where((a) => a.isShortlisted).length}',
                      color: AppColors.shortlisted,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      icon: Icons.check_circle_rounded,
                      label: 'Accepted',
                      value: '${appState.applications.where((a) => a.isAccepted).length}',
                      color: AppColors.accepted,
                    ),
                  ],
                ),
              ),
            ),

            // ── Section: Recommended Gigs ────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recommended Gigs',
                        style: Theme.of(context).textTheme.titleLarge),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.gigs),
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
            ),

            // ── Gig List ─────────────────────────────────────────────
            if (gigState.isLoading)
              const SliverToBoxAdapter(
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                )),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final gig = gigState.filteredGigs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: GestureDetector(
                        onTap: () => context.push('/gigs/${gig.id}'),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.darkBorder, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.work_rounded,
                                        color: Colors.white, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(gig.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                        Text(
                                            gig.organizationName ?? 'Unknown',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.success.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '\$${gig.pay.toStringAsFixed(0)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: AppColors.success),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 16,
                                      color: AppColors.darkTextTertiary),
                                  const SizedBox(width: 4),
                                  Text(gig.location,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  const SizedBox(width: 16),
                                  Icon(Icons.calendar_today_outlined,
                                      size: 16,
                                      color: AppColors.darkTextTertiary),
                                  const SizedBox(width: 4),
                                  Text(
                                      DateFormat('MMM d').format(gig.date),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  const SizedBox(width: 16),
                                  Icon(Icons.access_time_rounded,
                                      size: 16,
                                      color: AppColors.darkTextTertiary),
                                  const SizedBox(width: 4),
                                  Text(gig.duration,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: gig.requiredSkills
                                    .map((s) => Chip(
                                          label: Text(s),
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: gigState.filteredGigs.length.clamp(0, 5),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color.withValues(alpha: 0.8),
                    )),
          ],
        ),
      ),
    );
  }
}
