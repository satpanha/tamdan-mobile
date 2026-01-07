import 'package:flutter/foundation.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:tamdan/models/training_sessions.dart';

abstract class TrainingSessionsRepositoryInterface {
  Future<void> save(TrainingSessions s);
  Future<TrainingSessions?> getById(String id);
  Future<List<TrainingSessions>> getByAthlete(String athleteId);
  Future<int> deleteById(String id);

  bool get usingInMemory;
}

class TrainingSessionsRepository implements TrainingSessionsRepositoryInterface {
  TrainingSessionsRepository._();
  static TrainingSessionsRepositoryInterface instance = TrainingSessionsRepository._();

  final List<TrainingSessions> _inMemory = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  @override
  Future<void> save(TrainingSessions s) async {
    if (_useInMemory) {
      _inMemory.removeWhere((x) => x.id == s.id);
      _inMemory.add(s);
      return;
    }

    try {
      await DBProvider.instance.insert('training_sessions', {
        'id': s.id,
        'dateTime': s.dateTime.toIso8601String(),
        'athleteId': s.athleteId,
        'coachId': s.coachId,
        'sessionType': s.sessionType,
        'trainingResultId': s.trainingResultId,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e, st) {
      debugPrint('TrainingSessions save failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.add(s);
    }
  }

  @override
  Future<TrainingSessions?> getById(String id) async {
    if (_useInMemory) {
      try {
        return _inMemory.firstWhere((t) => t.id == id);
      } catch (e) {
        return null;
      }
    }
    try {
      final rows = await DBProvider.instance.query('training_sessions', where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) return null;
      final r = rows.first;
      return TrainingSessions(
        id: r['id'] as String,
        dateTime: DateTime.parse(r['dateTime'] as String),
        athleteId: r['athleteId'] as String,
        coachId: r['coachId'] as String,
        sessionType: r['sessionType'] as String,
        trainingResultId: r['trainingResultId'] as String?,
      );
    } catch (e, st) {
      debugPrint('TrainingSessions getById failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      try {
        return _inMemory.firstWhere((t) => t.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<List<TrainingSessions>> getByAthlete(String athleteId) async {
    if (_useInMemory) return _inMemory.where((t) => t.athleteId == athleteId).toList();
    try {
      final rows = await DBProvider.instance.query('training_sessions', where: 'athleteId = ?', whereArgs: [athleteId]);
      return rows.map((r) => TrainingSessions(
            id: r['id'] as String,
            dateTime: DateTime.parse(r['dateTime'] as String),
            athleteId: r['athleteId'] as String,
            coachId: r['coachId'] as String,
            sessionType: r['sessionType'] as String,
            trainingResultId: r['trainingResultId'] as String?,
          )).toList();
    } catch (e, st) {
      debugPrint('TrainingSessions query failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      return _inMemory.where((t) => t.athleteId == athleteId).toList();
    }
  }

  @override
  Future<int> deleteById(String id) async {
    if (_useInMemory) {
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
    try {
      return await DBProvider.instance.delete('training_sessions', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      debugPrint('TrainingSessions delete failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
  }
}
