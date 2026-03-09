import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../providers/auth_provider.dart';

class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key});

  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends ConsumerState<SkillsScreen> {
  late List<String> _selectedSkills;

  final List<String> _allSkills = [
    'Event Setup', 'Photography', 'Videography', 'Communication',
    'Sales', 'Leadership', 'Flutter', 'React', 'Node.js',
    'Photo Editing', 'Graphic Design', 'Social Media',
    'Bartending', 'Cooking', 'Hospitality', 'Security',
    'Music/DJ', 'MC/Host', 'Logistics', 'First Aid',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSkills =
        List.from(ref.read(authProvider).user?.skills ?? []);
  }

  void _save() {
    final user = ref.read(authProvider).user;
    if (user != null) {
      ref
          .read(authProvider.notifier)
          .updateUser(user.copyWith(skills: _selectedSkills));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Skills updated! ✅')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Skills')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select your skills',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('These help us match you with relevant gigs',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allSkills.map((skill) {
                    final selected = _selectedSkills.contains(skill);
                    return FilterChip(
                      label: Text(skill),
                      selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) _selectedSkills.add(skill);
                          else _selectedSkills.remove(skill);
                        });
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.3),
                      checkmarkColor: AppColors.primaryLight,
                    );
                  }).toList(),
                ),
              ),
            ),
            CustomButton(label: 'Save Skills', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
