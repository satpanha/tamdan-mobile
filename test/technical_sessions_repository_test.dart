import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/technical_sessions_repository.dart';
import 'package:tamdan/models/technical_sessions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('TechnicalSessionsRepository: save, query, delete', () async {
    final id = 'tech_${DateTime.now().millisecondsSinceEpoch}';
    final tsId = 'ts_${DateTime.now().millisecondsSinceEpoch}';

    final s = TechnicalSessions(
      id: id,
      trainingSessionId: tsId,
      speed: 5,
      balance: 4,
      control: 3,
      roundhouseAccuracy: 2,
      coachNotes: 'notes',
    );

    await TechnicalSessionsRepository.instance.save(s);

    final list = await TechnicalSessionsRepository.instance.getByTrainingSession(tsId);
    expect(list.any((x) => x.id == id), isTrue);

    final deleted = await TechnicalSessionsRepository.instance.deleteById(id);
    expect(deleted, greaterThanOrEqualTo(0));
  });
}
