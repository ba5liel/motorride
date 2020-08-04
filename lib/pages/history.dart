import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/widgets/amountdisplaywidget.dart';
import 'package:motorride/widgets/profileinfo.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.bgColor,
        body: SingleChildScrollView(
          child: Column(
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
                    Text("History",
                        style: TextStyle(color: MyTheme.secondaryColor)),
                    SizedBox(width: 50)
                  ],
                ),
              ),
              if (currentUser.tripHistories.length == 0)
                Container(
                  decoration: MyTheme.myPlateDecoration,
                  padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.warning, color: Colors.orangeAccent),
                      SizedBox(
                        width: 5,
                      ),
                      Text("No Trips Yet",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              for (int i = 0; i < currentUser.tripHistories.length; i++)
                History(
                  tripID: currentUser.tripHistories[i].tripID,
                  trip: currentUser.tripHistories[i].trip,
                  cancled: currentUser.tripHistories[i].cancled ?? false,
                  index: i,
                ),
            ],
          ),
        ));
  }
}

class History extends StatelessWidget {
  final int index;
  final bool cancled;
  final String tripID;
  final Trip trip;
  const History({Key key, this.cancled, this.tripID, this.index, this.trip})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(3)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 16,
                      color: Color(0x00).withOpacity(.05),
                      offset: Offset(0,
                          10)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                  BoxShadow(
                      blurRadius: 18,
                      color: Color(0x00).withOpacity(.075),
                      offset: Offset(0,
                          12)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                ],
              ),
              padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("$index",
                          style:
                              TextStyle(color: Colors.black45, fontSize: 13)),
                      Icon(Icons.help_outline, color: Colors.black45, size: 13)
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 15.0, 5, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(tripID,
                            style:
                                TextStyle(color: Colors.black45, fontSize: 13)),
                        Text(
                          "${trip.arravialETA}",
                          style: TextStyle(color: Colors.black45, fontSize: 13),
                        ),
                      ],
                    ),
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
                          trip.driver.rating ?? 3.5,
                          raduis: 20,
                          font: 13,
                          color: Colors.black54,
                          starColor: MyTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 0),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("From",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w300)),
                          SizedBox(
                            width: 3,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.my_location,
                                size: 14,
                              ),
                              Text(
                                trip.pickupAddress.length < 12
                                    ? trip.pickupAddress
                                    : trip.pickupAddress.substring(0, 12) +
                                        "...",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text("To",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w300)),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.my_location,
                                size: 14,
                              ),
                              Text(
                                trip.destinationAddress.length < 12
                                    ? trip.destinationAddress
                                    : trip.destinationAddress.substring(0, 12) +
                                        "...",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: cancled ? Colors.red : Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AmountDisplayWidget(
                          trip: trip,
                          inverse: true,
                        ),
                        Text(
                          cancled ? "cancled" : "completed",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        )
      ],
    );
  }
}
