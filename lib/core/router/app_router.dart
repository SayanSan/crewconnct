import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/user_type_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/onboarding/screens/student_onboarding_screen.dart';
import '../../features/onboarding/screens/manager_onboarding_screen.dart';
import '../../features/dashboard/screens/student_dashboard_screen.dart';
import '../../features/dashboard/screens/manager_dashboard_screen.dart';
import '../../features/gigs/screens/gig_list_screen.dart';
import '../../features/gigs/screens/gig_detail_screen.dart';
import '../../features/gigs/screens/create_gig_screen.dart';
import '../../features/gigs/screens/gig_preview_screen.dart';
import '../../features/gigs/screens/my_gigs_screen.dart';
import '../../features/applications/screens/my_applications_screen.dart';
import '../../features/applications/screens/applicant_list_screen.dart';
import '../../features/applications/screens/applicant_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/skills_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/help/screens/help_center_screen.dart';
import '../../features/help/screens/faq_screen.dart';
import '../../features/help/screens/support_chat_screen.dart';
import '../../features/dashboard/screens/main_shell_screen.dart';

// ── Route Names ──────────────────────────────────────────────────────────
class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const userType = '/user-type';
  static const register = '/register';
  static const otpVerification = '/otp-verification';
  static const login = '/login';
  static const studentOnboarding = '/onboarding/student';
  static const managerOnboarding = '/onboarding/manager';

  // Shell routes (with bottom nav)
  static const dashboard = '/dashboard';
  static const gigs = '/gigs';
  static const applications = '/applications';
  static const profile = '/profile';

  // Sub-routes
  static const gigDetail = '/gigs/:id';
  static const createGig = '/gigs/create';
  static const gigPreview = '/gigs/preview';
  static const myGigs = '/gigs/my-gigs';
  static const applicantList = '/gigs/:id/applicants';
  static const applicantDetail = '/applicants/:id';
  static const editProfile = '/profile/edit';
  static const skills = '/profile/skills';
  static const notifications = '/notifications';
  static const helpCenter = '/help';
  static const faq = '/help/faq';
  static const supportChat = '/help/chat';
}

// ── Navigation key ───────────────────────────────────────────────────────
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// ── Router Provider ──────────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isOnSplash = state.matchedLocation == AppRoutes.splash;
      final isOnAuth = [
        AppRoutes.welcome,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.userType,
        AppRoutes.otpVerification,
      ].contains(state.matchedLocation);
      final isOnOnboarding = state.matchedLocation.startsWith('/onboarding');

      // Still loading → stay on splash
      if (authState.isLoading && isOnSplash) return null;

      // Not authenticated → send to welcome (unless already on auth screens)
      if (!authState.isAuthenticated) {
        if (isOnAuth || isOnSplash || isOnOnboarding) return null;
        return AppRoutes.welcome;
      }

      // Authenticated but onboarding not complete
      if (authState.user != null && !authState.user!.onboardingComplete) {
        if (isOnOnboarding) return null;
        return authState.user!.isStudent
            ? AppRoutes.studentOnboarding
            : AppRoutes.managerOnboarding;
      }

      // Authenticated and onboarded → redirect away from auth screens
      if (isOnAuth || isOnSplash || isOnOnboarding) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      // ── Auth Routes ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.userType,
        builder: (context, state) => const UserTypeScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          final userType = state.extra as String? ?? 'student';
          return RegisterScreen(userType: userType);
        },
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final args = state.extra as Map<String, String>? ?? {};
          return OtpVerificationScreen(
            email: args['email'] ?? '',
            userType: args['userType'] ?? 'student',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Onboarding Routes ─────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.studentOnboarding,
        builder: (context, state) => const StudentOnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.managerOnboarding,
        builder: (context, state) => const ManagerOnboardingScreen(),
      ),

      // ── Main Shell (Bottom Navigation) ─────────────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) {
              final user = ref.read(authProvider).user;
              return NoTransitionPage(
                child: user?.isStudent == true
                    ? const StudentDashboardScreen()
                    : const ManagerDashboardScreen(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.gigs,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: GigListScreen()),
          ),
          GoRoute(
            path: AppRoutes.applications,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MyApplicationsScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      // ── Sub-routes (full-screen, outside shell) ────────────────────────
      GoRoute(
        path: '/gigs/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateGigScreen(),
      ),
      GoRoute(
        path: '/gigs/preview',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          // Expect a GigModel via extra
          return const GigPreviewScreen();
        },
      ),
      GoRoute(
        path: '/gigs/my-gigs',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MyGigsScreen(),
      ),
      GoRoute(
        path: '/gigs/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final gigId = state.pathParameters['id']!;
          return GigDetailScreen(gigId: gigId);
        },
      ),
      GoRoute(
        path: '/gigs/:id/applicants',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final gigId = state.pathParameters['id']!;
          return ApplicantListScreen(gigId: gigId);
        },
      ),
      GoRoute(
        path: '/applicants/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final studentId = state.pathParameters['id']!;
          return ApplicantDetailScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.skills,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SkillsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.helpCenter,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        path: AppRoutes.supportChat,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SupportChatScreen(),
      ),
    ],
  );
});
