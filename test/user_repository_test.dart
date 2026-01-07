import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/user_repository.dart';
import 'package:tamdan/models/user.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('UserRepository: save, get, delete', () async {
    final name = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
    final u = User(
      name: name,
      role: 'coach',
      dateOfBirth: DateTime(1990, 5, 5),
      gender: 'F',
      experience: '5y',
      focusOn: 'technique',
    );

    await UserRepository.instance.save(u);

    final fetched = await UserRepository.instance.getByName(name);
    expect(fetched, isNotNull);
    expect(fetched!.name, equals(u.name));
    expect(fetched.role, equals(u.role));

    final deleted = await UserRepository.instance.deleteByName(name);
    expect(deleted, greaterThanOrEqualTo(0));

    final afterDelete = await UserRepository.instance.getByName(name);
    expect(afterDelete, isNull);
  });
}
