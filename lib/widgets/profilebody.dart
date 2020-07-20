import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/widgets/ongoing.dart';
import 'package:motorride/widgets/setting.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    Key key,this.trip
  }) : super(key: key);
  final Driver trip;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: <Widget>[
          Container(
              decoration: MyTheme.myPlateDecoration,
              padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Total Spent",
                        style: TextStyle(color: Colors.black45, fontSize: 13),
                      ),
                      Text("\$125.99",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Total trip",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 13)),
                          Text("15",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Total Time online",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 13)),
                          Text("13h 30m",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Total Distance",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 13)),
                          Text("219.5km",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        if (trip != null) OnGoing(trip: trip),
          SettingSection(),
        ],
      ),
    );
  }
}
