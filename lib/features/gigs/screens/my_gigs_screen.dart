import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/gig_provider.dart';

class MyGigsScreen extends ConsumerWidget {
  const MyGigsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final gigState = ref.watch(gigProvider);
    final myGigs = gigState.gigs.where((g) => g.managerId == user?.id).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Gigs')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/gigs/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Gig'),
        backgroundColor: AppColors.primary,
      ),
      body: myGigs.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.work_off_rounded, size: 64, color: AppColors.darkTextTertiary),
                  const SizedBox(height: 16),
                  Text('No gigs yet', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Create your first gig to start finding crew', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: myGigs.length,
              itemBuilder: (context, index) {
                final gig = myGigs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: AppColors.darkBorder, width: 0.5),
                    ),
                    tileColor: AppColors.darkSurface,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.work_rounded, color: Colors.white, size: 22),
                    ),
                    title: Text(gig.title),
                    subtitle: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: gig.isPublished
                                ? AppColors.success.withValues(alpha: 0.2)
                                : AppColors.warning.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(gig.status.toUpperCase(),
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: gig.isPublished ? AppColors.success : AppColors.warning,
                                  )),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('${gig.applicantCount} applicants'),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/gigs/${gig.id}'),
                  ),
                );
              },
            ),
    );
  }
}
