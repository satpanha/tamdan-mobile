import 'package:flutter/material.dart';
import 'package:tamdan/routes/app_routes.dart';
import 'package:tamdan/ui/widgets/base_screen.dart';
import 'package:tamdan/ui/widgets/athlete_card.dart';
import 'package:tamdan/ui/widgets/custom_date_picker.dart';
import 'package:tamdan/ui/widgets/custom_dropdown.dart';
import 'package:tamdan/ui/widgets/personal_info_card.dart';
import 'package:tamdan/data/athlete_repository.dart';
import 'package:tamdan/ui/widgets/ptofile_header.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/ui/widgets/primary_button.dart';
import 'package:tamdan/models/athlete.dart';

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

  List<Athlete> _athletes = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadAthletes();
  }

  Future<void> _loadAthletes() async {
    try {
      final list = await AthleteRepository.instance.getAll();
      if (list.isNotEmpty) {
        _athletes = list;
      } else {
        _athletes = mockAthletes;
      }
    } catch (e) {
      _athletes = mockAthletes;
    }
    _loaded = true;
    if (mounted) setState(() {});
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (!mounted) return;
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (!mounted) return;
    if (time == null) return;
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
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
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.technicalSession, arguments: args);
        break;
      case SessionType.strength:
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.strengthSession, arguments: args);
        break;
      case SessionType.physical:
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.physicalConditioning, arguments: args);
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
          Center(
            child: ProfileHeader(
              name: 'Start Session',
              role: _selectedType != null
                  ? _selectedType.toString().split('.').last
                  : 'Pick a type',
            ),
          ),
          if (_selectedAthleteIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Align(
                alignment: Alignment.center,
                child: Chip(
                  label: Text(
                    '${_selectedAthleteIds.length} selected',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                    ),
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).dividerColor.withAlpha((0.06 * 255).round()),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PersonalInfoCard(
            infoPairs: {
              'Session type': _selectedType != null
                  ? _selectedType.toString().split('.').last
                  : 'Not selected',
              'Date/Time': _formatDateTime(_selectedDateTime),
              'Athletes': '${_selectedAthleteIds.length} selected',
            },
          )
        ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomDropdown<SessionType>(
              label: 'Session Type',
              hintText: 'Select session type',
              value: _selectedType,
              items: SessionType.values,
              itemLabel: (type) {
                switch (type) {
                  case SessionType.technical: return 'Technical';
                  case SessionType.strength: return 'Strength';
                  case SessionType.physical: return 'Physical';
                }
              },
              validator: (v) => v == null ? 'Please select a session type' : null,
              onChanged: (v) => setState(() => _selectedType = v),
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomDatePicker(
              label: 'Date/Time',
              value: _selectedDateTime,
              onTap: _pickDateTime,
            ),
          ),
          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select Athletes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          if (!_loaded)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          else
            ..._athletes.map((athlete) {
              final selected = _selectedAthleteIds.contains(athlete.id);
              return GestureDetector(
                onTap: () => setState(
                  () => selected
                      ? _selectedAthleteIds.remove(athlete.id)
                      : _selectedAthleteIds.add(athlete.id),
                ),
                child: AthleteCard(
                  athlete: athlete,
                  onTap: () => setState(
                    () => selected
                        ? _selectedAthleteIds.remove(athlete.id)
                        : _selectedAthleteIds.add(athlete.id),
                  ),
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
