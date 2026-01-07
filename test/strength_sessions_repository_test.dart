import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/strength_sessions_repository.dart';
import 'package:tamdan/models/strength_sessions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('StrengthSessionsRepository: save, query, delete', () async {
    final id = 'str_${DateTime.now().millisecondsSinceEpoch}';
    final tsId = 'ts_${DateTime.now().millisecondsSinceEpoch}';

    final s = StrengthSessions(
      id: id,
      trainingSessionId: tsId,
      pushUps: 20,
      sitUps: 30,
      squats: 40,
      kickPower: 50,
      coreStrength: 60,
      legStrength: 70,
      coachNotes: 'keep going',
    );

    await StrengthSessionsRepository.instance.save(s);

    final list = await StrengthSessionsRepository.instance.getByTrainingSession(tsId);
    expect(list.any((x) => x.id == id), isTrue);

    final deleted = await StrengthSessionsRepository.instance.deleteById(id);
    expect(deleted, greaterThanOrEqualTo(0));
  });
}
