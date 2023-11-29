import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pop();
          },
          child: Text("Log out"),
        ),
      ),
    );
  }
}
