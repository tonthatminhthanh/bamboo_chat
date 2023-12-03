import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});
  String userEmail = FirebaseAuth.instance.currentUser!.email!;
  SharedPreferences? _preferences;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _tabTextIndexSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: UserSnapshot.userStreamFromFirebase(widget.userEmail),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              {
                if(snapshot.hasError)
                  {
                    var error = snapshot.error.toString();
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
                else
                  {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.lightGreen,),
                          Text("Xin chờ! Thông tin của bạn đang được truy vấn!",
                            style: TextStyle(color: Colors.lightGreen, fontSize: 16),),
                        ],
                      ),
                    );
                  }
              }
            else
            {
              List<ListTile> list = getListTiles();
              UserSnapshot user = snapshot.data!;
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: ClipOval(
                        child: Image.network(user.myUser!.anh!, width: 150, height: 150,),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Center(
                      child: Text(user.myUser!.displayName, style: TextStyle(color: Colors.lightGreen, fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Email: " + user.myUser!.email, style: TextStyle(color: Colors.lightGreen, fontSize: 24))
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Ngày sinh: " + user.myUser!.dob, style: TextStyle(color: Colors.lightGreen, fontSize: 24)),
                    ),
                    Flexible(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return list[index];
                            },
                            separatorBuilder: (context, index) => Divider(color: Colors.white),
                            itemCount: list.length),
                    )
                  ],
                ),
              );
            }
          },
      ),
    );
  }

  List<ListTile> getListTiles()
  {
    List<ListTile> list = [
      ListTile(title: Text("Chế độ giao diện tối"),
        trailing: Switch(
          activeColor: Colors.deepPurple,
          onChanged: (value) => setState(() async {
            await widget._preferences?.setBool("isDark", value);
          }),
          value: widget._preferences!.getBool("isDark")!,
        ),
      )
    ];
    return list;
  }

  @override
  void initState() {
    super.initState();
    _grabPrefs();
  }


  @override
  void setState(VoidCallback fn) {
    super.setState(() {

    });
    _grabPrefs();
  }

  void _grabPrefs() async
  {
    widget._preferences = await SharedPreferences.getInstance();
    if(widget._preferences?.getBool("isDark") == null)
    {
      widget._preferences?.setBool("isDark", true);
    }
  }
}
