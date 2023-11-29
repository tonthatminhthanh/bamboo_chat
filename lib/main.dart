import 'package:flutter/material.dart';
import 'account_pages/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const BambooChatApp());
}

class BambooChatApp extends StatelessWidget {
  const BambooChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: EstablishFirebaseConnection()
    );
  }
}

