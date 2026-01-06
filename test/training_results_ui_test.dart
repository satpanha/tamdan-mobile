import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/ui/screens/training_results.dart';
import 'package:tamdan/data/session_repository.dart';

void main() {
  testWidgets('Shows temporary store banner when using in-memory repository', (tester) async {
    final athleteId = 'a1';

    final fake = _FakeRepoWithFlag();
    SessionRepository.instance = fake;

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

    expect(find.text('Temporary local store active'), findsOneWidget);
  });
}

class _FakeRepoWithFlag implements SessionRepositoryInterface {
  @override
  bool get usingInMemory => true;

  @override
  Future<void> save(SessionRecord r) async {}

  @override
  Future<List<SessionRecord>> getByAthlete(String athleteId) async => [];

  @override
  Future<int> deleteById(String id) async => 1;
}