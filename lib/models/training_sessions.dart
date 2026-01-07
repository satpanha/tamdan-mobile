class TrainingSessions {
  final String id; // pk
  final DateTime dateTime;
  final String athleteId;
  final String coachId;
  final String sessionType;
  final String? trainingResultId;

  TrainingSessions({
    required this.id,
    required this.dateTime,
    required this.athleteId,
    required this.coachId,
    required this.sessionType,
    this.trainingResultId,
  });
}