import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:tamdan/data/db_provider.dart';

class SessionRecord {
  final String id;
  final String trainingSessionId;
  final String athleteId;
  final String sessionType; // e.g., technical/strength/physical
  final Map<String, dynamic> payload; // full details as json
  final DateTime dateTime;

  SessionRecord({
    required this.id,
    required this.trainingSessionId,
    required this.athleteId,
    required this.sessionType,
    required this.payload,
    required this.dateTime,
  });

  Map<String, Object?> toDb() => {
        'id': id,
        'trainingSessionId': trainingSessionId,
        'athleteId': athleteId,
        'sessionType': sessionType,
        'payload': jsonEncode(payload),
        'dateTime': dateTime.toIso8601String(),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

  static SessionRecord fromDb(Map<String, Object?> row) {
    return SessionRecord(
      id: row['id'] as String,
      trainingSessionId: row['trainingSessionId'] as String? ?? '',
      athleteId: row['athleteId'] as String,
      sessionType: row['sessionType'] as String,
      payload: jsonDecode(row['payload'] as String) as Map<String, dynamic>,
      dateTime: DateTime.parse(row['dateTime'] as String),
    );
  }
}


abstract class SessionRepositoryInterface {
  Future<void> save(SessionRecord r);

  Future<List<SessionRecord>> getByAthlete(String athleteId);

  Future<int> deleteById(String id);

  /// If true, sessions are stored in-memory and not persisted to disk.
  bool get usingInMemory;
}

class SessionRepository implements SessionRepositoryInterface {
  SessionRepository._();
  static SessionRepositoryInterface instance = SessionRepository._();

  // In-memory fallback store used when DB operations are unavailable.
  final List<SessionRecord> _inMemoryStore = [];
  bool _useInMemory = false;

  @override
  bool get usingInMemory => _useInMemory;

  /// Save a session. Tries the DB first; on any error it falls back to in-memory storage
  /// so the app continues to work without a persistent database.
  @override
  Future<void> save(SessionRecord r) async {
    if (_useInMemory) {
      _inMemoryStore.add(r);
      return;
    }

    try {
      await DBProvider.instance.insert('sessions', r.toDb());
    } catch (e, st) {
      debugPrint('DB insert failed, switching to in-memory store: $e\n$st');
      _useInMemory = true;
      _inMemoryStore.add(r);
    }
  }

  @override
  Future<List<SessionRecord>> getByAthlete(String athleteId) async {
    if (_useInMemory) return _inMemoryStore.where((r) => r.athleteId == athleteId).toList();
    try {
      final rows = await DBProvider.instance.query('sessions', where: 'athleteId = ?', whereArgs: [athleteId]);
      return rows.map((r) => SessionRecord.fromDb(r)).toList();
    } catch (e, st) {
      debugPrint('DB query failed, switching to in-memory store: $e\n$st');
      _useInMemory = true;
      return _inMemoryStore.where((r) => r.athleteId == athleteId).toList();
    }
  }

  @override
  Future<int> deleteById(String id) async {
    if (_useInMemory) {
      _inMemoryStore.removeWhere((r) => r.id == id);
      return 1;
    }
    try {
      return await DBProvider.instance.delete('sessions', where: 'id = ?', whereArgs: [id]);
    } catch (e, st) {
      debugPrint('DB delete failed, switching to in-memory store: $e\n$st');
      _useInMemory = true;
      _inMemoryStore.removeWhere((r) => r.id == id);
      return 1;
    }
  }
}

