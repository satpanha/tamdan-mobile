import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/training_sessions_repository.dart';
import 'package:tamdan/models/training_sessions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('TrainingSessionsRepository: save, getByAthlete, delete', () async {
    final id = 'ts_${DateTime.now().millisecondsSinceEpoch}';
    final athleteId = 'ath_${DateTime.now().millisecondsSinceEpoch}';

    final ts = TrainingSessions(
      id: id,
      dateTime: DateTime.now(),
      athleteId: athleteId,
      coachId: 'coach1',
      sessionType: 'technical',
      trainingResultId: null,
    );

    await TrainingSessionsRepository.instance.save(ts);

    final fetchedList = await TrainingSessionsRepository.instance.getByAthlete(athleteId);
    expect(fetchedList.any((s) => s.id == id), isTrue);

    final fetched = await TrainingSessionsRepository.instance.getById(id);
    expect(fetched, isNotNull);
    expect(fetched!.athleteId, equals(athleteId));

    final deleted = await TrainingSessionsRepository.instance.deleteById(id);
    expect(deleted, greaterThanOrEqualTo(0));
  });
}
