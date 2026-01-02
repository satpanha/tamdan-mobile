class TechnicalSessions {
  final String id; // pk
  final String trainingSessionId;
  final int speed;
  final int balance;
  final int control;
  final int roundhouseAccuracy;

  TechnicalSessions({
    required this.id,
    required this.trainingSessionId,
    required this.speed,
    required this.balance,
    required this.control,
    required this.roundhouseAccuracy,
  });
}