import 'package:flutter/foundation.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:tamdan/models/training_results.dart';

abstract class TrainingResultsRepositoryInterface {
  Future<void> save(TrainingResults r);
  Future<TrainingResults?> getById(String id);
  Future<List<TrainingResults>> getAll();
  Future<int> deleteById(String id);

  bool get usingInMemory;
}

class TrainingResultsRepository implements TrainingResultsRepositoryInterface {
  TrainingResultsRepository._();
  static TrainingResultsRepositoryInterface instance = TrainingResultsRepository._();

  final List<TrainingResults> _inMemory = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  @override
  Future<void> save(TrainingResults r) async {
    if (_useInMemory) {
      _inMemory.removeWhere((x) => x.id == r.id);
      _inMemory.add(r);
      return;
    }

    try {
      await DBProvider.instance.insert('training_results', {
        'id': r.id,
        'overallScore': r.overallScore,
        'controlScore': r.controlScore,
        'speedScore': r.speedScore,
        'strengthScore': r.strengthScore,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e, st) {
      debugPrint('TrainingResults save failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.add(r);
    }
  }

  @override
  Future<TrainingResults?> getById(String id) async {
    if (_useInMemory) {
      try {
        return _inMemory.firstWhere((r) => r.id == id);
      } catch (e) {
        return null;
      }
    }
    try {
      final rows = await DBProvider.instance.query('training_results', where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) return null;
      final r = rows.first;
      return TrainingResults(
        id: r['id'] as String,
        overallScore: r['overallScore'] as double,
        controlScore: r['controlScore'] as double,
        speedScore: r['speedScore'] as double,
        strengthScore: r['strengthScore'] as int,
      );
    } catch (e, st) {
      debugPrint('TrainingResults getById failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      try {
        return _inMemory.firstWhere((r) => r.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<List<TrainingResults>> getAll() async {
    if (_useInMemory) return List.from(_inMemory);
    try {
      final rows = await DBProvider.instance.query('training_results');
      return rows.map((r) => TrainingResults(
            id: r['id'] as String,
            overallScore: (r['overallScore'] as num).toDouble(),
            controlScore: (r['controlScore'] as num).toDouble(),
            speedScore: (r['speedScore'] as num).toDouble(),
            strengthScore: r['strengthScore'] as int,
          )).toList();
    } catch (e, st) {
      debugPrint('TrainingResults getAll failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      return List.from(_inMemory);
    }
  }

  @override
  Future<int> deleteById(String id) async {
    if (_useInMemory) {
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
    try {
      return await DBProvider.instance.delete('training_results', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      debugPrint('TrainingResults delete failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
  }
}
