import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/skill_ratings_repository.dart';
import 'package:tamdan/models/skill_ratings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('SkillRatingsRepository: save, get, delete', () async {
    final id = 'sr_${DateTime.now().millisecondsSinceEpoch}';

    final r = SkillRatings(
      id: id,
      striking: 9,
      endurance: 8,
      defense: 7,
    );

    await SkillRatingsRepository.instance.save(r);

    final fetched = await SkillRatingsRepository.instance.getById(id);
    expect(fetched, isNotNull);
    expect(fetched!.striking, equals(r.striking));

    final deleted = await SkillRatingsRepository.instance.deleteById(id);
    expect(deleted, greaterThanOrEqualTo(0));
  });
}
