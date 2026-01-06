import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/ui/screens/training_results.dart';
import 'package:tamdan/data/session_repository.dart';
import 'package:tamdan/data/session_repository.dart' as repo;

void main() {
  testWidgets('Training results aggregates session payloads into summary', (tester) async {
    // Setup fake repo with one of each type
    final athleteId = 'athlete-1';
    final sessions = <repo.SessionRecord>[
      repo.SessionRecord(
          id: 't1',
          trainingSessionId: '',
          athleteId: athleteId,
          sessionType: 'technical',
          payload: {'speed': 5, 'balance': 5, 'control': 5, 'roundhouseAccuracy': 80},
          dateTime: DateTime.now()),
      repo.SessionRecord(
          id: 's1',
          trainingSessionId: '',
          athleteId: athleteId,
          sessionType: 'strength',
          payload: {'pushUps': 50, 'sitUps': 50, 'squats': 50, 'kickPower': 100, 'coreStrength': 100, 'legStrength': 100},
          dateTime: DateTime.now()),
      repo.SessionRecord(
          id: 'p1',
          trainingSessionId: '',
          athleteId: athleteId,
          sessionType: 'physical',
          payload: {'stamina': 80, 'flexibility': 70, 'reactionSpeed': 90},
          dateTime: DateTime.now()),
    ];

    SessionRepository.instance = _FakeRepo(sessions);

    await tester.pumpWidget(MaterialApp(
      routes: {
        '/': (context) => Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/results', arguments: {'athleteId': athleteId}),
                child: const Text('Open'),
              ),
            ),
        '/results': (context) => const TrainingResultsScreen(),
      },
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Expect overall to be (95 + 50 + 80)/3 = 75
    expect(find.text('Overall'), findsOneWidget);
    expect(find.text('75'), findsWidgets);
    expect(find.text('Stamina'), findsOneWidget);
    expect(find.text('80'), findsWidgets);
  });
}

class _FakeRepo implements SessionRepositoryInterface {
  final List<SessionRecord> _store;
  _FakeRepo(this._store);

  @override
  bool get usingInMemory => false;

  @override
  Future<void> save(SessionRecord r) async => _store.add(r);

  @override
  Future<List<SessionRecord>> getByAthlete(String athleteId) async => _store.where((s) => s.athleteId == athleteId).toList();

  @override
  Future<int> deleteById(String id) async {
    _store.removeWhere((s) => s.id == id);
    return 1;
  }
}
