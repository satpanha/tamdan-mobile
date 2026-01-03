import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/utils/constants.dart';
import 'package:tamdan/utils/validators.dart';
import 'package:tamdan/data/dao/athlete_dao.dart';

class AddAthleteScreen extends StatefulWidget {
  final dynamic dao;
  const AddAthleteScreen({super.key, this.dao});

  @override
  State<AddAthleteScreen> createState() => _AddAthleteScreenState();
}

class _AddAthleteScreenState extends State<AddAthleteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final dynamic _dao;

  String _fullName = '';
  DateTime? _dateOfBirth;
  String? _gender;
  String? _beltLevel;
  String? _status;

  @override
  void initState() {
    super.initState();
    _dao = (widget.dao as dynamic?) ?? AthleteDao();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _save() async {
    final dateErr = FormValidators.validateDateOfBirth(_dateOfBirth);
    if (_formKey.currentState!.validate() && dateErr == null) {
      final athlete = Athlete(
        fullName: _fullName.trim(),
        skillRank: '',
        dateOfBirth: _dateOfBirth!,
        gender: _gender ?? '',
        beltLevel: _beltLevel ?? '',
        status: _status ?? '',
      );
      // Do not perform DB insert here. Parent is responsible for persistence.
      Navigator.pop(context, athlete);
    } else if (dateErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dateErr)));
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
                TextFormField(decoration: const InputDecoration(labelText: 'Name'), validator: FormValidators.validateName, onChanged: (v) => _fullName = v),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Date of Birth', border: OutlineInputBorder()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(_dateOfBirth == null ? 'Select date' : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'), const Icon(Icons.calendar_today)],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(initialValue: _gender, decoration: const InputDecoration(labelText: 'Gender'), items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(), validator: FormValidators.validateDropdown, onChanged: (v) => setState(() => _gender = v)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(initialValue: _beltLevel, decoration: const InputDecoration(labelText: 'Belt Level'), items: beltLevels.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(), validator: FormValidators.validateDropdown, onChanged: (v) => setState(() => _beltLevel = v)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(initialValue: _status, decoration: const InputDecoration(labelText: 'Status'), items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), validator: FormValidators.validateDropdown, onChanged: (v) => setState(() => _status = v)),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), ElevatedButton(onPressed: _save, child: const Text('Save'))]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}