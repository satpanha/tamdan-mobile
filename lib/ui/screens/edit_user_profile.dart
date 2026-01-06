import 'package:flutter/material.dart';
import 'package:tamdan/models/user.dart';
import 'package:tamdan/ui/widgets/add_profile_picture.dart';
import 'package:tamdan/ui/widgets/custom_text_field.dart';
import 'package:tamdan/ui/widgets/custom_date_picker.dart';
import 'package:tamdan/ui/widgets/custom_dropdown.dart';
import 'package:tamdan/ui/widgets/action_botton.dart';
import 'package:tamdan/utils/validators.dart';

class EditUserProfileScreen extends StatefulWidget {
  final User user;
  const EditUserProfileScreen({super.key, required this.user});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _experienceController;
  late TextEditingController _focusOnController;
  DateTime? _dob;
  String? _gender;
  String? _role;
  bool _submitted = false;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> roles = ['Coach', 'Athlete', 'Admin', 'Manager', 'Staff'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _experienceController = TextEditingController(text: widget.user.experience);
    _focusOnController = TextEditingController(text: widget.user.focusOn);
    _dob = widget.user.dateOfBirth;
    _gender = widget.user.gender;
    _role = widget.user.role;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    _focusOnController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _save() {
    setState(() => _submitted = true);
    final dobError = FormValidators.validateDateOfBirth(_dob);
    if (_formKey.currentState!.validate() && dobError == null) {
      final updatedUser = User(
        name: _nameController.text.trim(),
        role: _role ?? '',
        dateOfBirth: _dob!,
        gender: _gender ?? '',
        experience: _experienceController.text.trim(),
        focusOn: _focusOnController.text.trim(),
      );
      Navigator.pop(context, updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                
                AddProfilePicture(label: 'Edit Profile Picture'),
                const SizedBox(height: 24),

                CustomTextField(
                  label: 'Full Name',
                  hintText: 'Enter your name',
                  controller: _nameController,
                  validator: FormValidators.validateName,
                ),
                const SizedBox(height: 16),

                CustomDatePicker(
                  label: 'Date Of Birth',
                  value: _dob,
                  onTap: _selectDate,
                  errorText: _submitted ? FormValidators.validateDateOfBirth(_dob) : null,
                ),
                const SizedBox(height: 16),

                CustomDropdown<String>(
                  label: 'Gender',
                  hintText: 'Select Gender',
                  value: _gender,
                  items: genders,
                  itemLabel: (g) => g,
                  validator: FormValidators.validateDropdown,
                  onChanged: (v) => setState(() => _gender = v),
                ),
                const SizedBox(height: 16),

                CustomDropdown<String>(
                  label: 'Role',
                  hintText: 'Select Role',
                  value: _role,
                  items: roles,
                  itemLabel: (r) => r,
                  validator: FormValidators.validateDropdown,
                  onChanged: (v) => setState(() => _role = v),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Experience',
                  hintText: 'e.g. 3 Years',
                  controller: _experienceController,
                  validator: FormValidators.validateAdmin,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Focus on',
                  hintText: 'e.g. Strength',
                  controller: _focusOnController,
                  validator: FormValidators.validateAdmin,
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    ActionButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icons.close,
                      label: 'Cancel',
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                    ),
                    const SizedBox(width: 16),
                    ActionButton(
                      onPressed: _save,
                      icon: Icons.save,
                      label: 'Save',
                      backgroundColor: const Color(0xFF0D47A1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}