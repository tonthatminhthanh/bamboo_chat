import 'dart:convert';

import 'package:bamboo_chat/utilities/constants.dart';
import 'package:bamboo_chat/utilities/scroll.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:bamboo_chat/firebase/firebase_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../objects/message.dart';

List<Message> messagesList = [
  Message(senderId: "wimpycaty@gmail.com", receiverId: "", content: '{"message": "Hello!"}', sentTime: DateTime.now().toString(),),
  Message(senderId: "wimpycaty@gmail.com", receiverId: "", content: '{"message": "Hello!"}', sentTime: DateTime.now().toString(),),
  Message(senderId: "wimpycaty@gmail.com", receiverId: "", content: '{"message": "Hello!"}', sentTime: DateTime.now().toString(),),
  Message(senderId: "wimpycaty@gmail.com", receiverId: "", content: '{"message": "Hello!"}', sentTime: DateTime.now().toString(),),
  Message(senderId: "wimpycaty@gmail.com", receiverId: "", content: '{"message": "Hello!"}', sentTime: DateTime.now().toString(),),
  Message(senderId: "wimpycaty@gmail.com", receiverId: "", content: '{"message": "Hello!"}', sentTime: DateTime.now().toString(),)
];

class ChatMessage extends StatefulWidget {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  String friendEmail;
  ChatMessage({super.key, required this.friendEmail, required this.scrollController});
  ScrollController scrollController;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  String error = "";
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: StreamBuilder<Object>(
        stream: MessageSnapshot.messagesFromFirebase(widget.userEmail!, widget.friendEmail!),
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
                        Text("Xin chờ! danh bạ của bạn đang được cập nhật!",
                          style: TextStyle(color: Colors.lightGreen, fontSize: 16),),
                      ],
                    ),
                  );
                }
            }
          else
            {
              List<MessageSnapshot> messagesList = snapshot.data! as List<MessageSnapshot>;
              messagesList.sort(
                (a, b) => a.message!.getSentTime().compareTo(b.message!.getSentTime()),
              );
              return ListView.builder(
                controller: widget.scrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return MessageBubble(
                      isMe: didISendThis(messagesList[index].message!.senderId),
                      message: messagesList[index].message!);
                },
                itemCount: messagesList.length,
              );
            }
        }
      ),
    );
  }

  bool didISendThis(String email)
  {
    return widget.userEmail == email;
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollDown(widget.scrollController);
      print("Down");
    });
  }
}


class MessageBubble extends StatefulWidget {
  bool isMe;
  Message message;

  MessageBubble({super.key, required this.isMe, required this.message});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isMe ? Alignment.topRight : Alignment.topLeft,
      child: SizedBox(
        child: Container(
          decoration: BoxDecoration(
            color: widget.isMe ? Colors.grey : Colors.green,
              borderRadius: widget.isMe ? BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ) : BorderRadius.only(
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              )
          ),
          margin: widget.isMe
              ? const EdgeInsets.only(top: 10, right: 10, left: 50)
              : const EdgeInsets.only(top: 10, right: 50, left: 10),
          padding: const EdgeInsets.all(10),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
              minWidth: 50.0
            ),
            child: (() {
              Map<String, dynamic> decodedJson = getJson(widget.message.content);
              if(decodedJson.containsKey("image"))
              {
                ImageProvider provider = CachedNetworkImageProvider(decodedJson["image"]);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text('''${decodedJson["message"]!}''', style: TextStyle(fontSize: 18, color: Colors.white),),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 350,
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                      ),
                      child: GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: decodedJson["image"],fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) => LinearProgressIndicator(
                            value: progress.progress,
                          ),
                          errorWidget: (context, url, error) => Row(
                            children: [
                              Icon(Icons.error, color: Colors.red,),
                              Text("Không thể tải hình!", style: TextStyle(color: Colors.red),)
                            ],
                          ),
                        ),
                        onTap: () {
                          showImageViewer(context, provider, onViewerDismissed: () {

                          },);
                        },
                      )
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Text("${widget.message.getSentTime().hour.toString().padLeft(2, '0')}:${widget.message.getSentTime().minute.toString().padLeft(2, '0')}, ${widget.message.getSentTime().day}/${widget.message.getSentTime().month}/${widget.message.getSentTime().year}")
                      ],
                    )
                  ],
                );
              }
              else
              {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text('''${decodedJson["message"]!}''', style: TextStyle(fontSize: 18, color: Colors.white),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Text("${widget.message.getSentTime().hour.toString().padLeft(2, '0')}:${widget.message.getSentTime().minute.toString().padLeft(2, '0')}, ${widget.message.getSentTime().day}/${widget.message.getSentTime().month}/${widget.message.getSentTime().year}")
                      ],
                    )
                  ],
                );
              }
            }())
          )
        ),
      ),
    );
  }

  Map<String, dynamic> getJson(String str)
  {
    return jsonDecode(str);
  }
}

