/// Physical conditioning session model. Designed to be concise and immutable.
class PhysicalConditioningSessions {
  final String id; // pk
  final String trainingSessionId;
  final int stamina;
  final int flexibility;
  final int reactionSpeed;
  final String? coachNotes;

  const PhysicalConditioningSessions({
    required this.id,
    required this.trainingSessionId,
    required this.stamina,
    required this.flexibility,
    required this.reactionSpeed,
    this.coachNotes,
  });
}