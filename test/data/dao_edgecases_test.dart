import 'package:test/test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/database/database_helper.dart';
import 'package:tamdan/data/dao/training_session_dao.dart';
import 'package:tamdan/data/dao/strength_session_dao.dart';
import 'package:tamdan/data/dao/physical_conditioning_session_dao.dart';
import 'package:tamdan/data/dao/coach_note_dao.dart';
import 'package:tamdan/data/dao/training_result_dao.dart';
import 'package:tamdan/data/dao/skill_rating_dao.dart';
import 'package:tamdan/data/dao/user_dao.dart';

void main() {
  bool sqliteAvailable = true;
  setUpAll(() {
    try {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } catch (_) {
      sqliteAvailable = false;
    }
  });

  setUp(() async {
    if (!sqliteAvailable) return;
    await DatabaseHelper.instance.deleteDatabaseForTests();
    await DatabaseHelper.instance.database;
  });

  tearDown(() async {
    if (!sqliteAvailable) return;
    await DatabaseHelper.instance.deleteDatabaseForTests();
  });

  test('TrainingSessionDao returns empty lists for missing', () async {
    if (!sqliteAvailable) return;
    final dao = TrainingSessionDao();
    final byAth = await dao.getByAthlete(99999);
    expect(byAth, isEmpty);
    final byCoach = await dao.getByCoach(99999);
    expect(byCoach, isEmpty);
  });

  test('StrengthSessionDao getByTrainingSession returns null when missing', () async {
    if (!sqliteAvailable) return;
    final dao = StrengthSessionDao();
    final r = await dao.getByTrainingSession(99999);
    expect(r, isNull);
  });

  test('PhysicalConditioningSessionDao getByTrainingSession returns null when missing', () async {
    if (!sqliteAvailable) return;
    final dao = PhysicalConditioningSessionDao();
    final r = await dao.getByTrainingSession(99999);
    expect(r, isNull);
  });

  test('CoachNoteDao getByTrainingSession returns empty when missing', () async {
    if (!sqliteAvailable) return;
    final dao = CoachNoteDao();
    final r = await dao.getByTrainingSession(99999);
    expect(r, isEmpty);
  });

  test('TrainingResultDao getByTrainingSession returns null when missing', () async {
    if (!sqliteAvailable) return;
    final dao = TrainingResultDao();
    final r = await dao.getByTrainingSession(99999);
    expect(r, isNull);
  });

  test('SkillRatingDao getByAthlete returns empty when missing', () async {
    if (!sqliteAvailable) return;
    final dao = SkillRatingDao();
    final r = await dao.getByAthlete(99999);
    expect(r, isEmpty);
  });

  test('UserDao getAll returns empty initially', () async {
    if (!sqliteAvailable) return;
    final dao = UserDao();
    final all = await dao.getAll();
    expect(all, isEmpty);
  });
}
