import 'package:flutter/material.dart';
import 'package:tamdan/theme/app_theme.dart';
import 'package:tamdan/routes/app_routes.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athlete Tracker',
      theme: getAppTheme(),
      initialRoute: '/',
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}


