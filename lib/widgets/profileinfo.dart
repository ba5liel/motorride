import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';

class PersonInfo extends StatelessWidget {
  final String photo;
  final String phone;
  final String name;
  final double rating;
  final double raduis;
  final double font;
  final Color color;
  final Color starColor;
  final EdgeInsets padding;
  PersonInfo(this.photo, this.name, this.phone, this.rating,
      {Key key,
      this.raduis,
      this.color,
      this.font,
      this.starColor,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 23),
      child: Row(
        children: <Widget>[
          Container(
            decoration: MyTheme.avatarDecoration,
            child: CircleAvatar(
              radius: raduis ?? 30,
              backgroundImage: photo != null
                  ? NetworkImage(photo)
                  : AssetImage("assets/images/user.png"),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name ?? phone,
                  style: TextStyle(
                      color: color ?? Colors.white, fontSize: font ?? 15)),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.star,
                    color: starColor ?? Colors.white,
                    size: font ?? 15,
                  ),
                  Text(
                    rating.toString(),
                    style: TextStyle(color: color ?? Colors.white),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
