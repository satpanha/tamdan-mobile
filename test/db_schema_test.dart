import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize ffi and bindings so sqflite and path_provider work in tests
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('DB has expected tables', () async {
    final db = await DBProvider.instance.database;
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    final names = tables.map((r) => r['name'] as String).toSet();

    // Expected tables
    final expected = {
      'sessions',
      'athletes',
      'users',
      'coach_notes',
      'training_sessions',
      'technical_sessions',
      'strength_sessions',
      'physical_conditioning_sessions',
      'skill_ratings',
      'training_results',
    };

    for (final t in expected) {
      expect(names.contains(t), isTrue, reason: 'Missing table: $t');
    }
  });
}
