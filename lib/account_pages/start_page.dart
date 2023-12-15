import 'package:bamboo_chat/account_pages/login_page.dart';
import 'package:bamboo_chat/account_pages/register_page.dart';
import 'package:bamboo_chat/utilities/preferences.dart';
import 'package:flutter/material.dart';
import '../utilities/custom_button.dart';
import '../firebase/firebase_connection.dart';
import '../firebase_options.dart';
import '../utilities/theme_provider.dart';
import '../main_pages/main_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EstablishFirebaseConnection extends StatefulWidget {
  const EstablishFirebaseConnection({super.key});

  @override
  State<EstablishFirebaseConnection> createState() => _EstablishFirebaseConnectionState();
}

class _EstablishFirebaseConnectionState extends State<EstablishFirebaseConnection> {
  @override
  Widget build(BuildContext context) {
    return FirebaseConnectionPage(builder: (context) => MaterialApp(
      theme: Preferences.getPrefs!.getBool("isDark")! ? ThemeData.dark() : ThemeData.light(),
      home: AccountPage(),));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => autoLogIn());
  }

  void autoLogIn()
  {
    if(FirebaseAuth.instance.currentUser != null)
    {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
              create: (context) => ThemeProvider(Preferences.getBool() ? ThemeMode.dark : ThemeMode.light),
              child: MainPage())));
    }
  }
}


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Xin chào!", style: TextStyle(color: Colors.lightGreen,fontSize: 32, fontWeight: FontWeight.bold),),
            Text("Hãy bắt đầu bằng cách đăng nhập hoặc đăng ký", style: TextStyle(color: Colors.lightGreen,fontSize: 16)),
            Padding(padding: EdgeInsets.only(top: 80)),
            Image.asset("media/people_talking.png", width: 300,),
            Padding(padding: EdgeInsets.only(top: 120)),
            createElevatedRouteButton(
                context: context, color: Colors.lightGreen,
                text: "Đăng nhập",
                width: 150,
                builder: (context) => LoginPage(),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            createElevatedRouteButton(context: context,
                color: Colors.lightGreen, text: "Đăng ký",
                width: 150,
                builder: (context) => RegisterPage(),
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text("Tôn Thất Minh Thành thực tập tại GrandM - 2023", style: TextStyle(color: Colors.grey,fontSize: 12)))
            ),
          ],
        ),
      ),
    );
  }
}