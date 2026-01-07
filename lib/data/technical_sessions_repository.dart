import 'package:flutter/foundation.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:tamdan/models/technical_sessions.dart';

abstract class TechnicalSessionsRepositoryInterface {
  Future<void> save(TechnicalSessions s);
  Future<List<TechnicalSessions>> getByTrainingSession(String trainingSessionId);
  Future<int> deleteById(String id);

  bool get usingInMemory;
}

class TechnicalSessionsRepository implements TechnicalSessionsRepositoryInterface {
  TechnicalSessionsRepository._();
  static TechnicalSessionsRepositoryInterface instance = TechnicalSessionsRepository._();

  final List<TechnicalSessions> _inMemory = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  @override
  Future<void> save(TechnicalSessions s) async {
    if (_useInMemory) {
      _inMemory.removeWhere((x) => x.id == s.id);
      _inMemory.add(s);
      return;
    }

    try {
      await DBProvider.instance.insert('technical_sessions', {
        'id': s.id,
        'trainingSessionId': s.trainingSessionId,
        'speed': s.speed,
        'balance': s.balance,
        'control': s.control,
        'roundhouseAccuracy': s.roundhouseAccuracy,
        'coachNotes': s.coachNotes,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e, st) {
      debugPrint('TechnicalSessions save failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.add(s);
    }
  }

  @override
  Future<List<TechnicalSessions>> getByTrainingSession(String trainingSessionId) async {
    if (_useInMemory) return _inMemory.where((t) => t.trainingSessionId == trainingSessionId).toList();
    try {
      final rows = await DBProvider.instance.query('technical_sessions', where: 'trainingSessionId = ?', whereArgs: [trainingSessionId]);
      return rows.map((r) => TechnicalSessions(
            id: r['id'] as String,
            trainingSessionId: r['trainingSessionId'] as String,
            speed: r['speed'] as int,
            balance: r['balance'] as int,
            control: r['control'] as int,
            roundhouseAccuracy: r['roundhouseAccuracy'] as int,
            coachNotes: r['coachNotes'] as String?,
          )).toList();
    } catch (e, st) {
      debugPrint('TechnicalSessions query failed, switching to in-memory: $e\n$st');
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
      return await DBProvider.instance.delete('technical_sessions', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      debugPrint('TechnicalSessions delete failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
  }
}
