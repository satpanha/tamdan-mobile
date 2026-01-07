library;
import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/models/strength_sessions.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/ui/widgets/base_screen.dart';
import 'package:tamdan/ui/widgets/athlete_header.dart';
import 'package:tamdan/ui/widgets/metric_section.dart';
import 'package:tamdan/ui/widgets/core_performance_section.dart';
import 'package:tamdan/ui/widgets/coach_notes_field.dart';
import 'package:tamdan/ui/widgets/primary_button.dart';
import 'package:tamdan/routes/app_routes.dart';
import 'package:tamdan/data/session_repository.dart';

class StrengthSessionScreen extends StatefulWidget {
  const StrengthSessionScreen({super.key});

  @override
  State<StrengthSessionScreen> createState() => _StrengthSessionScreenState();
}

class _StrengthSessionScreenState extends State<StrengthSessionScreen> {
  late List<Athlete> _athletes;
  int _currentIndex = 0;

  final Map<String, TextEditingController> _push = {};
  final Map<String, TextEditingController> _sit = {};
  final Map<String, TextEditingController> _squat = {};
  final Map<String, int> _kickPower = {};
  final Map<String, int> _coreStrength = {};
  final Map<String, int> _legStrength = {};
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
      _push.putIfAbsent(a.id, () => TextEditingController());
      _sit.putIfAbsent(a.id, () => TextEditingController());
      _squat.putIfAbsent(a.id, () => TextEditingController());
      _kickPower.putIfAbsent(a.id, () => 0);
      _coreStrength.putIfAbsent(a.id, () => 0);
      _legStrength.putIfAbsent(a.id, () => 0);
      _notes.putIfAbsent(a.id, () => TextEditingController());
    }
  }

  Future<void> _save() async {
    final athlete = _athletes[_currentIndex];
    final session = StrengthSessions(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      trainingSessionId: '',
      pushUps: int.tryParse(_push[athlete.id]?.text ?? '') ?? 0,
      sitUps: int.tryParse(_sit[athlete.id]?.text ?? '') ?? 0,
      squats: int.tryParse(_squat[athlete.id]?.text ?? '') ?? 0,
      kickPower: _kickPower[athlete.id] ?? 0,
      coreStrength: _coreStrength[athlete.id] ?? 0,
      legStrength: _legStrength[athlete.id] ?? 0,
      coachNotes: _notes[athlete.id]?.text.isEmpty ?? true ? null : _notes[athlete.id]?.text,
    );

    final record = SessionRecord(
      id: session.id,
      trainingSessionId: session.trainingSessionId,
      athleteId: athlete.id,
      sessionType: 'strength',
      payload: {
        'pushUps': session.pushUps,
        'sitUps': session.sitUps,
        'squats': session.squats,
        'kickPower': session.kickPower,
        'coreStrength': session.coreStrength,
        'legStrength': session.legStrength,
        'coachNotes': session.coachNotes,
      },
      dateTime: DateTime.now(),
    );

    await SessionRepository.instance.save(record);

    if (!mounted) return;
    debugPrint('Saved strength session: ${session.id} for ${athlete.name}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Strength session saved'),
      action: SnackBarAction(label: 'Back to tracking', onPressed: () => Navigator.of(context).pushNamed(AppRoutes.tracking)),
    ));

    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRoutes.trainingResults, arguments: {'athleteId': athlete.id});
  }

  Widget _numberField(String label, TextEditingController controller) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Strength Session',
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
            title: 'Repetitions',
            children: [
              _numberField('Push-ups', _push[_athletes[_currentIndex].id]!),
              _numberField('Sit-ups', _sit[_athletes[_currentIndex].id]!),
              _numberField('Squats', _squat[_athletes[_currentIndex].id]!),
            ],
          ),
          CorePerformanceSection(
            stamina: _kickPower[_athletes[_currentIndex].id] ?? 0,
            flexibility: _coreStrength[_athletes[_currentIndex].id] ?? 0,
            reaction: _legStrength[_athletes[_currentIndex].id] ?? 0,
            onStaminaChanged: (v) => setState(() => _kickPower[_athletes[_currentIndex].id] = v),
            onFlexibilityChanged: (v) => setState(() => _coreStrength[_athletes[_currentIndex].id] = v),
            onReactionChanged: (v) => setState(() => _legStrength[_athletes[_currentIndex].id] = v),
          ),
          CoachNotesField(controller: _notes[_athletes[_currentIndex].id]!),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
