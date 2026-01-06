import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Simple singleton provider for SQLite DB.
class DBProvider {
  DBProvider._();
  static final DBProvider instance = DBProvider._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('tamdan.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    String? path;
    var useInMemory = false;

    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, fileName);
    } catch (e) {
      // Fallback for environments where path_provider is not available (tests, some platforms)
      debugPrint('path_provider unavailable: $e');
      try {
        // In some environments (e.g., web), Directory.systemTemp is not supported and will throw.
        final tempDir = Directory.systemTemp;
        path = join(tempDir.path, fileName);
      } catch (e2) {
        debugPrint('systemTemp unavailable: $e2');
        useInMemory = true;
      }
    }

    if (useInMemory) {
      debugPrint('Using in-memory DB because a writable filesystem is unavailable');
      return await openDatabase(':memory:', version: 1, onCreate: _onCreate);
    }

    try {
      debugPrint('Opening DB at path: $path');
      final db = await openDatabase(
        path!,
        version: 1,
        onCreate: _onCreate,
      );
      return db;
    } catch (e, st) {
      debugPrint('Failed to open DB at $path: $e\n$st');
      // Try to fall back to an in-memory database so app functionality continues.
      try {
        debugPrint('Attempting in-memory DB fallback');
        final db = await openDatabase(':memory:', version: 1, onCreate: _onCreate);
        return db;
      } catch (e2, st2) {
        debugPrint('In-memory DB fallback failed: $e2\n$st2');
        rethrow;
      }
    }
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        trainingSessionId TEXT,
        athleteId TEXT,
        sessionType TEXT,
        payload TEXT,
        dateTime TEXT,
        createdAt INTEGER
      )
    ''');
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<List<Map<String, Object?>>> query(String table, {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
