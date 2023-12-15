import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:bamboo_chat/main_pages/add_request.dart';
import 'package:bamboo_chat/objects/user.dart';
import 'package:bamboo_chat/utilities/image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utilities/constants.dart';

class ContactPage extends StatefulWidget {
  ContactPage({super.key});
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  int currSelection = 0;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  TextEditingController txtSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            widget.currSelection == 0 ? Text("Bạn bè", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                : ElevatedButton(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        Size(50, BUTTON_HEIGHT)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)
                ),
                onPressed: () {
                  setState(() {
                    widget.currSelection = 0;
                  });
                },
                child: Text("Bạn bè", style: TextStyle(color: Colors.white,fontSize: 16))
            ),
            Padding(padding: EdgeInsets.only(right: 5)),
            widget.currSelection == 1 ? Text("Lời mời", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                : ElevatedButton(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        Size(50, BUTTON_HEIGHT)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)
                ),
                onPressed: () {
                  setState(() {
                    widget.currSelection = 1;
                  });
                },
                child: Text("Lời mời", style: TextStyle(color: Colors.white,fontSize: 16))
            ),
            Padding(padding: EdgeInsets.only(right: 10.0)),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendRequest(),));
        },
        child: Icon(Icons.add, weight: 2.5),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: widget.currSelection == 0 
            ? UserSnapshot.friendshipsFromFirebase(widget.userEmail!) 
            : UserSnapshot.requestsFromFirebase(widget.userEmail!),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            {
              if(snapshot.hasError)
                {
                  var error = snapshot.error.toString();
                  if(error.contains("No element"))
                    {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.emoji_emotions, color: Colors.yellow),
                            Text("Xin lỗi vì bạn không có bạn bè!",
                              style: TextStyle(color: Colors.yellow, fontSize: 16),),
                          ],
                        ),
                      );
                    }
                  else
                    {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            Text("Xin lỗi, chương trình đang gặp lỗi! $error",
                              style: TextStyle(color: Colors.red, fontSize: 16),),
                          ],
                        ),
                      );
                    }
                }
              else
                {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.lightGreen,),
                        Text("Xin chờ! danh bạ của bạn đang được cập nhật!",
                          style: TextStyle(color: Colors.lightGreen, fontSize: 16),),
                      ],
                    ),
                  );
                }
            }
          else
            {
              List<dynamic> list = snapshot.data?["friends"];
              List<Future<UserSnapshot?>> userSnapshotFutures = list.map((userEmail) {
                return UserSnapshot.userFromFirebase(userEmail);
              }).toList();
              return FutureBuilder(
                  future: Future.wait(userSnapshotFutures),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting)
                      {
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.lightGreen,),
                              Text("Đã tìm thấy danh bạ! Đang hiển thị...",
                                style: TextStyle(color: Colors.lightGreen, fontSize: 16),),
                            ],
                          ),
                        );
                      }
                      else
                        {
                          if(snapshot.hasError)
                            {
                              return Center(
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
                              );
                            }
                          else
                            {
                              List<UserSnapshot?> friendsList = snapshot.data!;
                              friendsList.removeWhere((userSnapshot) => userSnapshot == null);
                              friendsList.removeWhere((userSnapshot) => !userSnapshot!.myUser!.displayName.toLowerCase().contains(txtSearch.text.toLowerCase()));
                              friendsList.sort(
                                    (a, b) => a!.myUser!.displayName.compareTo(b!.myUser!.displayName),
                              );
                              return Column(
                                children: [
                                  Focus(
                                    onFocusChange: (hasFocus) async {
                                      if(!hasFocus)
                                      {
                                        setState(() {

                                        });
                                      }
                                    },
                                    child: TextFormField(controller: txtSearch,
                                      decoration: InputDecoration(
                                          labelText: "Tìm kiếm", prefixIcon: Icon(Icons.search),
                                          hintText: "Nhập tên người bạn cần tìm",
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
                                  Expanded(
                                    child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return Slidable(
                                        enabled: friendsList[index]!.myUser!.email != "bing-chat",
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            widget.currSelection == 0 ? Container(
                                              width: 0,
                                              height: 0,
                                            ) : SlidableAction(
                                              onPressed: (context) {
                                                UserSnapshot.addFriend(widget.userEmail!, friendsList[index]!.myUser!.email);
                                                UserSnapshot.addFriend(friendsList[index]!.myUser!.email, widget.userEmail!);
                                                UserSnapshot.removeRequest(widget.userEmail!, friendsList[index]!.myUser!.email);
                                              },
                                              icon: Icons.check,
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.lightGreen,
                                            ),
                                            SlidableAction(
                                              onPressed: (context) {
                                                if(widget.currSelection == 0)
                                                  {
                                                    UserSnapshot.removeFriend(widget.userEmail!, friendsList[index]!.myUser!.email);
                                                    UserSnapshot.removeFriend(friendsList[index]!.myUser!.email, widget.userEmail!);
                                                  }
                                                else
                                                  {
                                                    UserSnapshot.removeRequest(widget.userEmail!, friendsList[index]!.myUser!.email);
                                                  }
                                              },
                                              icon: Icons.close,
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.red,
                                            )
                                          ],
                                        ),
                                        child: ListTile(
                                          leading: ClipOval(
                                            child: Image.network(
                                                getAvatar(friendsList[index]!.myUser!.anh), width: 50.0, height: 50.0,)),
                                          title: Text(
                                            friendsList[index]!.myUser!.displayName,
                                            style: TextStyle(color: Colors.lightGreen, fontSize: 24),
                                          ),
                                          subtitle: Text(
                                            friendsList[index]!.myUser!.email != "bing-chat"? friendsList[index]!.myUser!.email : "Bing Chat là một chatbot AI được phát triển bởi Microsoft!",
                                            style: TextStyle(color: Colors.lightGreen, fontSize: 18),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => Divider(),
                                    itemCount: friendsList.length,
                                                                    ),
                                  ),

                                ]
                              );
                            }
                        }
                  },);
            }
        },
      ),
    );
  }
}
