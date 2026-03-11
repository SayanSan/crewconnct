import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../repositories/mock_repository.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = MockRepository.mockFaqs;

    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.darkBorder, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  collapsedIconColor: AppColors.darkTextTertiary,
                  iconColor: AppColors.primaryLight,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(
                    faq['question']!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Text(
                        faq['answer']!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.darkTextSecondary,
                              height: 1.6,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
