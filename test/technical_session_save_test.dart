import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/routes/app_routes.dart';
import 'package:tamdan/ui/screens/technical_session.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/data/session_repository.dart';

void main() {
  testWidgets('Save session shows dialog and navigates to results', (tester) async {
    final ids = mockAthletes.take(1).map((e) => e.id).toList();

    // Override repository to avoid actual DB operations in tests
    SessionRepository.instance = _FakeSessionRepository();

    await tester.pumpWidget(MaterialApp(
      routes: {
        '/': (context) => Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/tech', arguments: {'athleteIds': ids}),
                child: const Text('Open'),
              ),
            ),
        '/tech': (context) => const TechnicalSessionScreen(),
        AppRoutes.trainingResults: (context) => const Scaffold(body: Center(child: Text('Results'))),
      },
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Press save
    final saveButton = find.widgetWithText(ElevatedButton, 'Save session');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Should navigate directly to results
    expect(find.text('Results'), findsOneWidget);
  });
}

class _FakeSessionRepository implements SessionRepositoryInterface {
  final List<SessionRecord> _store = [];

  @override
  bool get usingInMemory => false;

  @override
  Future<int> deleteById(String id) async {
    _store.removeWhere((r) => r.id == id);
    return 1;
  }

  @override
  Future<List<SessionRecord>> getByAthlete(String athleteId) async => _store.where((r) => r.athleteId == athleteId).toList();

  @override
  Future<void> save(SessionRecord r) async {
    _store.add(r);
  }
}
