import 'package:test/test.dart';
import 'package:tamdan/models/user.dart';
import 'package:tamdan/models/training_sessions.dart';
import 'package:tamdan/models/physical_conditioning_sessions.dart';
import 'package:tamdan/models/strength_sessions.dart';
import 'package:tamdan/models/technical_sessions.dart';
import 'package:tamdan/models/coach_notes.dart';
import 'package:tamdan/models/training_results.dart';
import 'package:tamdan/models/skill_ratings.dart';

void main() {
  group('Other models', () {
    test('User toMap/fromMap roundtrip', () {
      final u = User(fullName: 'Coach', role: 'coach', experienceYears: 5, focusArea: 'striking');
      final m = u.toMap();
      expect(m['fullName'], 'Coach');
      final r = User.fromMap(m);
      expect(r.fullName, 'Coach');
    });

    test('TrainingSession toMap/fromMap roundtrip', () {
      final s = TrainingSession(dateTime: DateTime(2020,1,1), athleteId: 1, coachId: 2, sessionType: 'sparring');
      final m = s.toMap();
      expect(m['dateTime'], isA<String>());
      final r = TrainingSession.fromMap(m);
      expect(r.athleteId, 1);
      expect(r.dateTime, DateTime(2020,1,1));
    });

    test('PhysicalConditioningSession roundtrip', () {
      final p = PhysicalConditioningSession(trainingSessionId: 1, stamina: 8, flexibility: 7, reactionSpeed: 6);
      final m = p.toMap();
      final r = PhysicalConditioningSession.fromMap(m);
      expect(r.stamina, 8);
    });

    test('StrengthSession roundtrip', () {
      final st = StrengthSession(trainingSessionId: 1, pushUps: 10, sitUps: 20, squats: 30, kickPower: 40, coreStrength: 50, legStrength: 60);
      final m = st.toMap();
      final r = StrengthSession.fromMap(m);
      expect(r.pushUps, 10);
    });

    test('TechnicalSession roundtrip', () {
      final t = TechnicalSession(trainingSessionId: 1, speed: 9, balance: 8, control: 7, roundhouseAccuracy: 6);
      final m = t.toMap();
      final r = TechnicalSession.fromMap(m);
      expect(r.speed, 9);
    });

    test('CoachNote roundtrip', () {
      final n = CoachNote(trainingSessionId: 1, type: 'tip', message: 'Good', createdAt: DateTime.now());
      final m = n.toMap();
      final r = CoachNote.fromMap(m);
      expect(r.message, 'Good');
    });

    test('TrainingResult roundtrip', () {
      final tr = TrainingResult(trainingSessionId: 1, overallScore: 8.5, controlScore: 7.0, speedScore: 9.0, strengthScore: 6.5);
      final m = tr.toMap();
      final r = TrainingResult.fromMap(m);
      expect(r.overallScore, 8.5);
    });

    test('SkillRating roundtrip', () {
      final sr = SkillRating(speed: 6, endurance: 7, strength: 8, recordedAt: DateTime.now(), athleteId: 1);
      final m = sr.toMap();
      final r = SkillRating.fromMap(m);
      expect(r.endurance, 7);
    });
  });
}
