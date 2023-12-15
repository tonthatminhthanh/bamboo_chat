import 'dart:io';

import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:bamboo_chat/objects/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../utilities/age.dart';
import '../utilities/constants.dart';

class EditUserPage extends StatefulWidget {
  EditUserPage({super.key, required this.snapshop});
  UserSnapshot snapshop;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtDOB = TextEditingController();
  TextEditingController txtName = TextEditingController();
  String? initialName;
  String? initialDOB;
  String? imageUrl;
  String? tempFileName;
  ImagePicker picker = ImagePicker();
  XFile? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa thông tin cá nhân"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ClipOval(
                  child: imageUrl == null ?
                  Image.network(widget.snapshop.myUser!.anh!,
                    errorBuilder: (context, error, stackTrace)
                    => Image.network(DEFAULT_AVATAR, width: 150, height: 150,),
                    width: 150, height: 150,) : Image.network(imageUrl!, width: 150, height: 150,),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        _recvImage(src: ImageSource.camera);
                      },
                      icon: Icon(Icons.camera)
                  ),
                  IconButton(
                      onPressed: () {
                        _recvImage(src: ImageSource.gallery);
                      },
                      icon: Icon(Icons.image)
                  ),
                ],
              ),
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
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.parse('19000101'),
                      lastDate: DateTime.now());
                      txtDOB.text = pickedDate.toString().substring(0,10);
                },
                  decoration: InputDecoration(
                      labelText: "Nhập ngày sinh của bạn", prefixIcon: Icon(Icons.date_range),
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
              ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(BUTTON_WIDTH, BUTTON_HEIGHT)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.snapshop.capNhat(MyUser(
                          email: widget.snapshop.myUser!.email,
                          displayName: txtName.text,
                          dob: txtDOB.text,
                          anh: imageUrl!,
                          isOnline: false));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Sửa đổi", style: TextStyle(color: Colors.white,fontSize: 16),)),
            ],
          ),
        ),
      ),
    );
  }

  void _recvImage({required ImageSource src}) async
  {
    if(imageUrl != null)
      {
       _deleteImage(tempFileName!);
      }
    file = await picker.pickImage(source: src);

    if(file == null)
    {
      return;
    }

    Reference fileDirRef = FirebaseStorage.instance.ref().child("/Images/Chat/");

    tempFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference fileRef = fileDirRef.child("${tempFileName}");

    await fileRef.putFile(File(file!.path), SettableMetadata(contentType: 'image/jpeg'))
        .catchError((e) => print(e.toString()))
        .then((value) async {
      imageUrl = await fileRef.getDownloadURL();
      print(imageUrl);
    });

    setState(() {
      imageUrl = imageUrl;
    });

  }

  void _deleteImage(String filename) async
  {
    final imageRef = FirebaseStorage.instance.ref().child("/Images/Avatars/$filename");
    await imageRef.delete();
    imageUrl = null;
    file = null;
  }

  @override
  void initState() {
    super.initState();
    _getNameAndDOB();
  }

  void _getNameAndDOB()
  {
    initialName = widget.snapshop.myUser!.displayName;
    initialDOB = widget.snapshop.myUser!.dob;
    txtName.text = initialName!;
    txtDOB.text = initialDOB!;
  }
}
