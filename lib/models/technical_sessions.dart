/// Technical session model (presentation-friendly record).
/// Note: keep models simple and immutable to make them easy to pass between UI and services.
class TechnicalSessions {
  final String id; // pk
  final String trainingSessionId;
  final int speed;
  final int balance;
  final int control;
  final int roundhouseAccuracy;
  final String? coachNotes;

  const TechnicalSessions({
    required this.id,
    required this.trainingSessionId,
    required this.speed,
    required this.balance,
    required this.control,
    required this.roundhouseAccuracy,
    this.coachNotes,
  });
}