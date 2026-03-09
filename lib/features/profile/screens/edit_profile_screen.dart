import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.phone);
    _bioController = TextEditingController(text: user?.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authProvider).user;
    if (user != null) {
      ref.read(authProvider.notifier).updateUser(user.copyWith(
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            bio: _bioController.text,
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated! ✅')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                controller: _emailController,
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                validator: Validators.email,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _phoneController,
                label: 'Phone',
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _bioController,
                label: 'Bio',
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              CustomButton(label: 'Save Changes', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
