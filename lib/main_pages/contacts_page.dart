import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:bamboo_chat/utilities/image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactPage extends StatefulWidget {
  ContactPage({super.key});
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: StreamBuilder(
        stream: UserSnapshot.friendshipsFromFirebase(widget.userEmail!),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            {
              if(snapshot.hasError)
                {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        Text("Xin lỗi, chương trình đang gặp lỗi!",
                          style: TextStyle(color: Colors.red, fontSize: 12),),
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
                        CircularProgressIndicator(color: Colors.lightGreen,),
                        Text("Xin chờ! danh bạ của bạn đang được cập nhật!",
                          style: TextStyle(color: Colors.lightGreen, fontSize: 12),),
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
                                style: TextStyle(color: Colors.lightGreen, fontSize: 12),),
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
                                      style: TextStyle(color: Colors.lightGreen, fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      friendsList[index]!.myUser!.email,
                                      style: TextStyle(color: Colors.lightGreen, fontSize: 14),
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
