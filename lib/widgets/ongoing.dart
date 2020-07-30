import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/services/calls_and_messages_service.dart';
import 'package:motorride/services/service_locator.dart';
import 'package:motorride/widgets/profileinfo.dart';

class OnGoing extends StatelessWidget {
  OnGoing({
    Key key,
    @required this.trip,
  }) : super(key: key);
  final Trip trip;
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
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
                    trip.driver.photo,
                    trip.driver.name,
                    trip.driver.phone,
                    trip.driver.rating ?? 5,
                    raduis: 20,
                    font: 13,
                    color: Colors.black54,
                    starColor: MyTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 0),
                  ),
                  Text(
                    "${trip.arravialETA}",
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
                    onTap: () {
                      _service.call(trip.driver.phone);
                    },
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
                    onTap: () {
                      _service.sendSms(trip.driver.phone);
                    },
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
                    onTap: () {
                      Navigator.pop(context);
                    },
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
            GestureDetector(
              onTap: () {
                currentUser.inProgressTrip.trip.complete(context);
              },
              child: Container(
                  color: Color(0xff04a56d),
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text("Complete",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  )),
            ),
          ],
        ));
  }
}
