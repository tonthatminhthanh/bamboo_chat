import 'package:bamboo_chat/main_pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase/firebase_users.dart';
import '../utilities/image.dart';

class UsersPage extends StatefulWidget {
  UsersPage({super.key});
  String userEmail = FirebaseAuth.instance.currentUser!.email!;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: UserSnapshot.friendshipsFromFirebase(widget.userEmail!),
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
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ChatPage(friendEmail: friendsList[index]!.myUser!.email!),)),
                          leading: Stack(
                            children: [
                              ClipOval(
                                  child: Image.network(
                                    getAvatar(friendsList[index]!.myUser!.anh), width: 50.0, height: 50.0,)),
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
                                    )
                            ],
                          ),
                          title: Text(
                            friendsList[index]!.myUser!.displayName,
                            style: TextStyle(color: Colors.lightGreen, fontSize: 24),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: friendsList.length,
                    );
                  }
                }
              },
            );
          }
        },
      ),
    );
  }
}
