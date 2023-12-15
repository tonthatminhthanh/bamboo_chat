import 'package:bamboo_chat/account_pages/start_page.dart';
import 'package:bamboo_chat/firebase/firebase_users.dart';
import 'package:bamboo_chat/main_pages/edit_user_page.dart';
import 'package:bamboo_chat/utilities/constants.dart';
import 'package:bamboo_chat/utilities/dialog.dart';
import 'package:bamboo_chat/utilities/preferences.dart';
import 'package:bamboo_chat/utilities/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.mode});
  ThemeProvider mode;
  String userEmail = FirebaseAuth.instance.currentUser!.email!;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool? _isDark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              UserSnapshot user = snapshot.data!;
              List<ListTile> list = getListTiles(user);
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: ClipOval(
                        child: Container(
                          height: 250,
                          width: 250,
                          child: CachedNetworkImage(
                            imageUrl:user.myUser!.anh != null ?
                            user.myUser!.anh : DEFAULT_AVATAR
                            ,fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(
                              value: progress.progress,
                            ),
                            errorWidget: (context, url, error) => Row(
                              children: [
                                Icon(Icons.error, color: Colors.red,),
                                Text("Không thể tải hình!", style: TextStyle(color: Colors.red),)
                              ],
                            ),
                          ),
                        ),
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
                      child: Text("Ngày sinh: " + user.myUser!.getNgaySinh(), style: TextStyle(color: Colors.lightGreen, fontSize: 24)),
                    ),
                    Flexible(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return list[index];
                            },
                            separatorBuilder: (context, index) => Divider(),
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

  List<ListTile> getListTiles(UserSnapshot usersnapshot)
  {
    List<ListTile> list = [
      ListTile(title: Text("Chế độ giao diện tối"),
        trailing: Switch(
          activeColor: Colors.lightGreen,
          onChanged: (value) => setState(() async {
            _isDark = value;
            saveBool();
            Provider.of<ThemeProvider>(context, listen: false).toggle(_isDark!);
          }),
          value: _isDark!,
        ),
      ),
      ListTile(
        title: Text("Chỉnh sửa thông tin cá nhân"),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditUserPage(snapshop: usersnapshot),)
          );
        },
      ),
      ListTile(
          title: Text("Đăng xuất", style: TextStyle(color: Colors.red)),
        onTap: () async {
            bool? canLogOut = await showWarningDialog(
                context: context, msg: "Bạn có muốn đăng xuất?"
            );
          if(canLogOut!)
            {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AccountPage(),),
                      (Route<dynamic> route) => false);
            }
        },
      ),
    ];
    return list;
  }

  void loadBool() async
  {
    setState(() {
      _isDark = Preferences.getPrefs!.getBool("isDark");
    });
  }

  Future<void> saveBool()
  async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await Preferences.getPrefs!.setBool("isDark", _isDark!);
  }

  @override
  void initState() {
    super.initState();
    loadBool();
  }
}
