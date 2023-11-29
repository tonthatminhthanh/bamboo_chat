import 'package:cloud_firestore/cloud_firestore.dart';
import '../objects/user.dart';

class UserSnapshot
{
  MyUser? myUser;
  DocumentReference? documentReference;


  UserSnapshot({required this.myUser, required this.documentReference});

  factory UserSnapshot.fromSnapshot(DocumentSnapshot snapshot)
  {
    return UserSnapshot(
        myUser: MyUser.fromJson(snapshot.data() as Map<String, dynamic>),
        documentReference: snapshot.reference);
  }

  static Future<DocumentReference> addUser(MyUser myUser) async
  {
    return FirebaseFirestore.instance.collection("Users").add(myUser.toJson());
  }

  void capNhat(MyUser myUser) async
  {
    return await documentReference!.update(myUser.toJson());
  }

  static Future<UserSnapshot?> userFromFirebase(String userEmail) async
  {
    UserSnapshot? snapshot;
    var users = await FirebaseFirestore.instance.collection("Users").where("email", isEqualTo: userEmail)
        .limit(1)
        .get().then((event) {
          if(event.docs.isNotEmpty)
            {
               snapshot = UserSnapshot.fromSnapshot(event.docs.single);
            }
    });
    return snapshot;
  }
}