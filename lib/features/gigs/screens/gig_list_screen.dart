import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/gig_provider.dart';

class GigListScreen extends ConsumerStatefulWidget {
  const GigListScreen({super.key});

  @override
  ConsumerState<GigListScreen> createState() => _GigListScreenState();
}

class _GigListScreenState extends ConsumerState<GigListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(gigProvider.notifier).loadGigs());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gigState = ref.watch(gigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Gigs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => ref.read(gigProvider.notifier).search(v),
              decoration: InputDecoration(
                hintText: 'Search gigs by title or location...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(gigProvider.notifier).search('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${gigState.filteredGigs.length} gigs found',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Gig List
          Expanded(
            child: gigState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : gigState.filteredGigs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 64, color: AppColors.darkTextTertiary),
                            const SizedBox(height: 16),
                            Text('No gigs found',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text('Try adjusting your search or filters',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: gigState.filteredGigs.length,
                        itemBuilder: (context, index) {
                          final gig = gigState.filteredGigs[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => context.push('/gigs/${gig.id}'),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.darkSurface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: AppColors.darkBorder, width: 0.5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            gradient: AppColors.primaryGradient,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(Icons.work_rounded,
                                              color: Colors.white, size: 22),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(gig.title,
                                                  style: Theme.of(context).textTheme.titleMedium),
                                              Text(gig.organizationName ?? '',
                                                  style: Theme.of(context).textTheme.bodySmall),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.success.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text('\$${gig.pay.toStringAsFixed(0)}',
                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.success)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(gig.description,
                                        maxLines: 2, overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        _InfoChip(icon: Icons.location_on_outlined, text: gig.location),
                                        const SizedBox(width: 12),
                                        _InfoChip(icon: Icons.calendar_today_outlined, text: DateFormat('MMM d').format(gig.date)),
                                        const SizedBox(width: 12),
                                        _InfoChip(icon: Icons.access_time_rounded, text: gig.duration),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: gig.requiredSkills
                                          .map((s) => Chip(
                                                label: Text(s),
                                                visualDensity: VisualDensity.compact,
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter by Skills', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Event Setup', 'Photography', 'Communication', 'Flutter', 'React', 'Leadership', 'Sales']
                    .map((skill) => FilterChip(
                          label: Text(skill),
                          selected: ref.read(gigProvider).filterSkills.contains(skill),
                          onSelected: (val) {
                            final current = List<String>.from(ref.read(gigProvider).filterSkills);
                            if (val) current.add(skill); else current.remove(skill);
                            ref.read(gigProvider.notifier).setFilterSkills(current);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ref.read(gigProvider.notifier).setFilterSkills([]);
                  Navigator.pop(context);
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.darkTextTertiary),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
