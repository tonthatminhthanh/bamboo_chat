class MyUser
{
  String email;
  String anh;
  String displayName;
  String dob;
  bool isOnline;

  MyUser({required this.email,
    this.anh = "",
    required this.displayName,
    required this.dob, required this.isOnline});

  String getNgaySinh()
  {
    var ngaySinh = DateTime.parse(this.dob);
    return ngaySinh.day.toString()
        + "/"
        + ngaySinh.month.toString()
        + "/"
        + ngaySinh.year.toString();
  }

  factory MyUser.fromJson(Map<String, dynamic> json)
  {
    return MyUser(
    email: json["email"],
    anh: json["pfp"],
    displayName: json["name"],
        dob: json["dob"],
      isOnline: json["status"]
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      "email": this.email,
      "pfp": this.anh,
      "name": this.displayName,
      "dob": this.dob,
      "status": this.isOnline
    };
  }
}