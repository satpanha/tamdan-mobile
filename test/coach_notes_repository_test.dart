import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/coach_notes_repository.dart';
import 'package:tamdan/models/coach_notes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('CoachNotesRepository: save, query, delete', () async {
    final id = 'note_${DateTime.now().millisecondsSinceEpoch}';
    final tsId = 'ts_${DateTime.now().millisecondsSinceEpoch}';

    final note = CoachNotes(
      id: id,
      trainingSessionId: tsId,
      type: 'feedback',
      message: 'Keep the guard up',
      createdAt: DateTime.now(),
    );

    await CoachNotesRepository.instance.save(note);

    final list = await CoachNotesRepository.instance.getByTrainingSession(tsId);
    expect(list.any((n) => n.id == id), isTrue);

    final deleted = await CoachNotesRepository.instance.deleteById(id);
    expect(deleted, greaterThanOrEqualTo(0));

    final after = await CoachNotesRepository.instance.getByTrainingSession(tsId);
    expect(after.any((n) => n.id == id), isFalse);
  });
}
