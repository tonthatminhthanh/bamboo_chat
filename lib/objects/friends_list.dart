class FriendsList
{
  String userEmail;
  List<String> friends;

  FriendsList({required this.userEmail, required this.friends});

  factory FriendsList.fromSnapshot(Map<String, dynamic> json)
  {
    return FriendsList(
        userEmail: json["user1"], friends: json["friends"]
    );
  }
}