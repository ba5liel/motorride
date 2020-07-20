import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/widgets/ongoing.dart';

class InProgressPage extends StatelessWidget {
  const InProgressPage({Key key, this.trip}) : super(key: key);
  final Driver trip;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.bgColor,
        body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.chevron_left,
                      color: MyTheme.secondaryColor,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text("In Progress",
                      style: TextStyle(color: MyTheme.secondaryColor)),
                  SizedBox(width: 50)
                ],
              ),
            ),
            Expanded(
              child: Center(
                  child: trip != null
                      ? OnGoing(trip: trip)
                      : Container(
                          decoration: MyTheme.myPlateDecoration,
                          padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.warning, color: Colors.orangeAccent),
                              SizedBox(
                                width: 5,
                              ),
                              Text("No Inprogress Trips",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
            ),
          ],
        ));
  }
}
