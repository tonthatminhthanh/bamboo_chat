import 'package:bamboo_chat/misc_pages//test.dart';
import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:bamboo_chat/objects/quotes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  QuoteGenerator quoteGenerator = QuoteGenerator();
  String errMsg = "";
  bool _invalid_email = true;
  bool _hidePass = true;
  String displayName = "Guest";
  String imageUrl = DEFAULT_AVATAR;
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPasswd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Đăng nhập",style: TextStyle(color: Colors.lightGreen,
                    fontSize: 32, fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(quoteGenerator.getQuoteByTime(), style: TextStyle(color: Colors.lightGreen,
                    fontSize: 16)),
                Padding(padding: EdgeInsets.only(top: 10)),
                ClipOval(child: Image.network(imageUrl, width: 100, height: 100,)),
                Padding(padding: EdgeInsets.only(top: 10)),
                displayName == "Guest" ? Container()
                    : Text(displayName,style: TextStyle(color: Colors.lightGreen,
                    fontSize: 16)),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: 350,
                  child: Focus(
                    onFocusChange: (hasFocus) async {
                      if(!hasFocus)
                        {
                          var snapshot = await UserSnapshot.userFromFirebase(txtEmail.text);
                          if(snapshot != null)
                            {
                              setState(() {
                                _invalid_email = false;
                                if(snapshot.myUser!.anh != "")
                                  {
                                    imageUrl = snapshot.myUser!.anh;
                                  }
                                else
                                  {
                                    imageUrl = DEFAULT_AVATAR;
                                  }
                                displayName = snapshot.myUser!.displayName;
                              });
                            }
                          else
                            {
                              setState(() {
                                _invalid_email = false;
                                imageUrl = DEFAULT_AVATAR;
                                displayName = "Guest";
                              });
                            }
                        }
                    },
                    child: TextFormField(controller: txtEmail,
                      validator: (value) {
                        if(_invalid_email)
                        {
                          return "Email không hợp lệ!";
                        }
                        if(value == "" || value == null)
                          {
                            return "Không được để trống trường email!";
                          }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email", prefixIcon: Icon(Icons.email),
                        hintText: "Nhập email của bạn",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.lightGreen,
                            width: 2.0
                          )
                        )
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: 350,
                  child: TextFormField(controller: txtPasswd,
                    validator: (value) {
                      if(value == "" || value == null)
                      {
                        return "Không được để trống trường mật khẩu!";
                      }
                      return null;
                    },
                    obscureText: _hidePass,
                    decoration: InputDecoration(
                        labelText: "Mật khẩu", prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            if(_hidePass)
                              {
                                setState(() {
                                  _hidePass = false;
                                });
                              }
                            else
                              {
                                setState(() {
                                  _hidePass = true;
                                });
                              }
                          },
                        ),
                        hintText: "Nhập mật khẩu của bạn",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Colors.lightGreen,
                                width: 2.0
                            )
                        )
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(errMsg,style: TextStyle(color: Colors.red)),
                ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(BUTTON_WIDTH, BUTTON_HEIGHT)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)
                    ),
                    onPressed: () {
                      if(_formKey.currentState!.validate())
                        {
                          setState(() {
                            errMsg = "";
                          });
                          _logIn();
                        }
                    },
                    child: Text("Đăng nhập", style: TextStyle(color: Colors.white,fontSize: 16),)),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text("Tôn Thất Minh Thành thực tập tại GrandM - 2023", style: TextStyle(color: Colors.grey,fontSize: 12)))
                ),
              ],
            ),
          ),
      )
    );
  }

  void _logIn() async
  {
    bool _loggingIn = true;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: txtEmail.text,
        password: txtPasswd.text).catchError((e) {
          setState(() {
            errMsg = e.toString();
          });
          _loggingIn = false;
    });
    if(_loggingIn)
      {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TestPage(),)
        );
      }
  }

  @override
  void dispose() {
    super.dispose();
    txtEmail.dispose();
    txtPasswd.dispose();
  }
}
