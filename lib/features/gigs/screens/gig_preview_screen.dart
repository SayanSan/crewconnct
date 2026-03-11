import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../models/gig_model.dart';
import '../../../providers/gig_provider.dart';

class GigPreviewScreen extends ConsumerWidget {
  final GigModel gig;

  const GigPreviewScreen({super.key, required this.gig});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Gig'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.darkBorder, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gig.title,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  _buildIconText(
                      context, Icons.location_on_outlined, gig.location),
                  const SizedBox(height: 8),
                  _buildIconText(context, Icons.calendar_today_outlined,
                      DateFormat('EEE, MMM d, yyyy').format(gig.date)),
                  const SizedBox(height: 8),
                  _buildIconText(context, Icons.access_time_outlined,
                      'Duration: ${gig.duration}'),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.darkBorder),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Est. Pay',
                              style: Theme.of(context).textTheme.bodySmall),
                          Text('\$${gig.pay.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      color: AppColors.primaryLight,
                                      fontWeight: FontWeight.w700)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.3)),
                        ),
                        child: Text('DRAFT',
                            style: TextStyle(
                                color: AppColors.warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Description
            Text('Description', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(gig.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.6, color: AppColors.darkTextSecondary)),

            const SizedBox(height: 32),

            // Skills
            Text('Required Skills',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: gig.requiredSkills.map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Text(skill,
                      style: const TextStyle(
                          color: AppColors.primaryLight, fontSize: 13)),
                );
              }).toList(),
            ),

            const SizedBox(height: 48),

            // Actions
            CustomButton(
              label: 'Publish Gig',
              onPressed: () async {
                final success = await ref
                    .read(gigProvider.notifier)
                    .createGig(gig.copyWith(status: 'published'));
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Gig published successfully! 🚀')),
                  );
                  context.go('/dashboard');
                }
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Keep as Draft',
              isSecondary: true,
              onPressed: () async {
                final success =
                    await ref.read(gigProvider.notifier).createGig(gig);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gig saved to drafts! 💾')),
                  );
                  context.go('/dashboard');
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.darkTextTertiary),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
