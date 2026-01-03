class SkillRatings {
  final String id; // pk
  final int striking;
  final int endurance;
  final int defense;

  SkillRatings({
    required this.id,
    required this.striking,
    required this.endurance,
    required this.defense,
  });
}