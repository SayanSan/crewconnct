import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../repositories/mock_repository.dart';

class ApplicantDetailScreen extends ConsumerWidget {
  final String studentId;

  const ApplicantDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use mock student for demo
    final student = MockRepository.mockStudent;

    return Scaffold(
      appBar: AppBar(title: const Text('Applicant Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + Name
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(student.name[0],
                  style: const TextStyle(
                      fontSize: 32,
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 16),
            Text(student.name,
                style: Theme.of(context).textTheme.headlineMedium),
            if (student.university != null)
              Text(student.university!,
                  style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),

            // Bio
            if (student.bio != null) ...[
              _Section(
                title: 'About',
                child: Text(student.bio!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(height: 1.5)),
              ),
              const SizedBox(height: 20),
            ],

            // Skills
            _Section(
              title: 'Skills',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (student.skills ?? [])
                    .map((s) => Chip(
                          label: Text(s),
                          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                          labelStyle:
                              const TextStyle(color: AppColors.primaryLight),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Contact
            _Section(
              title: 'Contact',
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(student.email),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (student.phone != null)
                    ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: Text(student.phone!),
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
