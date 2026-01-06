import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/models/user.dart';

final List<Athlete> mockAthletes = [
  Athlete(
    id: "1",
    name: "John Doe",
    dateOfBirth: DateTime(2005, 3, 15),
    gender: "Male",
    beltLevel: "White",
    status: "Active",
  ),
  Athlete(
    id: "2",
    name: "Sarah Smith",
    dateOfBirth: DateTime(2004, 7, 22),
    gender: "Female",
    beltLevel: "Yellow",
    status: "Active",
  ),
  Athlete(
    id: "3",
    name: "Carlos Diaz",
    dateOfBirth: DateTime(2003, 11, 2),
    gender: "Male",
    beltLevel: "Orange",
    status: "Inactive",
  ),
  Athlete(
    id: "4",
    name: "Aiko Tanaka",
    dateOfBirth: DateTime(2006, 1, 9),
    gender: "Female",
    beltLevel: "Green",
    status: "Active",
  ),
  Athlete(
    id: "5",
    name: "Liam O'Connor",
    dateOfBirth: DateTime(2005, 5, 30),
    gender: "Male",
    beltLevel: "Blue",
    status: "Inactive",
  ),
];

final mockUser = User(
  name: 'Sat Panha',
  role: 'Coach',
  dateOfBirth: DateTime(2002, 12, 12),
  gender: 'Male',
  experience: '3 Years',
  focusOn: 'Strength',
);