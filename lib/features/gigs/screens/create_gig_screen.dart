import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../models/gig_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/gig_provider.dart';

class CreateGigScreen extends ConsumerStatefulWidget {
  const CreateGigScreen({super.key});

  @override
  ConsumerState<CreateGigScreen> createState() => _CreateGigScreenState();
}

class _CreateGigScreenState extends ConsumerState<CreateGigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController();
  final _payController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  final List<String> _selectedSkills = [];

  final List<String> _skills = [
    'Event Setup', 'Photography', 'Videography', 'Communication',
    'Sales', 'Leadership', 'Flutter', 'React', 'Node.js',
    'Photo Editing', 'Graphic Design', 'Bartending', 'Hospitality',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _payController.dispose();
    super.dispose();
  }

  void _preview() {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authProvider).user;
    final gig = GigModel(
      id: const Uuid().v4(),
      title: _titleController.text,
      description: _descController.text,
      location: _locationController.text,
      date: _selectedDate,
      duration: _durationController.text,
      pay: double.tryParse(_payController.text) ?? 0,
      requiredSkills: _selectedSkills,
      managerId: user?.id ?? '',
      organizationName: user?.organizationName ?? 'My Organization',
      status: 'draft',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    context.push('/gigs/preview', extra: gig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Gig')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Gig Title',
                hint: 'e.g. Tech Conference Setup Crew',
                validator: (v) => Validators.required(v, 'Title'),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _descController,
                label: 'Description',
                hint: 'Describe the gig, tasks, and expectations...',
                maxLines: 5,
                validator: (v) => Validators.required(v, 'Description'),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _locationController,
                label: 'Location',
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => Validators.required(v, 'Location'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _durationController,
                      label: 'Duration',
                      hint: 'e.g. 8 hours',
                      validator: (v) => Validators.required(v, 'Duration'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _payController,
                      label: 'Pay (\$)',
                      keyboardType: TextInputType.number,
                      validator: (v) => Validators.required(v, 'Pay'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Date picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_rounded),
                title: const Text('Event Date'),
                subtitle: Text(
                  DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 20),
              Text('Required Skills',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skills.map((skill) {
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
              const SizedBox(height: 48),
              CustomButton(
                label: 'Preview Gig',
                icon: Icons.visibility_outlined,
                onPressed: _preview,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
