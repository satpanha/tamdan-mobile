import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/data/training_results_repository.dart';
import 'package:tamdan/models/training_results.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('TrainingResultsRepository: save, get, delete', () async {
    final id = 'tr_${DateTime.now().millisecondsSinceEpoch}';

    final r = TrainingResults(
      id: id,
      overallScore: 8.5,
      controlScore: 7.0,
      speedScore: 6.5,
      strengthScore: 80,
    );

    await TrainingResultsRepository.instance.save(r);

    final fetched = await TrainingResultsRepository.instance.getById(id);
    expect(fetched, isNotNull);
    expect((fetched!.overallScore - r.overallScore).abs() < 0.0001, isTrue);

    final deleted = await TrainingResultsRepository.instance.deleteById(id);
    expect(deleted, greaterThanOrEqualTo(0));
  });
}
