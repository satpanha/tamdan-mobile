class User {
  final String name;
  final String role;
  final DateTime dateOfBirth;
  final String gender;
  final String experience;
  final String focusOn;

  const User({
    required this.name,
    required this.role,
    required this.dateOfBirth,
    required this.gender,
    required this.experience,
    required this.focusOn,
  });

  String get formattedDob =>
      '${dateOfBirth.day.toString().padLeft(2, '0')}/${dateOfBirth.month.toString().padLeft(2, '0')}/${dateOfBirth.year}';

  @override
  String toString() => '$name - $role';
}