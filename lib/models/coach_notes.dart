class CoachNotes {
  final String id; // pk
  final String trainingSessionId;
  final String type;
  final String message;
  final DateTime createdAt;

  CoachNotes({
    required this.id,
    required this.trainingSessionId,
    required this.type,
    required this.message,
    required this.createdAt,
  });
}