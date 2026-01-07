library;
import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/models/physical_conditioning_sessions.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/ui/widgets/base_screen.dart';
import 'package:tamdan/ui/widgets/athlete_header.dart';
import 'package:tamdan/ui/widgets/metric_section.dart';
import 'package:tamdan/ui/widgets/metric_row.dart';
import 'package:tamdan/ui/widgets/coach_notes_field.dart';
import 'package:tamdan/ui/widgets/primary_button.dart';
import 'package:tamdan/routes/app_routes.dart';
import 'package:tamdan/data/session_repository.dart';

class PhysicalConditioningSessionScreen extends StatefulWidget {
  const PhysicalConditioningSessionScreen({super.key});

  @override
  State<PhysicalConditioningSessionScreen> createState() => _PhysicalConditioningSessionScreenState();
}

class _PhysicalConditioningSessionScreenState extends State<PhysicalConditioningSessionScreen> {
  late List<Athlete> _athletes;
  int _currentIndex = 0;

  final Map<String, int> _stamina = {};
  final Map<String, int> _flexibility = {};
  final Map<String, int> _reaction = {};
  final Map<String, TextEditingController> _notes = {};

  late PageController _pageController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final ids = args != null ? List<String>.from(args['athleteIds'] ?? []) : [];
    _athletes = ids.isNotEmpty
        ? ids.map((id) => mockAthletes.firstWhere((a) => a.id == id, orElse: () => mockAthletes.first)).toList()
        : [mockAthletes.first];

    _pageController = PageController(initialPage: 0);
    for (final a in _athletes) {
      _stamina.putIfAbsent(a.id, () => 0);
      _flexibility.putIfAbsent(a.id, () => 0);
      _reaction.putIfAbsent(a.id, () => 0);
      _notes.putIfAbsent(a.id, () => TextEditingController());
    }
  }

  Future<void> _save() async {
    final athlete = _athletes[_currentIndex];
    final session = PhysicalConditioningSessions(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      trainingSessionId: '',
      stamina: _stamina[athlete.id] ?? 0,
      flexibility: _flexibility[athlete.id] ?? 0,
      reactionSpeed: _reaction[athlete.id] ?? 0,
      coachNotes: _notes[athlete.id]?.text.isEmpty ?? true ? null : _notes[athlete.id]?.text,
    );

    final record = SessionRecord(
      id: session.id,
      trainingSessionId: session.trainingSessionId,
      athleteId: athlete.id,
      sessionType: 'physical',
      payload: {
        'stamina': session.stamina,
        'flexibility': session.flexibility,
        'reactionSpeed': session.reactionSpeed,
        'coachNotes': session.coachNotes,
      },
      dateTime: DateTime.now(),
    );

    await SessionRepository.instance.save(record);

    if (!mounted) return;
    debugPrint('Saved physical conditioning session: ${session.id} for ${athlete.name}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Physical conditioning saved'),
      action: SnackBarAction(label: 'Back to tracking', onPressed: () => Navigator.of(context).pushNamed(AppRoutes.tracking)),
    ));

    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRoutes.trainingResults, arguments: {'athleteId': athlete.id});
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Physical Conditioning',
      bottom: PrimaryButton(label: 'Save session', onPressed: _save),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _athletes.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                final athlete = _athletes[index];
                return AthleteHeader(
                  athlete: athlete,
                  subtitle: 'Athlete ${index + 1} of ${_athletes.length}',
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          MetricSection(
            title: 'Core performance',
            children: [
              MetricRow(label: 'Stamina', value: _stamina[_athletes[_currentIndex].id] ?? 0, onChanged: (v) => setState(() => _stamina[_athletes[_currentIndex].id] = v)),
              const SizedBox(height: 8),
              MetricRow(label: 'Flexibility', value: _flexibility[_athletes[_currentIndex].id] ?? 0, onChanged: (v) => setState(() => _flexibility[_athletes[_currentIndex].id] = v)),
              const SizedBox(height: 8),
              MetricRow(label: 'Reaction', value: _reaction[_athletes[_currentIndex].id] ?? 0, onChanged: (v) => setState(() => _reaction[_athletes[_currentIndex].id] = v)),

            ],
          ),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildDetailTile('Strength Test', 'Strength test details placeholder')),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildDetailTile('Speed & Reaction', 'Speed & reaction details placeholder')),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildDetailTile('Flexibility', 'Flexibility details placeholder')),
          CoachNotesField(controller: _notes[_athletes[_currentIndex].id]!),
          const SizedBox(height: 120),
        ],
      ),
    );
  }


  Widget _buildDetailTile(String title, String content) {
    return ExpansionTile(
      title: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      children: [Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(content, style: Theme.of(context).textTheme.bodyMedium)]))],
    );
  }
}
