User currentUser;

class User {
  final String userID;
  final String name;
  final String phone;
  final String photo;
  User({this.userID, this.name, this.phone, this.photo});
  factory User.fromMap(Map<String, dynamic> json) => new User(
      userID: json["userID"], name: json["name"], phone: json["phone"], photo: json["photo"]);
  Map<String, dynamic> toMap() =>
      {"userID": userID, "name": name, "phone": phone, "photo": photo};
  @override
  String toString() {
    return "userID $userID Name: $name, phone: $phone";
  }
}
