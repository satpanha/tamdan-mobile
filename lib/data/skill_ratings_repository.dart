import 'package:flutter/foundation.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:tamdan/models/skill_ratings.dart';

abstract class SkillRatingsRepositoryInterface {
  Future<void> save(SkillRatings r);
  Future<SkillRatings?> getById(String id);
  Future<List<SkillRatings>> getAll();
  Future<int> deleteById(String id);

  bool get usingInMemory;
}

class SkillRatingsRepository implements SkillRatingsRepositoryInterface {
  SkillRatingsRepository._();
  static SkillRatingsRepositoryInterface instance = SkillRatingsRepository._();

  final List<SkillRatings> _inMemory = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  @override
  Future<void> save(SkillRatings r) async {
    if (_useInMemory) {
      _inMemory.removeWhere((x) => x.id == r.id);
      _inMemory.add(r);
      return;
    }

    try {
      await DBProvider.instance.insert('skill_ratings', {
        'id': r.id,
        'striking': r.striking,
        'endurance': r.endurance,
        'defense': r.defense,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e, st) {
      debugPrint('SkillRatings save failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.add(r);
    }
  }

  @override
  Future<SkillRatings?> getById(String id) async {
    if (_useInMemory) {
      try {
        return _inMemory.firstWhere((r) => r.id == id);
      } catch (e) {
        return null;
      }
    }
    try {
      final rows = await DBProvider.instance.query('skill_ratings', where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) return null;
      final r = rows.first;
      return SkillRatings(
        id: r['id'] as String,
        striking: r['striking'] as int,
        endurance: r['endurance'] as int,
        defense: r['defense'] as int,
      );
    } catch (e, st) {
      debugPrint('SkillRatings getById failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      try {
        return _inMemory.firstWhere((r) => r.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<List<SkillRatings>> getAll() async {
    if (_useInMemory) return List.from(_inMemory);
    try {
      final rows = await DBProvider.instance.query('skill_ratings');
      return rows.map((r) => SkillRatings(
            id: r['id'] as String,
            striking: r['striking'] as int,
            endurance: r['endurance'] as int,
            defense: r['defense'] as int,
          )).toList();
    } catch (e, st) {
      debugPrint('SkillRatings getAll failed, switching to in-memory: $e\n$st');
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
      return await DBProvider.instance.delete('skill_ratings', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      debugPrint('SkillRatings delete failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
  }
}
