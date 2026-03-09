import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + Info
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                (user?.name ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                    fontSize: 32,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? 'User',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: (user?.isStudent ?? true)
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user?.isStudent == true ? '🎓 Student' : '💼 Manager',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: user?.isStudent == true
                          ? AppColors.primaryLight
                          : AppColors.secondary,
                    ),
              ),
            ),
            if (user?.university != null) ...[
              const SizedBox(height: 8),
              Text(user!.university!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 32),

            // Menu items
            _ProfileMenuItem(
              icon: Icons.edit_outlined,
              label: 'Edit Profile',
              onTap: () => context.push(AppRoutes.editProfile),
            ),
            if (user?.isStudent == true)
              _ProfileMenuItem(
                icon: Icons.psychology_outlined,
                label: 'Manage Skills',
                onTap: () => context.push(AppRoutes.skills),
              ),
            _ProfileMenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              onTap: () => context.push(AppRoutes.notifications),
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline_rounded,
              label: 'Help Center',
              onTap: () => context.push(AppRoutes.helpCenter),
            ),
            _ProfileMenuItem(
              icon: Icons.info_outline_rounded,
              label: 'FAQ',
              onTap: () => context.push(AppRoutes.faq),
            ),
            _ProfileMenuItem(
              icon: Icons.chat_outlined,
              label: 'Support Chat',
              onTap: () => context.push(AppRoutes.supportChat),
            ),
            const SizedBox(height: 16),
            _ProfileMenuItem(
              icon: Icons.logout_rounded,
              label: 'Log Out',
              isDestructive: true,
              onTap: () {
                ref.read(authProvider.notifier).logout();
                context.go(AppRoutes.welcome);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon,
            color: isDestructive ? AppColors.error : null),
        title: Text(label,
            style: isDestructive
                ? TextStyle(color: AppColors.error)
                : null),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.darkTextTertiary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.darkBorder, width: 0.5),
        ),
        tileColor: AppColors.darkSurface,
        onTap: onTap,
      ),
    );
  }
}
