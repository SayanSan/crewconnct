import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How can we help?',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text('Find answers and get support',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            _HelpCard(
              icon: Icons.quiz_outlined,
              title: 'Frequently Asked Questions',
              subtitle: 'Quick answers to common questions',
              onTap: () => context.push(AppRoutes.faq),
            ),
            const SizedBox(height: 12),
            _HelpCard(
              icon: Icons.chat_outlined,
              title: 'Chat with Support',
              subtitle: 'Talk to our team directly',
              onTap: () => context.push(AppRoutes.supportChat),
            ),
            const SizedBox(height: 12),
            _HelpCard(
              icon: Icons.email_outlined,
              title: 'Email Us',
              subtitle: 'support@crewconnct.com',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.darkBorder, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryLight),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.darkTextTertiary),
          ],
        ),
      ),
    );
  }
}
