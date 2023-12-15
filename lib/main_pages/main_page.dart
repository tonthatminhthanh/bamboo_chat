import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:bamboo_chat/main_pages/contacts_page.dart';
import 'package:bamboo_chat/main_pages/profile_page.dart';
import 'package:bamboo_chat/main_pages/users_page.dart';
import 'package:bamboo_chat/objects/user.dart';
import 'package:bamboo_chat/utilities/preferences.dart';
import 'package:bamboo_chat/utilities/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  String userEmail = FirebaseAuth.instance.currentUser!.email!;
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _currSelection = 0;
  List<String> labels = ["Trò chuyện","Danh bạ","Tài khoản"];
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        List<Widget> _listBody = <Widget>[UsersPage(), ContactPage(), ProfilePage(mode: value,)];
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: value.mode,
          home: Scaffold(
            body: _listBody[_currSelection],
            appBar: AppBar(
              title: Text(labels[_currSelection]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: _createBottomNavigationButtons(),
              currentIndex: _currSelection,
              onTap: (value) {
                setState(() {
                  _currSelection = value;
                });
              },
              selectedItemColor: Colors.lightGreen,
            ),
          ),
        );
      }
    );
  }

  List<BottomNavigationBarItem> _createBottomNavigationButtons()
  {
    List<IconData> icons = [Icons.chat,Icons.contacts,Icons.person];
    List<BottomNavigationBarItem> list = [];
    for(int i = 0;i < 3;i++)
      {
        list.add(
            BottomNavigationBarItem(icon: Icon(icons[i]), label: labels[i])
        );
      }
    return list;
  }
}
