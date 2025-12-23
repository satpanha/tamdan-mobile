import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/utils/constants.dart';
import 'package:tamdan/utils/validators.dart';

class AddAthleteScreen extends StatefulWidget {
  const AddAthleteScreen({super.key});

  @override
  State<AddAthleteScreen> createState() => _AddAthleteScreenState();
}

class _AddAthleteScreenState extends State<AddAthleteScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
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
    final dateErr = FormValidators.validateDateOfBirth(_dob);
    if (_formKey.currentState!.validate() && dateErr == null) {
      final athlete = Athlete(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name.trim(),
        dateOfBirth: _dob!,
        gender: _gender!,
        beltLevel: _beltLevel!,
        status: _status!,
      );
      Navigator.pop(context, athlete);
    } else if (dateErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(dateErr)),
      );
    }
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
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: FormValidators.validateName,
                  onChanged: (v) => _name = v,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _dob == null
                              ? 'Select date'
                              : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (v) => setState(() => _gender = v),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _beltLevel,
                  decoration: const InputDecoration(labelText: 'Belt Level'),
                  items: beltLevels
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (v) => setState(() => _beltLevel = v),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: statuses
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (v) => setState(() => _status = v),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save'),
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
