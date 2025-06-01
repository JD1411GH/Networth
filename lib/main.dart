import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:networth/accounts.dart';
import 'package:networth/bank_accounts.dart';
import 'package:networth/common/theme.dart';
import 'package:networth/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:networth/widgets/toaster.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (!kIsWeb) {
      Toaster().error("Error initializing Firebase: $e");
    }
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeCreator themeCreator = ThemeCreator(primaryColor: Colors.green);
    ThemeData theme = themeCreator.create();

    Widget home = Home(title: 'Networth Tracker');
    Widget test = BankAccounts(title: "Testing");

    return MaterialApp(home: test, theme: theme);
  }
}
