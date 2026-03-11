import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // Run flutterfire configure to generate this
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Requires firebase_options.dart)
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // } catch (e) {
  //   debugPrint('Firebase initialization failed: $e');
  // }

  runApp(
    const ProviderScope(
      child: CrewConnctApp(),
    ),
  );
}
