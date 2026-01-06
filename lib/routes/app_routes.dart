import 'package:flutter/material.dart';
import 'package:tamdan/ui/screens/athlete_list.dart';
import 'package:tamdan/ui/screens/tracking.dart';

import 'package:tamdan/ui/screens/technical_session.dart';
import 'package:tamdan/ui/screens/strength_session.dart';
import 'package:tamdan/ui/screens/physical_conditioning_session.dart';
import 'package:tamdan/ui/screens/training_results.dart';
import 'package:tamdan/ui/screens/home.dart';

/// Centralized named routes for the app.
/// Use only named routes. No inline navigation logic inside widgets.
class AppRoutes {
  static const String home = '/';
  static const String athleteList = '/athletes';
  static const String tracking = '/tracking';
  static const String technicalSession = '/session/technical';
  static const String strengthSession = '/session/strength';
  static const String physicalConditioning = '/session/physical';
  static const String trainingResults = '/results';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        athleteList: (context) => const AthleteListScreen(),
        tracking: (context) => const TrackingScreen(),
        technicalSession: (context) => const TechnicalSessionScreen(),
        strengthSession: (context) => const StrengthSessionScreen(),
        physicalConditioning: (context) => const PhysicalConditioningSessionScreen(),
        trainingResults: (context) => const TrainingResultsScreen(),
      };
}
