import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase/firebase_users.dart';
import '../utilities/constants.dart';

class SendRequest extends StatefulWidget {
  SendRequest({super.key});
  String userEmail = FirebaseAuth.instance.currentUser!.email!;
  @override
  State<SendRequest> createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  final _formKey = GlobalKey<FormState>();
  String errMsg = "";
  bool _invalid_email = true;
  bool _hidePass = true;
  String displayName = "Guest";
  String imageUrl = DEFAULT_AVATAR;
  TextEditingController txtEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thêm bạn")),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ClipOval(child: Image.network(imageUrl, width: 100, height: 100,)),
              Padding(padding: EdgeInsets.only(top: 10)),
              displayName == "Guest" ? Container()
                  : Text(displayName,style: TextStyle(color: Colors.lightGreen,
                  fontSize: 16)),
              SizedBox(
                width: 350,
                child: Focus(
                  onFocusChange: (hasFocus) async {
                    if(!hasFocus)
                    {
                      var snapshot = await UserSnapshot.userFromFirebase(txtEmail.text);
                      if(snapshot != null)
                      {
                          if(widget.userEmail == txtEmail.text)
                            {
                              setState(() {
                                _invalid_email = true;
                              });
                            }
                          else
                            {
                              bool isMyFriend = await UserSnapshot.isFriend(widget.userEmail, txtEmail.text);
                              if(isMyFriend)
                                {
                                  setState(() {
                                    _invalid_email = true;
                                  });
                                }
                              else
                                {
                                  setState(() {
                                    _invalid_email = false;
                                  });
                                }
                            }
                          if(snapshot.myUser!.anh != "")
                          {
                            setState(() {
                              imageUrl = snapshot.myUser!.anh;
                            });
                          }
                          else
                          {
                            setState(() {
                              imageUrl = DEFAULT_AVATAR;
                            });
                          }
                          setState(() {
                            displayName = snapshot.myUser!.displayName;
                          });
                      }
                      else
                      {
                        setState(() {
                          _invalid_email = true;
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
                        hintText: "Nhập email",
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
              ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(BUTTON_WIDTH, BUTTON_HEIGHT)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)
                  ),
                  onPressed: () {
                    if(_formKey.currentState!.validate())
                      {
                        UserSnapshot.addRequest(widget.userEmail, txtEmail.text);
                        Navigator.of(context).pop();
                      }
                  },
                  child: Text("Thêm bạn", style: TextStyle(color: Colors.white,fontSize: 16),)),
              Text(errMsg,style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
