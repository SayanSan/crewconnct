import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final String userType;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.userType,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length != 6) return;
    final success = await ref.read(authProvider.notifier).verifyOtp(_otp);
    if (success && mounted) {
      // Navigate to onboarding
      context.go(widget.userType == 'student'
          ? AppRoutes.studentOnboarding
          : AppRoutes.managerOnboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(height: 32),
                Text(
                  'Verify Your Phone',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkTextSecondary,
                        ),
                    children: [
                      const TextSpan(text: 'Enter the 6-digit code sent to '),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // OTP Input Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (i) {
                    return SizedBox(
                      width: 48,
                      height: 56,
                      child: TextFormField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: Theme.of(context).textTheme.headlineMedium,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && i < 5) {
                            _focusNodes[i + 1].requestFocus();
                          }
                          if (val.isEmpty && i > 0) {
                            _focusNodes[i - 1].requestFocus();
                          }
                          if (_otp.length == 6) _verify();
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                if (authState.error != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        authState.error!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      if (authState.verificationId == 'mock-verification-id')
                        Text(
                          'Use code 123456 for demo',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.darkTextTertiary,
                              ),
                        ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).sendOtp(widget.email);
                        },
                        child: const Text('Resend Code'),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(
                  label: 'Verify',
                  isLoading: authState.isLoading,
                  onPressed: _otp.length == 6 ? _verify : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
