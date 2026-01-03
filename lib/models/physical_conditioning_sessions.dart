class PhysicalConditioningSessions {
  final String id; // pk
  final String trainingSessionId;
  final int stamina;
  final int flexibility;
  final int reactionSpeed;

  PhysicalConditioningSessions({
    required this.id,
    required this.trainingSessionId,
    required this.stamina,
    required this.flexibility,
    required this.reactionSpeed,
  });
}