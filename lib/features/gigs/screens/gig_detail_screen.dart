import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/gig_provider.dart';
import '../../../providers/application_provider.dart';

class GigDetailScreen extends ConsumerWidget {
  final String gigId;

  const GigDetailScreen({super.key, required this.gigId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gigState = ref.watch(gigProvider);
    final gig = gigState.gigs.firstWhere(
      (g) => g.id == gigId,
      orElse: () => gigState.gigs.first,
    );
    final user = ref.watch(authProvider).user;
    final isStudent = user?.isStudent ?? true;
    final hasApplied = ref.watch(applicationProvider.notifier).hasApplied(gigId, user?.id ?? '');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Center(
                  child: Icon(Icons.work_rounded,
                      size: 64, color: Colors.white.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Pay
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(gig.title,
                            style: Theme.of(context).textTheme.headlineLarge),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('\$${gig.pay.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.success)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(gig.organizationName ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.darkTextSecondary)),
                  const SizedBox(height: 20),

                  // Info Row
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.darkBorder, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _DetailItem(icon: Icons.location_on_outlined, label: 'Location', value: gig.location),
                        _DetailItem(icon: Icons.calendar_today_outlined, label: 'Date', value: DateFormat('MMM d, yyyy').format(gig.date)),
                        _DetailItem(icon: Icons.access_time_rounded, label: 'Duration', value: gig.duration),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text('Description', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(gig.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6)),
                  const SizedBox(height: 24),

                  // Skills Required
                  Text('Skills Required', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: gig.requiredSkills
                        .map((s) => Chip(
                              label: Text(s),
                              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                              labelStyle: TextStyle(color: AppColors.primaryLight),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Applicant count
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.darkBorder, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.people_outline_rounded, color: AppColors.secondary),
                        const SizedBox(width: 12),
                        Text('${gig.applicantCount} people have applied',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  if (isStudent) ...[
                    if (hasApplied)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.success),
                            const SizedBox(width: 8),
                            Text('You\'ve Applied',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.success)),
                          ],
                        ),
                      )
                    else
                      CustomButton(
                        label: 'Quick Apply',
                        icon: Icons.send_rounded,
                        onPressed: () {
                          ref.read(applicationProvider.notifier).applyToGig(
                                gigId: gig.id,
                                gigTitle: gig.title,
                                studentId: user?.id ?? '',
                                studentName: user?.name ?? '',
                                managerId: gig.managerId,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Applied successfully! 🎉')),
                          );
                        },
                      ),
                  ] else ...[
                    CustomButton(
                      label: 'View Applicants',
                      icon: Icons.people_rounded,
                      onPressed: () => context.push('/gigs/${gig.id}/applicants'),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryLight),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
      ],
    );
  }
}
