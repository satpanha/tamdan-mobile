import 'package:flutter/foundation.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:tamdan/models/coach_notes.dart';

abstract class CoachNotesRepositoryInterface {
  Future<void> save(CoachNotes n);
  Future<List<CoachNotes>> getByTrainingSession(String trainingSessionId);
  Future<int> deleteById(String id);

  bool get usingInMemory;
}

class CoachNotesRepository implements CoachNotesRepositoryInterface {
  CoachNotesRepository._();
  static CoachNotesRepositoryInterface instance = CoachNotesRepository._();

  final List<CoachNotes> _inMemory = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  @override
  Future<void> save(CoachNotes n) async {
    if (_useInMemory) {
      _inMemory.removeWhere((x) => x.id == n.id);
      _inMemory.add(n);
      return;
    }

    try {
      await DBProvider.instance.insert('coach_notes', {
        'id': n.id,
        'trainingSessionId': n.trainingSessionId,
        'type': n.type,
        'message': n.message,
        'createdAt': n.createdAt.millisecondsSinceEpoch,
      });
    } catch (e, st) {
      debugPrint('CoachNotes save failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.add(n);
    }
  }

  @override
  Future<List<CoachNotes>> getByTrainingSession(String trainingSessionId) async {
    if (_useInMemory) return _inMemory.where((n) => n.trainingSessionId == trainingSessionId).toList();
    try {
      final rows = await DBProvider.instance.query('coach_notes', where: 'trainingSessionId = ?', whereArgs: [trainingSessionId]);
      return rows.map((r) => CoachNotes(
            id: r['id'] as String,
            trainingSessionId: r['trainingSessionId'] as String,
            type: r['type'] as String,
            message: r['message'] as String,
            createdAt: DateTime.fromMillisecondsSinceEpoch(r['createdAt'] as int),
          )).toList();
    } catch (e, st) {
      debugPrint('CoachNotes query failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      return _inMemory.where((n) => n.trainingSessionId == trainingSessionId).toList();
    }
  }

  @override
  Future<int> deleteById(String id) async {
    if (_useInMemory) {
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
    try {
      return await DBProvider.instance.delete('coach_notes', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      debugPrint('CoachNotes delete failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
  }
}
