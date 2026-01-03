import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// using FakeAthleteDao in tests to avoid native sqlite dependency

import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/ui/screens/add_athlete.dart';
import '../../helpers/fake_athlete_dao.dart';

void main() {
  setUp(() async {
    // using Fake DAO; no DB setup required
  });

  tearDown(() async {
    // no DB to clean
  });

  testWidgets('Save without date shows SnackBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const AddAthleteScreen()));

    // try to save without filling anything
    await tester.tap(find.text('Save'));
    await tester.pump();

    // SnackBar should show date error text
    expect(find.text('Date of birth is required'), findsOneWidget);
  });

  testWidgets('can add athlete and returns created on pop', (WidgetTester tester) async {
    Athlete? created;

    final fake = FakeAthleteDao();

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (ctx) {
        return Center(
          child: ElevatedButton(
            child: const Text('OpenAdd'),
            onPressed: () async {
              final res = await Navigator.push(ctx, MaterialPageRoute(builder: (_) => AddAthleteScreen(dao: fake)));
              if (res is Athlete) created = res;
            },
          ),
        );
      }),
    ));

    await tester.tap(find.text('OpenAdd'));
    await tester.pumpAndSettle();

    // Fill name
    await tester.enterText(find.byType(TextFormField), 'New Athlete');

    // Tap date field to open date picker and select a day
    await tester.tap(find.text('Select date'));
    await tester.pumpAndSettle();

    // There is a selectable day; pick the first enabled day by finding a day text
    final dayFinder = find.text('1');
    if (dayFinder.evaluate().isNotEmpty) {
      await tester.tap(dayFinder);
    } else {
      final btn = find.byType(TextButton).first;
      await tester.tap(btn);
    }
    await tester.pumpAndSettle();

    // Press OK on date picker (Material uses 'OK')
    final okButton = find.text('OK');
    if (okButton.evaluate().isNotEmpty) {
      await tester.tap(okButton);
      await tester.pumpAndSettle();
    }

    // pick dropdowns - pick first available option for gender, belt and status
    final dropdowns = find.byType(DropdownButtonFormField<String>);
    expect(dropdowns, findsNWidgets(3));

    // gender
    await tester.tap(dropdowns.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male').first);
    await tester.pumpAndSettle();

    // belt
    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('White').first);
    await tester.pumpAndSettle();

    // status
    await tester.tap(dropdowns.at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Active').first);
    await tester.pumpAndSettle();

    // Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(created, isNotNull);
    expect(created!.fullName, 'New Athlete');
  });
}
