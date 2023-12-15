import 'dart:convert';

import 'package:bamboo_chat/firebase/firebase_chat.dart';
import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:bamboo_chat/objects/api_key.dart';
import 'package:bamboo_chat/objects/message.dart';
import 'package:bamboo_chat/objects/user.dart';
import 'package:bamboo_chat/utilities/message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utilities/image.dart';
import '../utilities/scroll.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  String friendEmail;
  String userEmail = FirebaseAuth.instance.currentUser!.email!;
  ChatPage({super.key, required this.friendEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _txtChat = TextEditingController();
  ScrollController _controller = ScrollController();
  final _formKey = GlobalKey<FormState>();
  OverlayEntry? entry;
  ImagePicker picker = ImagePicker();
  XFile? file;
  String? imageUrl;
  String? tempFileName;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: UserSnapshot.userStreamFromFirebase(widget.friendEmail),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            {
               if(snapshot.hasError)
                 {
                   return Scaffold(
                     body: Center(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.error, color: Colors.red),
                           Text(
                             "Xin lỗi, chương trình đang gặp lỗi!",
                             style: TextStyle(color: Colors.red, fontSize: 12),
                           ),
                         ],
                       ),
                     ),
                   );
                 }
               else
                 {
                   return Scaffold(
                     body: Center(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           CircularProgressIndicator(color: Colors.lightGreen,),
                         ],
                       ),
                     ),
                   );
                 }
            }
          else
            {
              MyUser friend = snapshot.data!.myUser!;
              return Scaffold(
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(bottom: 55.0),
                    child: FloatingActionButton.small(
                      onPressed: () {
                        scrollDown(_controller);
                      },
                      backgroundColor: Colors.lightGreen.withOpacity(0.5),
                      foregroundColor: Colors.white,
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                  appBar: AppBar(
                    title: Row(
                      children: [
                        Stack(
                          children: [
                            ClipOval(
                                child: Image.network(
                                  getAvatar(friend.anh), width: 50.0, height: 50.0,)),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: Container(
                                  padding: EdgeInsets.all(7.5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90.0),
                                      color: Colors.green,
                                      border: Border.all(
                                          width: 2,
                                          color: Colors.white
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(right: 15)),
                        Text(friend.displayName, style: TextStyle(fontSize: 24))
                      ],
                    ),
                  ),
                  body: SafeArea(
                    child: Column(
                        children: <Widget>[
                          Expanded(child: ChatMessage(friendEmail: widget.friendEmail,scrollController: _controller,)),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Form(
                            key: _formKey,
                            child: Row(
                              children: [
                                snapshot.data!.myUser!.email == "bing-chat" ? Container() : IconButton(
                                    onPressed: () async {
                                      _recvImage(src: ImageSource.camera);
                                    },
                                    icon: Icon(Icons.camera)
                                ),
                                snapshot.data!.myUser!.email == "bing-chat" ? Container() : IconButton(
                                    onPressed: () async {
                                      _recvImage(src: ImageSource.gallery);
                                    },
                                    icon: Icon(Icons.image)
                                ),
                                Expanded(
                                  child: TextFormField(controller: _txtChat,
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) && (imageUrl == null || imageUrl!.isEmpty)) {
                                        return "Vui lòng nhập gì đó!";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Nói chào đi!",
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                                color: Colors.lightGreen,
                                                width: 2.0
                                            )
                                        )
                                    ),
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      String msg = _txtChat.text;
                                      if(_formKey.currentState!.validate())
                                        {
                                          Map<String, String>? data;
                                          if(imageUrl != null)
                                            {
                                              data = {'message': msg, 'image': imageUrl!};
                                            }
                                          else
                                            {
                                              data = {'message': msg, };
                                            }
                                          _deleteOverlay();
                                          MessageSnapshot.sendMessage(message: Message(
                                              senderId: widget.userEmail,
                                              receiverId: widget.friendEmail,
                                              content: jsonEncode(data),
                                              sentTime: DateTime.now().toString()));
                                          if(snapshot.data!.myUser!.email == "bing-chat")
                                            {
                                              _fetchResponseFromGPT(_txtChat.text).then((value) {
                                                Map<String, String> data = {'message': value, };
                                                MessageSnapshot.sendMessage(message: Message(
                                                    senderId: "bing-chat",
                                                    receiverId: widget.userEmail,
                                                    content: jsonEncode(data),
                                                    sentTime: DateTime.now().toString()));
                                              });
                                            }
                                          _txtChat.clear();
                                          imageUrl = null;
                                        }
                                    },
                                    icon: Icon(Icons.send)
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10))
                        ],
                      ),
                  ),
                  );
            }
        },);
  }
  void showImageOverlay()
  {
    _deleteOverlay();
    entry = OverlayEntry(
        builder: (context) => Positioned(
          left: 20,
          bottom: 80,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green
            ),
            child: SizedBox(
              width: 125,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(imageUrl!, width: 125, height: 75,),
                  IconButton(
                      onPressed: () {
                        _deleteImage(tempFileName!);
                      },
                      icon: Icon(Icons.remove_circle, color: Colors.red,))
                ],
              ),
            ),
          ),
        ),
    );
    Overlay.of(context).insert(entry!);
  }

  void _deleteOverlay()
  {
    if(entry != null && entry!.mounted)
      {
        entry!.remove();
        entry = null;
      }
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

    await fileRef.putFile(File(file!.path))
        .catchError((e) => print(e.toString()))
        .then((value) async {
      imageUrl = await fileRef.getDownloadURL();
      print(imageUrl);
    });

    setState(() {
      imageUrl = imageUrl;
      showImageOverlay();
    });

  }

  void _deleteImage(String filename) async
  {
    entry!.remove();
    entry = null;
    final imageRef = FirebaseStorage.instance.ref().child("/Images/Chat/$filename");
    await imageRef.delete();
    imageUrl = null;
    file = null;
  }

  Future<String> _fetchResponseFromGPT(String message) async
  {
    var data = {
    "messages": [
      {
        "role": 'user',
        "content": message
      }
    ], "tone": 'Balanced'};
    http.Response response = await http.post(Uri.parse("https://chatgpt-42.p.rapidapi.com/gpt4")
        , headers: {
      "content-type": "application/json",
          "X-RapidAPI-Key": API_KEY,
          "X-RapidAPI-Host": "chatgpt-42.p.rapidapi.com"
        }, body: jsonEncode(data));
    if(response.statusCode == 200)
      {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedResponse["result"];
      }
    else
      {
        return response.statusCode.toString() + " " + response.body;
      }
  }

  @override
  void dispose() {
    _deleteOverlay();
    super.dispose();
  }
}
