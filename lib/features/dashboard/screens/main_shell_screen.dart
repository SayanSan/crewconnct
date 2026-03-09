import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _currentIndex = 0;

  final _studentTabs = [
    AppRoutes.dashboard,
    AppRoutes.gigs,
    AppRoutes.applications,
    AppRoutes.profile,
  ];

  final _managerTabs = [
    AppRoutes.dashboard,
    AppRoutes.gigs,
    AppRoutes.applications,
    AppRoutes.profile,
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isStudent = user?.isStudent ?? true;
    final tabs = isStudent ? _studentTabs : _managerTabs;
    final unreadCount = ref.watch(notificationProvider).unreadCount;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.darkBorder, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
            context.go(tabs[index]);
          },
          backgroundColor: AppColors.darkSurface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.2),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.work_outline_rounded),
              selectedIcon: Icon(Icons.work_rounded),
              label: 'Gigs',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: false,
                child: Icon(isStudent
                    ? Icons.assignment_outlined
                    : Icons.people_outline_rounded),
              ),
              selectedIcon: Icon(isStudent
                  ? Icons.assignment_rounded
                  : Icons.people_rounded),
              label: isStudent ? 'Applications' : 'Applicants',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
