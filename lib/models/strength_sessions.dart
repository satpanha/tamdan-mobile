
class StrengthSessions {
  final String id; // pk
  final String trainingSessionId;
  final int pushUps;
  final int sitUps;
  final int squats;
  final int kickPower;
  final int coreStrength;
  final int legStrength;
  final String? coachNotes;

  const StrengthSessions({
    required this.id,
    required this.trainingSessionId,
    required this.pushUps,
    required this.sitUps,
    required this.squats,
    required this.kickPower,
    required this.coreStrength,
    required this.legStrength,
    this.coachNotes,
  });
}