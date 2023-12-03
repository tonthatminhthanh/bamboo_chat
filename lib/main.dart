import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_pages/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(BambooChatApp());
}

class BambooChatApp extends StatefulWidget {
  BambooChatApp({super.key});

  @override
  State<BambooChatApp> createState() => _BambooChatAppState();
}

class _BambooChatAppState extends State<BambooChatApp> {
  SharedPreferences? _preferences;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _preferences!.getBool("isDark")! ? ThemeData.dark() : ThemeData.light(),
      home: EstablishFirebaseConnection()
    );
  }


  @override
  void initState() {
    super.initState();
    _grabPrefs();
  }

  void _grabPrefs() async
  {
    _preferences = await SharedPreferences.getInstance();
    if(_preferences?.getBool("isDark") == null)
    {
      _preferences?.setBool("isDark", true);
    }
  }
}
