import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:passlock/register.dart';
import 'firebase_options.dart';

Future<void> main() async {
  runApp(const MainApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RegisterPage(),
        ),
      ),
    );
  }
}
