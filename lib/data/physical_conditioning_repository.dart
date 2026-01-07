import 'package:flutter/foundation.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:tamdan/models/physical_conditioning_sessions.dart';

abstract class PhysicalConditioningRepositoryInterface {
  Future<void> save(PhysicalConditioningSessions s);
  Future<List<PhysicalConditioningSessions>> getByTrainingSession(String trainingSessionId);
  Future<int> deleteById(String id);

  bool get usingInMemory;
}

class PhysicalConditioningRepository implements PhysicalConditioningRepositoryInterface {
  PhysicalConditioningRepository._();
  static PhysicalConditioningRepositoryInterface instance = PhysicalConditioningRepository._();

  final List<PhysicalConditioningSessions> _inMemory = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  @override
  Future<void> save(PhysicalConditioningSessions s) async {
    if (_useInMemory) {
      _inMemory.removeWhere((x) => x.id == s.id);
      _inMemory.add(s);
      return;
    }

    try {
      await DBProvider.instance.insert('physical_conditioning_sessions', {
        'id': s.id,
        'trainingSessionId': s.trainingSessionId,
        'stamina': s.stamina,
        'flexibility': s.flexibility,
        'reactionSpeed': s.reactionSpeed,
        'coachNotes': s.coachNotes,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e, st) {
      debugPrint('PhysicalConditioning save failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.add(s);
    }
  }

  @override
  Future<List<PhysicalConditioningSessions>> getByTrainingSession(String trainingSessionId) async {
    if (_useInMemory) return _inMemory.where((t) => t.trainingSessionId == trainingSessionId).toList();
    try {
      final rows = await DBProvider.instance.query('physical_conditioning_sessions', where: 'trainingSessionId = ?', whereArgs: [trainingSessionId]);
      return rows.map((r) => PhysicalConditioningSessions(
            id: r['id'] as String,
            trainingSessionId: r['trainingSessionId'] as String,
            stamina: r['stamina'] as int,
            flexibility: r['flexibility'] as int,
            reactionSpeed: r['reactionSpeed'] as int,
            coachNotes: r['coachNotes'] as String?,
          )).toList();
    } catch (e, st) {
      debugPrint('PhysicalConditioning query failed, switching to in-memory: $e\n$st');
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
      return await DBProvider.instance.delete('physical_conditioning_sessions', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      debugPrint('PhysicalConditioning delete failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
  }
}
