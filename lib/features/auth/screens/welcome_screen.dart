import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/router/app_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Hero illustration area
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Welcome to\nCrewConnct',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        height: 1.2,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Connect with event managers, find exciting gigs,\nand build your experience portfolio.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.darkTextSecondary,
                        height: 1.5,
                      ),
                ),
                const Spacer(flex: 3),
                // CTA Buttons
                CustomButton(
                  label: 'Get Started',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.push(AppRoutes.userType),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'I Already Have an Account',
                  isOutlined: true,
                  onPressed: () => context.push(AppRoutes.login),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
