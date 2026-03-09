import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';

class ManagerOnboardingScreen extends ConsumerStatefulWidget {
  const ManagerOnboardingScreen({super.key});

  @override
  ConsumerState<ManagerOnboardingScreen> createState() =>
      _ManagerOnboardingScreenState();
}

class _ManagerOnboardingScreenState
    extends ConsumerState<ManagerOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _orgNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _orgDescController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _orgNameController.dispose();
    _designationController.dispose();
    _orgDescController.dispose();
    super.dispose();
  }

  void _complete() {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authProvider).user;
    if (user != null) {
      ref.read(authProvider.notifier).completeOnboarding(
            user.copyWith(
              name: _nameController.text,
              designation: _designationController.text,
              onboardingComplete: true,
            ),
          );
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator (single step)
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Set Up Your Organization',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us about you and your organization',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkTextSecondary,
                        ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Your Full Name',
                    prefixIcon: Icons.person_outlined,
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _designationController,
                    label: 'Designation',
                    hint: 'e.g. Event Director, Branch Manager',
                    prefixIcon: Icons.badge_outlined,
                    validator: (v) => Validators.required(v, 'Designation'),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _orgNameController,
                    label: 'Organization Name',
                    prefixIcon: Icons.business_outlined,
                    validator: (v) => Validators.required(v, 'Organization name'),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _orgDescController,
                    label: 'Organization Description (Optional)',
                    hint: 'What does your organization do?',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  // Logo upload placeholder
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.darkBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.darkCard,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add_photo_alternate_outlined,
                              color: AppColors.darkTextTertiary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Organization Logo',
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text('Optional • PNG, JPG up to 2MB',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    label: 'Complete Setup',
                    onPressed: _complete,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
