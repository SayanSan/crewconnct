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
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.darkBorder, width: 0.5),
              ),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(faq['question']!,
                    style: Theme.of(context).textTheme.titleMedium),
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(faq['answer']!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(height: 1.5)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
