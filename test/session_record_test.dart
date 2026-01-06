import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/data/session_repository.dart';

void main() {
  test('SessionRecord serialization roundtrip', () {
    final record = SessionRecord(
      id: 'id1',
      trainingSessionId: 't1',
      athleteId: 'a1',
      sessionType: 'technical',
      payload: {'speed': 5, 'coachNotes': 'good'},
      dateTime: DateTime.parse('2025-01-01T12:00:00Z'),
    );

    final dbMap = record.toDb();
    final restored = SessionRecord.fromDb({
      'id': dbMap['id'],
      'trainingSessionId': dbMap['trainingSessionId'],
      'athleteId': dbMap['athleteId'],
      'sessionType': dbMap['sessionType'],
      'payload': dbMap['payload'],
      'dateTime': dbMap['dateTime'],
    });

    expect(restored.id, record.id);
    expect(restored.athleteId, record.athleteId);
    expect(restored.sessionType, record.sessionType);
    expect(restored.payload['speed'], 5);
  });
}
