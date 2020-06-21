User currentUser;

class User {
  final String userID;
  final String name;
  final String phone;

  User({this.userID, this.name, this.phone});
  factory User.fromMap(Map<String, dynamic> json) => new User(
      userID: json["userID"], name: json["name"], phone: json["phone"]);
  Map<String, dynamic> toMap() =>
      {"userID": userID, "name": name, "phone": phone};
  @override
  String toString() {
    return "userID $userID Name: $name, phone: $phone";
  }
}
