
import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/ui/widgets/action_botton.dart';
import 'package:tamdan/ui/widgets/add_profile_picture.dart';
import 'package:tamdan/ui/widgets/custom_date_picker.dart';
import 'package:tamdan/ui/widgets/custom_dropdown.dart';
import 'package:tamdan/ui/widgets/custom_text_field.dart';
import 'package:tamdan/utils/constants.dart';
import 'package:tamdan/utils/validators.dart';

class AddAthleteScreen extends StatefulWidget {
  const AddAthleteScreen({super.key});

  @override
  State<AddAthleteScreen> createState() => _AddAthleteScreenState();
}

class _AddAthleteScreenState extends State<AddAthleteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  DateTime? _dob;
  String? _gender;
  String? _beltLevel;
  String? _status;


  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _save() {
      final athlete = Athlete(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        dateOfBirth: _dob!,
        gender: _gender!,
        beltLevel: _beltLevel!,
        status: _status!,
      );
      Navigator.pop(context, athlete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Athlete')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AddProfilePicture( label: 'Add Profile Picture',),
                const SizedBox(height: 36),

                CustomTextField(
                  label: 'Name', 
                  hintText: 'Enter Name',
                  controller: _nameController,
                  validator: FormValidators.validateName,
                ),
                const SizedBox(height: 16),

                CustomDatePicker(
                  label: 'Date Of Birth', 
                  value: _dob, onTap: _selectDate, 
                
                ),
                const SizedBox(height: 16),

                CustomDropdown(
                  label: 'Gender', 
                  value: _gender, 
                  hintText: 'Select Gender',                       
                  items: genders, 
                  itemLabel: (g) => g,
                  validator: FormValidators.validateDropdown,
                  onChanged: (value) => setState(() => _gender =  value ),
                ),
                const SizedBox(height: 16),

                CustomDropdown(
                  label: 'Belt Level', 
                  value: _beltLevel, 
                  hintText: 'Select Belt Level',                  
                  items: beltLevels, 
                  itemLabel: (b) => b, 
                  validator: FormValidators.validateDropdown,
                  onChanged: (value) => setState(() => _beltLevel = value ),
                  ),
                const SizedBox(height: 16),

                CustomDropdown(
                  label: 'Status', 
                  value: _status,
                  hintText: 'Select Status',
                  items: statuses, 
                  itemLabel: (s) => s, 
                  validator: FormValidators.validateDropdown, 
                  onChanged: (value) => _status = value,
                  ),

                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
