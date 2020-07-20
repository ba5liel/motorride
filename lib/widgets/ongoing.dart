import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/widgets/profileinfo.dart';

class OnGoing extends StatelessWidget {
  const OnGoing({Key key, @required this.trip}) : super(key: key);
  final Driver trip;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: MyTheme.myPlateDecoration,
        padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("On going",
                    style: TextStyle(color: Colors.black45, fontSize: 13)),
                Icon(Icons.nature, color: Colors.black45, size: 13)
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15.0, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PersonInfo(
                    trip.photo,
                    trip.name,
                    trip.phone,
                    trip.rating ?? 5,
                    raduis: 20,
                    font: 13,
                    color: Colors.black54,
                    starColor: MyTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0),
                  ),
                  Text(
                    "5m:10s",
                    style: TextStyle(color: Colors.black45, fontSize: 13),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.call, color: MyTheme.primaryColor, size: 20),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Call",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.textsms,
                            color: MyTheme.primaryColor, size: 20),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Text",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.navigation,
                            color: MyTheme.primaryColor, size: 20),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Navigate",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
