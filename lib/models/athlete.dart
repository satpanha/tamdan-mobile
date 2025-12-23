class Athlete {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String gender;
  final String beltLevel;
  final String status;

  const Athlete({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.beltLevel,
    required this.status,
  });

  @override
  String toString() => 'Athlete: $name ($beltLevel)';
}
