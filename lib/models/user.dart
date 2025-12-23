class User {
  final String name;
  final String email;
  final String role;
  final DateTime createdDate;

  const User({
    required this.name,
    required this.email,
    required this.role,
    required this.createdDate,
  });

  @override
  String toString() => '$name - $role';
}
