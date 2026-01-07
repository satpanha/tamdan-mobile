import 'package:flutter/foundation.dart';
import 'package:tamdan/data/db_provider.dart';
import 'package:tamdan/models/user.dart';

abstract class UserRepositoryInterface {
  Future<void> save(User u);
  Future<User?> getByName(String name);
  Future<List<User>> getAll();
  Future<int> deleteByName(String name);

  bool get usingInMemory;
}

class UserRepository implements UserRepositoryInterface {
  UserRepository._();
  static UserRepositoryInterface instance = UserRepository._();

  final List<User> _inMemory = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  @override
  Future<void> save(User u) async {
    if (_useInMemory) {
      _inMemory.removeWhere((x) => x.name == u.name);
      _inMemory.add(u);
      return;
    }

    try {
      await DBProvider.instance.insert('users', {
        'id': u.name, // fallback id
        'name': u.name,
        'role': u.role,
        'dateOfBirth': u.dateOfBirth.toIso8601String(),
        'gender': u.gender,
        'experience': u.experience,
        'focusOn': u.focusOn,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e, st) {
      debugPrint('User save failed, using in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.add(u);
    }
  }

  @override
  Future<User?> getByName(String name) async {
    if (_useInMemory) {
      try {
        return _inMemory.firstWhere((u) => u.name == name);
      } catch (e) {
        return null;
      }
    }
    try {
      final rows = await DBProvider.instance.query('users', where: 'name = ?', whereArgs: [name]);
      if (rows.isEmpty) return null;
      final r = rows.first;
      return User(
        name: r['name'] as String,
        role: r['role'] as String,
        dateOfBirth: DateTime.parse(r['dateOfBirth'] as String),
        gender: r['gender'] as String,
        experience: r['experience'] as String,
        focusOn: r['focusOn'] as String,
      );
    } catch (e, st) {
      debugPrint('User getByName failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      try {
        return _inMemory.firstWhere((u) => u.name == name);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<List<User>> getAll() async {
    if (_useInMemory) return List.from(_inMemory);
    try {
      final rows = await DBProvider.instance.query('users');
      return rows.map((r) => User(
            name: r['name'] as String,
            role: r['role'] as String,
            dateOfBirth: DateTime.parse(r['dateOfBirth'] as String),
            gender: r['gender'] as String,
            experience: r['experience'] as String,
            focusOn: r['focusOn'] as String,
          )).toList();
    } catch (e, st) {
      debugPrint('User getAll failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      return List.from(_inMemory);
    }
  }

  @override
  Future<int> deleteByName(String name) async {
    if (_useInMemory) {
      _inMemory.removeWhere((r) => r.name == name);
      return 1;
    }
    try {
      return await DBProvider.instance.delete('users', where: 'name = ?', whereArgs: [name]);
    } catch (e, st) {
      debugPrint('User delete failed, switching to in-memory: $e\n$st');
      _useInMemory = true;
      _inMemory.removeWhere((r) => r.name == name);
      return 1;
    }
  }
}
