import 'package:flutter/material.dart';
import 'package:tamdan/routes/app_routes.dart';
import 'package:tamdan/ui/widgets/base_screen.dart';
import 'package:tamdan/ui/widgets/athlete_card.dart';
import 'package:tamdan/ui/widgets/personal_info_card.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/ui/widgets/primary_button.dart';

enum SessionType { technical, strength, physical }

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  SessionType? _selectedType;
  DateTime _selectedDateTime = DateTime.now();
  final Set<String> _selectedAthleteIds = {};

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedDateTime));
    if (time == null) return;
    setState(() {
      _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _start() {
    if (_selectedType == null || _selectedAthleteIds.isEmpty) return;

    final args = {
      'athleteIds': _selectedAthleteIds.toList(),
      'dateTime': _selectedDateTime,
    };

    switch (_selectedType!) {
      case SessionType.technical:
        Navigator.of(context).pushNamed(AppRoutes.technicalSession, arguments: args);
        break;
      case SessionType.strength:
        Navigator.of(context).pushNamed(AppRoutes.strengthSession, arguments: args);
        break;
      case SessionType.physical:
        Navigator.of(context).pushNamed(AppRoutes.physicalConditioning, arguments: args);
        break;
    }
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.toLocal();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Tracking',
      bottom: PrimaryButton(
        label: 'Start',
        enabled: _selectedAthleteIds.isNotEmpty && _selectedType != null,
        onPressed: _start,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Start new training session', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),

          // Summary card (follows Athlete detail style)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PersonalInfoCard(
              infoPairs: {
                'Session type': _selectedType != null ? _selectedType.toString().split('.').last : 'Not selected',
                'Date/Time': _formatDateTime(_selectedDateTime),
                'Athletes': '${_selectedAthleteIds.length} selected',
              },
            ),
          ),

          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Select session type', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<SessionType>(
              key: const Key('sessionDropdown'),
              isExpanded: true,
              hint: const Text('Select session type'),
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: SessionType.technical, child: Text('Technical')),
                DropdownMenuItem(value: SessionType.strength, child: Text('Strength')),
                DropdownMenuItem(value: SessionType.physical, child: Text('Physical')),
              ],
              onChanged: (v) => setState(() => _selectedType = v),
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date/Time', style: Theme.of(context).textTheme.titleSmall),
                TextButton.icon(
                  onPressed: _pickDateTime,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_formatDateTime(_selectedDateTime)),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Select Athletes', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          ...mockAthletes.map((athlete) {
            final selected = _selectedAthleteIds.contains(athlete.id);
            return GestureDetector(
              onTap: () => setState(() => selected ? _selectedAthleteIds.remove(athlete.id) : _selectedAthleteIds.add(athlete.id)),
              child: AthleteCard(
                athlete: athlete,
                onTap: () => setState(() => selected ? _selectedAthleteIds.remove(athlete.id) : _selectedAthleteIds.add(athlete.id)),
                selected: selected,
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

