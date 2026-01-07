import 'package:flutter/foundation.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:tamdan/models/strength_sessions.dart';

abstract class StrengthSessionsRepositoryInterface {
  Future<void> save(StrengthSessions s);
  Future<List<StrengthSessions>> getByTrainingSession(String trainingSessionId);
  Future<int> deleteById(String id);

  bool get usingInMemory;
}

class StrengthSessionsRepository implements StrengthSessionsRepositoryInterface {
  StrengthSessionsRepository._();
  static StrengthSessionsRepositoryInterface instance = StrengthSessionsRepository._();

  final List<StrengthSessions> _inMemory = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  @override
  Future<void> save(StrengthSessions s) async {
    if (_useInMemory) {
      _inMemory.removeWhere((x) => x.id == s.id);
      _inMemory.add(s);
      return;
    }

    try {
      await DBProvider.instance.insert('strength_sessions', {
        'id': s.id,
        'trainingSessionId': s.trainingSessionId,
        'pushUps': s.pushUps,
        'sitUps': s.sitUps,
        'squats': s.squats,
        'kickPower': s.kickPower,
        'coreStrength': s.coreStrength,
        'legStrength': s.legStrength,
        'coachNotes': s.coachNotes,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e, st) {
      debugPrint('StrengthSessions save failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.add(s);
    }
  }

  @override
  Future<List<StrengthSessions>> getByTrainingSession(String trainingSessionId) async {
    if (_useInMemory) return _inMemory.where((t) => t.trainingSessionId == trainingSessionId).toList();
    try {
      final rows = await DBProvider.instance.query('strength_sessions', where: 'trainingSessionId = ?', whereArgs: [trainingSessionId]);
      return rows.map((r) => StrengthSessions(
            id: r['id'] as String,
            trainingSessionId: r['trainingSessionId'] as String,
            pushUps: r['pushUps'] as int,
            sitUps: r['sitUps'] as int,
            squats: r['squats'] as int,
            kickPower: r['kickPower'] as int,
            coreStrength: r['coreStrength'] as int,
            legStrength: r['legStrength'] as int,
            coachNotes: r['coachNotes'] as String?,
          )).toList();
    } catch (e, st) {
      debugPrint('StrengthSessions query failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      return _inMemory.where((t) => t.trainingSessionId == trainingSessionId).toList();
    }
  }

  @override
  Future<int> deleteById(String id) async {
    if (_useInMemory) {
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
    try {
      return await DBProvider.instance.delete('strength_sessions', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      debugPrint('StrengthSessions delete failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
  }
}
