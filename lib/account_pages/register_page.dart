import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:bamboo_chat/utilities/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bamboo_chat/objects/user.dart';
import 'package:flutter/material.dart';
import '../utilities/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String errorMsg = "";
  TextEditingController txtDOB = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPasswd = TextEditingController();
  TextEditingController txtRePasswd = TextEditingController();
  TextEditingController txtName = TextEditingController();
  bool _hasCorrectLength = false;
  bool _hasTextCharacters = false;
  bool _hasDigits = false;
  bool _hasSpecialCharacters = false;
  bool _hidePass = true;
  bool _hideRePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Đăng ký",style: TextStyle(color: Colors.lightGreen,
                    fontSize: 32, fontWeight: FontWeight.bold)),
                Text("Hãy tham gia Bamboo Chat vào hôm nay!",style: TextStyle(color: Colors.lightGreen,
                    fontSize: 16)),
                Icon(Icons.handshake, size: 85, color: Colors.lightGreen,),
                Padding(padding: EdgeInsets.only(top: 25)),
                SizedBox(
                  width: 350,
                  child: TextFormField(controller: txtEmail,
                    validator: (value) {
                      if(value == null || value.isEmpty)
                        {
                          return "Vui lòng nhập Email!";
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
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: 350,
                  child: TextFormField(controller: txtName,
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "Vui lòng nhập tên hiển thị!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Tên hiển thị", prefixIcon: Icon(Icons.person),
                        hintText: "Nhập tên hiển thị của bạn",
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
                SizedBox(
                  width: 350,
                  child: TextFormField(controller: txtDOB,
                    readOnly: true,
                    onChanged: (value) {

                    },
                    validator: (value) {
                      if(value == null || value.isEmpty)
                        {
                          return "Vui lòng nhập ngày sinh!";
                        }
                      if(!checkAge(DateTime.parse(value!)))
                      {
                        return "Trẻ em dưới 13 tuổi không được sử dụng ứng dụng này!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Nhập ngày sinh của bạn", prefixIcon: Icon(Icons.date_range),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.edit_calendar),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                                firstDate: DateTime.parse('19000101'),
                                lastDate: DateTime.now());
                            txtDOB.text = pickedDate.toString().substring(0,10);
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Colors.lightGreen,
                                width: 2.0
                            )
                        )
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: 350,
                  child: TextFormField(controller: txtPasswd,
                    onChanged: (value) {
                      _updatePasswordStrength();
                    },
                    obscureText: _hidePass,
                    validator: (value) {
                      if(value == null || value.isEmpty || !password_regex.hasMatch(value))
                      {
                        return "Vui lòng nhập mật khẩu theo quy định!";
                      }
                      return null;
                    },
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
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                _hasCorrectLength  != true? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Mật khẩu phải có độ dài lớn hơn bằng 8!",
                        style: TextStyle(color: Colors.red,
                            fontSize: 12)
                    )
                  ],
                ) : Container(),
                _hasTextCharacters != true ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Mật khẩu phải có ít nhất 1 ký tự chữ!",
                        style: TextStyle(color: Colors.red,
                            fontSize: 12)
                    )
                  ],
                ) : Container(),
                _hasDigits != true ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Mật khẩu phải có ít nhất 1 ký tự chữ số!",
                        style: TextStyle(color: Colors.red,
                            fontSize: 12)
                    )
                  ],
                ) : Container(),
                _hasSpecialCharacters != true ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Mật khẩu phải có ít nhất 1 ký tự đặc biệt sau: @,!,%,*,#,?,&,_",
                        style: TextStyle(color: Colors.red,
                            fontSize: 12)
                    )
                  ],
                ) : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: 350,
                  child: TextFormField(controller: txtRePasswd,
                    obscureText: _hideRePass,
                    validator: (value) {
                      if(value == null || value.isEmpty || value != txtPasswd.text)
                      {
                        return "Vui lòng nhập mật khẩu giống như mật khẩu trên!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Nhập lại mật khẩu", prefixIcon: Icon(Icons.lock_reset),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            if(_hideRePass)
                            {
                              setState(() {
                                _hideRePass = false;
                              });
                            }
                            else
                            {
                              setState(() {
                                _hideRePass = true;
                              });
                            }
                          },
                        ),
                        hintText: "Nhập lại mật khẩu của bạn",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Colors.lightGreen,
                                width: 2.0
                            )
                        )
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(errorMsg, style: TextStyle(color: Colors.red),),
                ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(BUTTON_WIDTH, BUTTON_HEIGHT)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)
                    ),
                    onPressed: () {
                      if(_formKey.currentState!.validate())
                        {
                          _signUp();
                        }
                    },
                    child: Text("Đăng ký", style: TextStyle(color: Colors.white,fontSize: 16),)),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text("Tôn Thất Minh Thành thực tập tại GrandM - 2023", style: TextStyle(color: Colors.grey,fontSize: 12)))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _updatePasswordStrength();
  }

  void _updatePasswordStrength()
  {
    setState(() {
      _hasCorrectLength = (txtPasswd.text.length >= 8);
      _hasTextCharacters = RegExp(r'[a-zA-Z]').hasMatch(txtPasswd.text);
      _hasDigits = RegExp(r'[0-9]').hasMatch(txtPasswd.text);
      _hasSpecialCharacters = RegExp(r'[@!%*#?&_]').hasMatch(txtPasswd.text);
    });
  }

  bool checkAge(DateTime dob)
  {
    DateTime today = DateTime.now();
    Duration ageDiff = today.difference(dob);

    int age = ageDiff.inDays ~/ 365;

    return age >= 13;
  }

  void _signUp() async
  {
    MyUser user = MyUser(
        email: txtEmail.text,
        displayName: txtName.text, dob: txtDOB.text);
    bool success = true;
    var signedUpUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: txtEmail.text, password: txtPasswd.text)
    .catchError((e) { setState(() {
      errorMsg = e.toString();
      success = false;
    });}).then((value) => UserSnapshot.addUser(user));
    if(success)
      {
        showSnackBar(context: context, message: "Đăng ký thành công! Vui lòng đăng nhập!",
            duration: 5);
        Navigator.of(context).pop();
      }
  }

  @override
  void dispose() {
    super.dispose();
    txtEmail.dispose();
    txtPasswd.dispose();
    txtName.dispose();
    txtDOB.dispose();
    txtRePasswd.dispose();
  }
}
