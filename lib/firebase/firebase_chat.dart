import 'package:cloud_firestore/cloud_firestore.dart';

import '../objects/message.dart';

class MessageSnapshot
{
  Message? message;
  DocumentReference? documentReference;

  MessageSnapshot({required this.message, required this.documentReference});

  factory MessageSnapshot.fromSnapshot(DocumentSnapshot snapshot)
  {
    return MessageSnapshot(
        message: Message.fromJson(snapshot.data() as Map<String, dynamic>),
        documentReference: snapshot.reference);
  }

  static Stream<List<MessageSnapshot>> messagesFromFirebase(String userEmail, String friendEmail)
  {
    var streamQS = FirebaseFirestore.instance.collection("Chat")
        .where(Filter.or(
        Filter.and(Filter("senderId", isEqualTo: userEmail), Filter("receiverId", isEqualTo: friendEmail)),
        Filter.and(Filter("receiverId", isEqualTo: userEmail), Filter("senderId", isEqualTo: friendEmail))
    )).snapshots();
    Stream<List<DocumentSnapshot>> streamList = streamQS.map(
      (queryInfo) => queryInfo.docs,
    );
    return streamList.map((listDS) => listDS.map((ds) => MessageSnapshot.fromSnapshot(ds)).toList());
  }

  static sendMessage({required Message message})
  {
    FirebaseFirestore.instance.collection("Chat").add(message.toJson());
  }
}