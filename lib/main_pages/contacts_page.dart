import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:bamboo_chat/utilities/image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utilities/constants.dart';

class ContactPage extends StatefulWidget {
  ContactPage({super.key});
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  int currSelection = 0;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          widget.currSelection == 0 ? Text("Bạn bè", style: TextStyle(color: Colors.white,fontSize: 16))
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
          widget.currSelection == 1 ? Text("Lời mời", style: TextStyle(color: Colors.white,fontSize: 16))
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
          Padding(padding: EdgeInsets.only(right: 10.0))
        ],
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
                              friendsList.sort(
                                    (a, b) => a!.myUser!.displayName.compareTo(b!.myUser!.displayName),
                              );
                              return ListView.separated(
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: ClipOval(
                                      child: Image.network(
                                          getAvatar(friendsList[index]!.myUser!.anh), width: 50.0, height: 50.0,)),
                                    title: Text(
                                      friendsList[index]!.myUser!.displayName,
                                      style: TextStyle(color: Colors.lightGreen, fontSize: 24),
                                    ),
                                    subtitle: Text(
                                      friendsList[index]!.myUser!.email,
                                      style: TextStyle(color: Colors.lightGreen, fontSize: 18),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(color: Colors.white),
                                itemCount: friendsList.length,
                              );
                            }
                        }
                  },);
                  /*ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: ClipOval(child: ImageIcon(
                        NetworkImage( getAvatar(friendsList[index].myUser!.anh)
                        ),)
                      ),
                      title: Text(list[index].myUser!.displayName,
                          style: TextStyle(color: Colors.lightGreen, fontSize: 16),)
                    );
                  },
                  separatorBuilder: (context, index) => Divider(color: Colors.white),
                  itemCount: friendsList.length);*/
            }
        },
      ),
    );
  }
}
