import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/utils/constants.dart';
import 'package:tamdan/utils/validators.dart';

class EditAthleteScreen extends StatefulWidget {
  final Athlete athlete;
  const EditAthleteScreen({super.key, required this.athlete});

  @override
  State<EditAthleteScreen> createState() => _EditAthleteScreenState();
}

class _EditAthleteScreenState extends State<EditAthleteScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late DateTime _dob;
  late String _gender;
  late String _beltLevel;
  late String _status;

  @override
  void initState() {
    super.initState();
    _name = widget.athlete.name;
    _dob = widget.athlete.dateOfBirth;
    _gender = widget.athlete.gender;
    _beltLevel = widget.athlete.beltLevel;
    _status = widget.athlete.status;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final updated = Athlete(
        id: widget.athlete.id,
        name: _name.trim(),
        dateOfBirth: _dob,
        gender: _gender,
        beltLevel: _beltLevel,
        status: _status,
      );
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Athlete')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
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
                        Text('${_dob.day}/${_dob.month}/${_dob.year}'),
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
                  onChanged: (v) => setState(() => _gender = v ?? _gender),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _beltLevel,
                  decoration: const InputDecoration(labelText: 'Belt Level'),
                  items: beltLevels
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (v) => setState(() => _beltLevel = v ?? _beltLevel),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: statuses
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (v) => setState(() => _status = v ?? _status),
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
                      child: const Text('Save Changes'),
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
