import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseConnectionPage extends StatefulWidget {
  final Widget Function(BuildContext context)? builder;

  FirebaseConnectionPage(
      {Key? key,
        required this.builder
      });
  @override
  State<FirebaseConnectionPage> createState() => _FirebaseConnectionPageState();
}

class _FirebaseConnectionPageState extends State<FirebaseConnectionPage> {
  bool isConnected = false;
  bool hasError = false;
  String extraErrMsg = "";
  @override
  Widget build(BuildContext context) {
    if(!isConnected)
      {
        return Scaffold(
            body: hasError ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.warning,color: Colors.red,),
                  Text("Không thể kết nối với máy chủ!", style: TextStyle(color: Colors.red),),
                  Text("Lỗi: $extraErrMsg"),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hasError = false;
                          _establishConnection();
                        });
                      },
                      child: Text("Thử lại")
                  )
                ],
              ),
            ) : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue,),
                  Text("Kết nối với máy chủ...", style: TextStyle(color: Colors.blue))
                ],
              ),
            )
        );
      }
    else
      {
        return widget.builder!(context);
      }
  }

  @override
  void initState() {
    super.initState();
    _establishConnection();
  }

  void _establishConnection()
  {
    Firebase.initializeApp().then(
            (value) {
              setState(() {
                isConnected = true;
              });
            },
    ).catchError(
        (error) {
          setState(() {
            hasError = true;
            extraErrMsg = error.toString();
          });
        }
    );
  }
}


