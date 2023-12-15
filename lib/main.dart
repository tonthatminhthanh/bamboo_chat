import 'package:bamboo_chat/firebase/firebase_connection.dart';
import 'package:bamboo_chat/utilities/preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_pages/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

SharedPreferences? _preferences;

Future<bool> _grabPrefs() async
{
  _preferences = await SharedPreferences.getInstance();
  Preferences.setPrefs(_preferences!);
  if(_preferences!.getBool("isDark") == null)
  {
    _preferences!.setBool("isDark", true);
  }
  return true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const BambooChatApp());
}

class BambooChatApp extends StatefulWidget {
  const BambooChatApp({super.key});

  @override
  State<BambooChatApp> createState() => _BambooChatAppState();
}

class _BambooChatAppState extends State<BambooChatApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: FutureBuilder(
          future: _grabPrefs(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              {
                if(snapshot.hasError)
                  {
                    return Text("Cannot find shared preferences!");
                  }
                else
                  {
                    return CircularProgressIndicator(color: Colors.lightGreen,);
                  }
              }
            else
              {
                return FirebaseConnectionPage(builder: (context) => EstablishFirebaseConnection(),);
              }
          },
        ),
      )
    );
  }


  @override
  void initState() {
    super.initState();
    _grabPrefs().then((value) {
    });
  }
}
