import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/util/formatter.dart';
import 'package:motorride/widgets/ongoing.dart';
import 'package:motorride/widgets/setting.dart';

class ProfileBody extends StatelessWidget {
  ProfileBody({Key key}) : super(key: key);
  final double totalEarining = currentUser.tripHistories.length < 1
      ? 0
      : currentUser.tripHistories.fold(0, (p, c) => p + c.trip.amount);
  final double totalTime = currentUser.tripHistories.length < 1
      ? 0
      : currentUser.tripHistories.fold(0, (p, c) => p + c.trip.eTA) / 3600;
  final double totalDistance = currentUser.tripHistories.length < 1
      ? 0
      : currentUser.tripHistories.fold(0, (p, c) => p + c.trip.tripDistance) /
          1000;
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
                      Text("\$ ${Formater().oCcy.format(totalEarining)} br",
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
                          Text("${currentUser.tripHistories.length}",
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
                          Text(
                              "${Formater().formatDatetime(Duration(seconds: totalTime.toInt()))}",
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
                          Text("${Formater().formatDistance(totalDistance)}",
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
          if (currentUser.inProgressTrip != null)
            OnGoing(trip: currentUser.inProgressTrip.trip),
          SettingSection(),
        ],
      ),
    );
  }
}
