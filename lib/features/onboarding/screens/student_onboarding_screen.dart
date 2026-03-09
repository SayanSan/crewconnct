import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../core/router/app_router.dart';
import '../../../providers/auth_provider.dart';

class StudentOnboardingScreen extends ConsumerStatefulWidget {
  const StudentOnboardingScreen({super.key});

  @override
  ConsumerState<StudentOnboardingScreen> createState() =>
      _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState
    extends ConsumerState<StudentOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _universityController = TextEditingController();
  int _currentStep = 0;
  final List<String> _selectedSkills = [];

  final List<String> _availableSkills = [
    'Event Setup', 'Photography', 'Videography', 'Communication',
    'Sales', 'Leadership', 'Flutter', 'React', 'Node.js',
    'Photo Editing', 'Graphic Design', 'Social Media',
    'Bartending', 'Cooking', 'Hospitality', 'Security',
    'Music/DJ', 'MC/Host', 'Logistics', 'First Aid',
  ];

  void _next() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) return;
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _complete();
    }
  }

  void _complete() {
    final user = ref.read(authProvider).user;
    if (user != null) {
      ref.read(authProvider.notifier).completeOnboarding(
            user.copyWith(
              name: _nameController.text,
              bio: _bioController.text,
              university: _universityController.text,
              skills: _selectedSkills,
              onboardingComplete: true,
            ),
          );
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.surfaceGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                Row(
                  children: List.generate(3, (i) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i <= _currentStep
                              ? AppColors.primary
                              : AppColors.darkCard,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Text(
                  _stepTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _stepSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.darkTextSecondary,
                      ),
                ),
                const SizedBox(height: 32),
                Expanded(child: _buildStep()),
                CustomButton(
                  label: _currentStep == 2 ? 'Complete Setup' : 'Continue',
                  onPressed: _next,
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => _currentStep--),
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _stepTitle {
    switch (_currentStep) {
      case 0: return 'Tell Us About Yourself';
      case 1: return 'What Are Your Skills?';
      case 2: return 'Almost Done!';
      default: return '';
    }
  }

  String get _stepSubtitle {
    switch (_currentStep) {
      case 0: return 'Basic info to set up your profile';
      case 1: return 'Select skills that match your abilities';
      case 2: return 'Add a short bio to stand out';
      default: return '';
    }
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  prefixIcon: Icons.person_outlined,
                  validator: Validators.name,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _universityController,
                  label: 'University / Institution',
                  prefixIcon: Icons.school_outlined,
                ),
              ],
            ),
          ),
        );
      case 1:
        return SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableSkills.map((skill) {
              final selected = _selectedSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedSkills.add(skill);
                    } else {
                      _selectedSkills.remove(skill);
                    }
                  });
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.3),
                checkmarkColor: AppColors.primaryLight,
              );
            }).toList(),
          ),
        );
      case 2:
        return SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: _bioController,
                label: 'Short Bio',
                hint: 'Tell managers what makes you a great crew member...',
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              // Resume upload placeholder
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.darkBorder,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.upload_file_rounded,
                        size: 48, color: AppColors.darkTextTertiary),
                    const SizedBox(height: 12),
                    Text('Upload Resume (Optional)',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text('PDF, DOC up to 5MB',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
