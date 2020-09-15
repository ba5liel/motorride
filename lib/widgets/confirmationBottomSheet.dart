import 'package:flutter/material.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/widgets/amountdisplaywidget.dart';
import 'package:motorride/widgets/mybottomsheet.dart';
import 'package:motorride/widgets/requestloadingbottomsheet.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  ConfirmationBottomSheet(
      {Key key, @required this.trip, @required this.requestRide})
      : super(key: key);
  final Trip trip;
  final Function requestRide;
  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: Stack(
        children: <Widget>[
          StartTrip(
            trip: trip,
            requestRide: requestRide,
          ),
        ],
      ),
    );
  }
}

class StartTrip extends StatelessWidget {
  const StartTrip({Key key, @required this.trip, @required this.requestRide})
      : super(key: key);
  final Trip trip;
  final Function requestRide;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 7,
                decoration: BoxDecoration(
                    color: Color(0xffdadce0),
                    borderRadius: BorderRadius.circular(8)),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                trip.arravialETA,
                style: TextStyle(color: Colors.green, fontSize: 22),
              ),
              Text(" (${trip.tripDistanceText})",
                  style: TextStyle(color: Colors.grey[600], fontSize: 22))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Drivers",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "${trip.nubmersOfDrivers} Nearby",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("From",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
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
                        trip.pickupAddress.length < 12
                            ? trip.pickupAddress
                            : trip.pickupAddress.substring(0, 12) + "...",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("To",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
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
                            : trip.destinationAddress.substring(0, 12) + "...",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Material(
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isDismissible: false,
                            context: context,
                            builder: (context) {
                              requestRide(context, trip);
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: RequestLoadingBottomSheet(
                                  msg: "Requesting Driver",
                                ),
                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xff3b78e7)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.navigation, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Start",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ))),
              SizedBox(
                width: 5,
              ),
              AmountDisplayWidget(
                trip: trip,
              )
            ],
          )
        ],
      ),
    );
  }
}
