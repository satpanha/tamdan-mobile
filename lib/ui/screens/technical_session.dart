import 'package:flutter/material.dart';
import 'package:tamdan/models/technical_sessions.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/ui/widgets/core_performance_section.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/ui/widgets/base_screen.dart';
import 'package:tamdan/ui/widgets/athlete_header.dart';
import 'package:tamdan/ui/widgets/metric_section.dart';

import 'package:tamdan/ui/widgets/coach_notes_field.dart';
import 'package:tamdan/ui/widgets/primary_button.dart';
import 'package:tamdan/routes/app_routes.dart';
import 'package:tamdan/data/session_repository.dart';

class TechnicalSessionScreen extends StatefulWidget {
  const TechnicalSessionScreen({super.key});

  @override
  State<TechnicalSessionScreen> createState() => _TechnicalSessionScreenState();
}

class _TechnicalSessionScreenState extends State<TechnicalSessionScreen> {
  late List<Athlete> _athletes;
  int _currentIndex = 0;

  final Map<String, int> _speed = {};
  final Map<String, int> _balance = {};
  final Map<String, int> _control = {};
  final Map<String, double> _roundhouse = {};
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
      _speed.putIfAbsent(a.id, () => 0);
      _balance.putIfAbsent(a.id, () => 0);
      _control.putIfAbsent(a.id, () => 0);
      _roundhouse.putIfAbsent(a.id, () => 0);
      _notes.putIfAbsent(a.id, () => TextEditingController());
    }
  }

  Future<void> _save() async {
    final athlete = _athletes[_currentIndex];
    final session = TechnicalSessions(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      trainingSessionId: '',
      speed: _speed[athlete.id] ?? 0,
      balance: _balance[athlete.id] ?? 0,
      control: _control[athlete.id] ?? 0,
      roundhouseAccuracy: (_roundhouse[athlete.id] ?? 0).round(),
      coachNotes: _notes[athlete.id]?.text.isEmpty ?? true ? null : _notes[athlete.id]?.text,
    );

    final record = SessionRecord(
      id: session.id,
      trainingSessionId: session.trainingSessionId,
      athleteId: athlete.id,
      sessionType: 'technical',
      payload: {
        'speed': session.speed,
        'balance': session.balance,
        'control': session.control,
        'roundhouseAccuracy': session.roundhouseAccuracy,
        'coachNotes': session.coachNotes,
      },
      dateTime: DateTime.now(),
    );

    try {
      await SessionRepository.instance.save(record);
    } catch (e, st) {
      debugPrint('Failed to save technical session: $e\n$st');

      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Failed to save session'),
          content: SingleChildScrollView(
            child: SelectableText('Error: $e\n\nStacktrace:\n$st'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
          ],
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save session: ${e.toString()}'),
      ));
      return;
    }

    debugPrint('Saved technical session: ${session.id} for ${athlete.name}');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Technical session saved'),
      action: SnackBarAction(label: 'Back to tracking', onPressed: () => Navigator.of(context).pushNamed(AppRoutes.tracking)),
    ));

    if (!mounted) return;
    Navigator.of(context).pushNamed(AppRoutes.trainingResults, arguments: {'athleteId': athlete.id});
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Technical Session',
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
          CorePerformanceSection(
            stamina: _speed[_athletes[_currentIndex].id] ?? 0,
            flexibility: _balance[_athletes[_currentIndex].id] ?? 0,
            reaction: _control[_athletes[_currentIndex].id] ?? 0,
            onStaminaChanged: (v) => setState(() => _speed[_athletes[_currentIndex].id] = v),
            onFlexibilityChanged: (v) => setState(() => _balance[_athletes[_currentIndex].id] = v),
            onReactionChanged: (v) => setState(() => _control[_athletes[_currentIndex].id] = v),
          ),
          MetricSection(
            title: 'Kicking metrics',
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text('Roundhouse accuracy: ${(_roundhouse[_athletes[_currentIndex].id] ?? 0).round()}%', style: Theme.of(context).textTheme.bodyMedium)),
                  Expanded(
                    child: Slider(
                      value: _roundhouse[_athletes[_currentIndex].id] ?? 0,
                      onChanged: (v) => setState(() => _roundhouse[_athletes[_currentIndex].id] = v),
                      min: 0,
                      max: 100,
                      divisions: 20,
                    ),
                  )
                ],
              ),
            ],
          ),
          CoachNotesField(controller: _notes[_athletes[_currentIndex].id]!),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
