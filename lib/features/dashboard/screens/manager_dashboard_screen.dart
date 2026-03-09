import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/gig_provider.dart';
import '../../../providers/notification_provider.dart';

class ManagerDashboardScreen extends ConsumerStatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  ConsumerState<ManagerDashboardScreen> createState() =>
      _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState
    extends ConsumerState<ManagerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(gigProvider.notifier).loadGigs();
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
    final notifState = ref.watch(notificationProvider);

    final myGigs = gigState.gigs
        .where((g) => g.managerId == user?.id)
        .toList();
    final publishedCount = myGigs.where((g) => g.isPublished).length;
    final totalApplicants = myGigs.fold<int>(0, (sum, g) => sum + g.applicantCount);

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
                            'Hello, ${user?.name?.split(' ').first ?? 'Manager'} 👋',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 4),
                          Text('Manage your crew and gigs',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
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
                              child: Text('${notifState.unreadCount}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Quick Actions ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Post a New Gig',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.white)),
                            const SizedBox(height: 4),
                            Text('Find talented crew members',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.8))),
                          ],
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: 'create_gig',
                        backgroundColor: Colors.white,
                        onPressed: () => context.push('/gigs/create'),
                        child: const Icon(Icons.add_rounded,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Stats ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _ManagerStatCard(
                      icon: Icons.work_rounded,
                      label: 'Active Gigs',
                      value: '$publishedCount',
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    _ManagerStatCard(
                      icon: Icons.people_rounded,
                      label: 'Total Applicants',
                      value: '$totalApplicants',
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 12),
                    _ManagerStatCard(
                      icon: Icons.drafts_rounded,
                      label: 'Drafts',
                      value: '${myGigs.where((g) => g.isDraft).length}',
                      color: AppColors.warning,
                    ),
                  ],
                ),
              ),
            ),

            // ── Recent Gigs ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Your Gigs',
                        style: Theme.of(context).textTheme.titleLarge),
                    TextButton(
                      onPressed: () => context.push('/gigs/my-gigs'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final gig = myGigs[index];
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
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(gig.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: gig.isPublished
                                              ? AppColors.success
                                                  .withValues(alpha: 0.2)
                                              : AppColors.warning
                                                  .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          gig.status.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: gig.isPublished
                                                    ? AppColors.success
                                                    : AppColors.warning,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(Icons.people_outlined,
                                          size: 16,
                                          color: AppColors.darkTextTertiary),
                                      const SizedBox(width: 4),
                                      Text('${gig.applicantCount} applicants',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
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
                childCount: myGigs.length.clamp(0, 5),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _ManagerStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ManagerStatCard({
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
            Text(value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 2),
            Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color.withValues(alpha: 0.8),
                    ),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
