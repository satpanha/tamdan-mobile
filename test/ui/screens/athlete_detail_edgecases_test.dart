import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/ui/screens/athlete_detail.dart';
import '../../helpers/fake_athlete_dao.dart';

void main() {
  setUp(() async {
    // using Fake DAO; no DB setup required
  });

  tearDown(() async {
    // nothing to clean
  });

  testWidgets('Passing null athlete shows empty message and FAB', (WidgetTester tester) async {
    final fake = FakeAthleteDao();
    await tester.pumpWidget(MaterialApp(home: AthleteDetailScreen(athlete: null, dao: fake)));

    expect(find.text('No data yet. Please click + to input data'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Add from empty detail view sets athlete', (WidgetTester tester) async {
    final fake = FakeAthleteDao();

    await tester.pumpWidget(MaterialApp(home: AthleteDetailScreen(athlete: null, dao: fake)));

    // open add
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // fill name
    await tester.enterText(find.byType(TextFormField), 'Added Athlete');

    // pick date
    await tester.tap(find.text('Select date'));
    await tester.pumpAndSettle();
    final dayFinder = find.text('1');
    if (dayFinder.evaluate().isNotEmpty) {
      await tester.tap(dayFinder);
    } else {
      await tester.tap(find.byType(TextButton).first);
    }
    await tester.pumpAndSettle();
    final okButton = find.text('OK');
    if (okButton.evaluate().isNotEmpty) {
      await tester.tap(okButton);
      await tester.pumpAndSettle();
    }

    // dropdowns
    final dropdowns = find.byType(DropdownButtonFormField<String>);
    expect(dropdowns, findsNWidgets(3));

    await tester.tap(dropdowns.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').first);
    await tester.pumpAndSettle();

    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('White').first);
    await tester.pumpAndSettle();

    await tester.tap(dropdowns.at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Active').first);
    await tester.pumpAndSettle();

    // save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // detail view should show the added athlete
    expect(find.text('Added Athlete'), findsOneWidget);

    // ensure exactly one athlete was inserted
    final all = await fake.getAll();
    expect(all.length, 1);
  });

  testWidgets('Edit validation prevents save on empty name', (WidgetTester tester) async {
    final fake = FakeAthleteDao();
    final id = await fake.insert(Athlete(
      fullName: 'ToEdit',
      skillRank: 'C',
      dateOfBirth: DateTime(2000, 1, 1),
      gender: 'Male',
      beltLevel: 'White',
      status: 'Active',
    ));

    final athlete = (await fake.getById(id))!;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (ctx) {
          return Center(
            child: ElevatedButton(
              child: const Text('OpenDetail'),
              onPressed: () async {
                await Navigator.push(ctx, MaterialPageRoute(builder: (_) => AthleteDetailScreen(athlete: athlete, dao: fake)));
              },
            ),
          );
        }),
      ),
    ));

    await tester.tap(find.text('OpenDetail'));
    await tester.pumpAndSettle();

    // tap edit
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    // clear name
    final tf = find.byType(TextFormField);
    expect(tf, findsOneWidget);
    await tester.enterText(tf, '');
    await tester.pump();

    // save changes (should be blocked)
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);

    // ensure DAO was not updated
    final still = await fake.getById(id);
    expect(still, isNotNull);
    expect(still!.fullName, 'ToEdit');
  });

  testWidgets('Delete cancel leaves athlete intact', (WidgetTester tester) async {
    final fake = FakeAthleteDao();
    final id = await fake.insert(Athlete(
      fullName: 'ToDelete',
      skillRank: 'C',
      dateOfBirth: DateTime(2000, 1, 1),
      gender: 'Male',
      beltLevel: 'White',
      status: 'Active',
    ));

    final athlete = (await fake.getById(id))!;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (ctx) {
          return Center(
            child: ElevatedButton(
              child: const Text('OpenDetail'),
              onPressed: () async {
                await Navigator.push(ctx, MaterialPageRoute(builder: (_) => AthleteDetailScreen(athlete: athlete, dao: fake)));
              },
            ),
          );
        }),
      ),
    ));

    await tester.tap(find.text('OpenDetail'));
    await tester.pumpAndSettle();

    // tap delete button - tap by label (should target the detail button)
    await tester.tap(find.text('Delete').first);
    await tester.pumpAndSettle();

    // dialog present
    expect(find.text('Delete Athlete?'), findsOneWidget);

    // cancel
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    // athlete still present
    expect(find.text('ToDelete'), findsOneWidget);
    final still = await fake.getById(id);
    expect(still, isNotNull);
  });

  testWidgets('Edit persists update to DAO', (WidgetTester tester) async {
    final fake = FakeAthleteDao();
    final id = await fake.insert(Athlete(
      fullName: 'PersistMe',
      skillRank: 'C',
      dateOfBirth: DateTime(2000, 1, 1),
      gender: 'Male',
      beltLevel: 'White',
      status: 'Active',
    ));

    final athlete = (await fake.getById(id))!;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (ctx) {
          return Center(
            child: ElevatedButton(
              child: const Text('OpenDetail'),
              onPressed: () async {
                await Navigator.push(ctx, MaterialPageRoute(builder: (_) => AthleteDetailScreen(athlete: athlete, dao: fake)));
              },
            ),
          );
        }),
      ),
    ));

    await tester.tap(find.text('OpenDetail'));
    await tester.pumpAndSettle();

    // tap edit
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Persisted');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    // verify detail shows updated name
    expect(find.text('Persisted'), findsOneWidget);

    // verify DAO has updated value
    final updated = await fake.getById(id);
    expect(updated, isNotNull);
    expect(updated!.fullName, 'Persisted');
  });
}
