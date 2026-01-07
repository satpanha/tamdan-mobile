import 'package:flutter/foundation.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tamdan/models/athlete.dart';

abstract class AthleteRepositoryInterface {
  Future<void> save(Athlete a);
  Future<Athlete?> getById(String id);
  Future<List<Athlete>> getAll();
  Future<int> deleteById(String id);

  bool get usingInMemory;
} 

class AthleteRepository implements AthleteRepositoryInterface {
  AthleteRepository._();
  static AthleteRepositoryInterface instance = AthleteRepository._();

  final List<Athlete> _inMemory = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  @override
  Future<void> save(Athlete a) async {
    if (_useInMemory) {
      _inMemory.removeWhere((x) => x.id == a.id);
      _inMemory.add(a);
      return;
    }

    try {
      await DBProvider.instance.insert('athletes', {
        'id': a.id,
        'name': a.name,
        'dateOfBirth': a.dateOfBirth.toIso8601String(),
        'gender': a.gender,
        'beltLevel': a.beltLevel,
        'status': a.status,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e, st) {
      debugPrint('Athlete save failed, using in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.add(a);
    }
  }

  @override
  Future<Athlete?> getById(String id) async {
    if (_useInMemory) {
      try {
        return _inMemory.firstWhere((a) => a.id == id);
      } catch (e) {
        return null;
      }
    }
    try {
      final rows = await DBProvider.instance.query('athletes', where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) return null;
      final r = rows.first;
      return Athlete(
        id: r['id'] as String,
        name: r['name'] as String,
        dateOfBirth: DateTime.parse(r['dateOfBirth'] as String),
        gender: r['gender'] as String,
        beltLevel: r['beltLevel'] as String,
        status: r['status'] as String,
      );
    } catch (e, st) {
      debugPrint('Athlete getById failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      try {
        return _inMemory.firstWhere((a) => a.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<List<Athlete>> getAll() async {
    if (_useInMemory) return List.from(_inMemory);
    try {
      final rows = await DBProvider.instance.query('athletes');
      return rows.map((r) => Athlete(
            id: r['id'] as String,
            name: r['name'] as String,
            dateOfBirth: DateTime.parse(r['dateOfBirth'] as String),
            gender: r['gender'] as String,
            beltLevel: r['beltLevel'] as String,
            status: r['status'] as String,
          )).toList();
    } catch (e, st) {
      debugPrint('Athlete getAll failed, switching to in-memory: $e\n$st');
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
      return await DBProvider.instance.delete('athletes', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      debugPrint('Athlete delete failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.removeWhere((r) => r.id == id);
      return 1;
    }
  }
}
