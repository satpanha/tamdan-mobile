library;
import 'package:flutter/material.dart';
import 'package:tamdan/models/technical_sessions.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/ui/widgets/base_screen.dart';
import 'package:tamdan/ui/widgets/athlete_header.dart';
import 'package:tamdan/ui/widgets/metric_section.dart';
import 'package:tamdan/ui/widgets/rating_bar.dart';
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

  // per-athlete state
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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save session: ${e.toString()}'),
      ));
      return;
    }

    debugPrint('Saved technical session: ${session.id} for ${athlete.name}');

    // Inform user of success, allow quick return to tracking
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Technical session saved'),
      action: SnackBarAction(label: 'Back to tracking', onPressed: () => Navigator.of(context).pushNamed(AppRoutes.tracking)),
    ));

    // Show a confirmation dialog and wait for user to close it before navigating
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Saved'),
        content: const Text('Session saved successfully.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
          ElevatedButton(onPressed: () => Navigator.of(context).pushNamed(AppRoutes.tracking), child: const Text('Back to tracking')),
        ],
      ),
    );

    // Navigate to training results for the saved athlete
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
          MetricSection(
            title: 'Core performance',
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Speed'),
                  RatingBar(value: _speed[_athletes[_currentIndex].id] ?? 0, onChanged: (v) => setState(() => _speed[_athletes[_currentIndex].id] = v)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Balance'),
                  RatingBar(value: _balance[_athletes[_currentIndex].id] ?? 0, onChanged: (v) => setState(() => _balance[_athletes[_currentIndex].id] = v)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Control'),
                  RatingBar(value: _control[_athletes[_currentIndex].id] ?? 0, onChanged: (v) => setState(() => _control[_athletes[_currentIndex].id] = v)),
                ],
              ),
            ],
          ),
          MetricSection(
            title: 'Kicking metrics',
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text('Roundhouse accuracy: ${(_roundhouse[_athletes[_currentIndex].id] ?? 0).round()}%')),
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
