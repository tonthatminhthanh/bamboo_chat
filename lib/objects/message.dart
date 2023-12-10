class Message
{
  String senderId;
  String receiverId;
  String content;
  String sentTime;

  Message({
      required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sentTime});

  DateTime getSentTime()
  {
    var sentTime = DateTime.parse(this.sentTime);
    return sentTime;
  }

  String getTimeString()
  {
    var sentTime = DateTime.parse(this.sentTime);
    return sentTime.day.toString()
        + "/"
        + sentTime.month.toString()
        + "/"
        + sentTime.year.toString();
  }

  factory Message.fromJson(Map<String, dynamic> json)
  {
    return Message(
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        content: json["content"],
        sentTime: json["sentTime"]);
  }

  Map<String, dynamic> toJson()
  {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "content": content,
      "sentTime": sentTime
    };
  }
}