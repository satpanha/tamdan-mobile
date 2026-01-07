import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/athlete_repository.dart';
import 'package:tamdan/models/athlete.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('AthleteRepository: full CRUD and list', () async {
    final id = 'ath_${DateTime.now().millisecondsSinceEpoch}';
    final a = Athlete(
      id: id,
      name: 'Test Athlete',
      dateOfBirth: DateTime(2000, 1, 1),
      gender: 'M',
      beltLevel: 'Blue',
      status: 'active',
    );

    // Create
    await AthleteRepository.instance.save(a);

    // Read
    var fetched = await AthleteRepository.instance.getById(id);
    expect(fetched, isNotNull);
    expect(fetched!.id, equals(a.id));
    expect(fetched.name, equals(a.name));
    expect(fetched.beltLevel, equals(a.beltLevel));

    // Update (save with same id, new name)
    final updated = Athlete(
      id: id,
      name: 'Updated Name',
      dateOfBirth: a.dateOfBirth,
      gender: a.gender,
      beltLevel: a.beltLevel,
      status: a.status,
    );
    await AthleteRepository.instance.save(updated);

    final afterUpdate = await AthleteRepository.instance.getById(id);
    expect(afterUpdate, isNotNull);
    expect(afterUpdate!.name, equals('Updated Name'));

    // List
    final all = await AthleteRepository.instance.getAll();
    expect(all.any((x) => x.id == id), isTrue);

    // Delete
    final deleted = await AthleteRepository.instance.deleteById(id);
    expect(deleted, greaterThanOrEqualTo(0));

    final afterDelete = await AthleteRepository.instance.getById(id);
    expect(afterDelete, isNull);
  });
}
