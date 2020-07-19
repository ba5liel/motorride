User currentUser;

class User {
  final String userID;
  final String name;
  final String phone;
  final String photo;
  final double rating;
  User({this.userID, this.name, this.phone, this.photo, this.rating});
  factory User.fromMap(Map<String, dynamic> json) => new User(
      userID: json["userID"], name: json["name"], phone: json["phone"], photo: json["photo"], rating: json["rating"]);
  Map<String, dynamic> toMap() =>
      {"userID": userID, "name": name, "phone": phone, "photo": photo, "rating": rating};
  @override
  String toString() {
    return "userID $userID Name: $name, phone: $phone";
  }
}
