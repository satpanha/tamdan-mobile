class TrainingResults {
  final String id; // pk
  final double overallScore;
  final double controlScore;
  final double speedScore;
  final int strengthScore;

  TrainingResults({
    required this.id,
    required this.overallScore,
    required this.controlScore,
    required this.speedScore,
    required this.strengthScore,
  });
}