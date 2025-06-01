import 'package:flutter/material.dart';
import 'package:networth/common/theme.dart';
import 'package:networth/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeCreator themeCreator = ThemeCreator(primaryColor: Colors.green);
    ThemeData theme = themeCreator.create();

    return MaterialApp(home: Home(title: 'Net Worth Tracker'), theme: theme);
  }
}
