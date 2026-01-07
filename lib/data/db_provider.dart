import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
      debugPrint('path_provider unavailable: $e');
      try {
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

    // Additional tables derived from the models
    await db.execute('''
      CREATE TABLE athletes (
        id TEXT PRIMARY KEY,
        name TEXT,
        dateOfBirth TEXT,
        gender TEXT,
        beltLevel TEXT,
        status TEXT,
        createdAt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT,
        role TEXT,
        dateOfBirth TEXT,
        gender TEXT,
        experience TEXT,
        focusOn TEXT,
        createdAt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE coach_notes (
        id TEXT PRIMARY KEY,
        trainingSessionId TEXT,
        type TEXT,
        message TEXT,
        createdAt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE training_sessions (
        id TEXT PRIMARY KEY,
        dateTime TEXT,
        athleteId TEXT,
        coachId TEXT,
        sessionType TEXT,
        trainingResultId TEXT,
        createdAt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE technical_sessions (
        id TEXT PRIMARY KEY,
        trainingSessionId TEXT,
        speed INTEGER,
        balance INTEGER,
        control INTEGER,
        roundhouseAccuracy INTEGER,
        coachNotes TEXT,
        createdAt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE strength_sessions (
        id TEXT PRIMARY KEY,
        trainingSessionId TEXT,
        pushUps INTEGER,
        sitUps INTEGER,
        squats INTEGER,
        kickPower INTEGER,
        coreStrength INTEGER,
        legStrength INTEGER,
        coachNotes TEXT,
        createdAt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE physical_conditioning_sessions (
        id TEXT PRIMARY KEY,
        trainingSessionId TEXT,
        stamina INTEGER,
        flexibility INTEGER,
        reactionSpeed INTEGER,
        coachNotes TEXT,
        createdAt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE skill_ratings (
        id TEXT PRIMARY KEY,
        striking INTEGER,
        endurance INTEGER,
        defense INTEGER,
        createdAt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE training_results (
        id TEXT PRIMARY KEY,
        overallScore REAL,
        controlScore REAL,
        speedScore REAL,
        strengthScore INTEGER,
        createdAt INTEGER
      )
    ''');
  }

  Future<int> insert(String table, Map<String, Object?> values, {ConflictAlgorithm? conflictAlgorithm}) async {
    final db = await database;
    if (conflictAlgorithm != null) {
      return await db.insert(table, values, conflictAlgorithm: conflictAlgorithm);
    }
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
