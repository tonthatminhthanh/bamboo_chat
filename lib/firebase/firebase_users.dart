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
  
  static Stream<DocumentSnapshot> friendshipsFromFirebase(String userEmail)
  {
    var friendship = FirebaseFirestore.instance.collection("Friends")
        .where("user1", isEqualTo: userEmail).snapshots();
    Stream<DocumentSnapshot> docSnap = friendship.map(
            (qs) => qs.docs.single);

    return docSnap;
  }

  static Stream<DocumentSnapshot> requestsFromFirebase(String userEmail)
  {
    var friendRequests = FirebaseFirestore.instance.collection("Requests")
        .where("user1", isEqualTo: userEmail).snapshots();
    Stream<DocumentSnapshot> docSnap = friendRequests.map(
      (qs) => qs.docs.single
    );
    return docSnap;
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

  static Stream<UserSnapshot> userStreamFromFirebase(String userEmail)
  {
    var users = FirebaseFirestore.instance.collection("Users").where("email", isEqualTo: userEmail)
        .snapshots();
    var snapshotStream = users.map((event) => event.docs.single);
    return snapshotStream.map((snapshot) => UserSnapshot.fromSnapshot(snapshot));
  }
}