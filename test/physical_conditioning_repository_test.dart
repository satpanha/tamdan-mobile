import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/physical_conditioning_repository.dart';
import 'package:tamdan/models/physical_conditioning_sessions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('PhysicalConditioningRepository: save, query, delete', () async {
    final id = 'pc_${DateTime.now().millisecondsSinceEpoch}';
    final tsId = 'ts_${DateTime.now().millisecondsSinceEpoch}';

    final s = PhysicalConditioningSessions(
      id: id,
      trainingSessionId: tsId,
      stamina: 8,
      flexibility: 7,
      reactionSpeed: 6,
      coachNotes: 'work on flexibility',
    );

    await PhysicalConditioningRepository.instance.save(s);

    final list = await PhysicalConditioningRepository.instance.getByTrainingSession(tsId);
    expect(list.any((x) => x.id == id), isTrue);

    final deleted = await PhysicalConditioningRepository.instance.deleteById(id);
    expect(deleted, greaterThanOrEqualTo(0));
  });
}
