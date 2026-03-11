import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String userType;

  const RegisterScreen({super.key, required this.userType});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    // Send OTP via Firebase
    await ref.read(authProvider.notifier).sendOtp(_phoneController.text);

    if (mounted) {
      // Navigate to OTP screen
      context.push(AppRoutes.otpVerification, extra: {
        'email': _phoneController.text, // Repurposing email param for phone display
        'userType': widget.userType,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isStudent = widget.userType == 'student';

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
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isStudent
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.secondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isStudent ? '🎓 Student' : '💼 Manager',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: isStudent
                                    ? AppColors.primaryLight
                                    : AppColors.secondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fill in your details to get started',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkTextSecondary,
                        ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'you@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: '+1 234 567 8900',
                    prefixIcon: Icons.phone_android_rounded,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'Phone number required' : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Min. 8 characters',
                    prefixIcon: Icons.lock_outlined,
                    obscureText: _obscurePassword,
                    validator: Validators.password,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    prefixIcon: Icons.lock_outlined,
                    obscureText: _obscureConfirm,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (authState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        authState.error!,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  CustomButton(
                    label: 'Continue',
                    isLoading: authState.isLoading,
                    onPressed: _register,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: const Text('Log In'),
                      ),
                    ],
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
