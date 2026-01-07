import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tamdan/routes/app_routes.dart';
import 'package:tamdan/ui/screens/technical_session.dart';
import 'package:tamdan/ui/widgets/athlete_card.dart';
import 'package:tamdan/data/athlete_repository.dart';
import 'package:tamdan/models/athlete.dart';

void main() {
  testWidgets('Tracking flow: select session type, pick athletes and start', (WidgetTester tester) async {
    // initialize sqflite ffi for repository-backed data
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // ensure at least one athlete exists via the repository
    final athId = 'repo_${DateTime.now().millisecondsSinceEpoch}';
    final athlete = Athlete(id: athId, name: 'Repo Athlete', dateOfBirth: DateTime(2005, 1, 1), gender: 'M', beltLevel: 'White', status: 'active');
    await AthleteRepository.instance.save(athlete);

    await tester.pumpWidget(MaterialApp(initialRoute: AppRoutes.tracking, routes: AppRoutes.routes));

    // select Technical via ChoiceChip
    await tester.tap(find.text('Technical').last);
    await tester.pumpAndSettle();

    // select first athlete (mock data present)
    expect(find.text('Select Athletes'), findsOneWidget);
    final athleteTile = find.byType(AthleteCard).first;
    await tester.ensureVisible(athleteTile);
    await tester.pumpAndSettle();

    // capture the athlete name shown in the card
    final nameTextFinder = find.descendant(of: athleteTile, matching: find.byType(Text)).first;
    final athleteName = (tester.widget<Text>(nameTextFinder)).data!;

    await tester.tap(athleteTile);
    await tester.pumpAndSettle();

    // Start should be enabled now
    final startButton = find.widgetWithText(ElevatedButton, 'Start');
    expect(startButton, findsOneWidget);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // Should navigate to technical session and display the selected athlete name
    expect(find.byType(TechnicalSessionScreen), findsOneWidget);
    expect(find.text(athleteName), findsWidgets);
  });
}
