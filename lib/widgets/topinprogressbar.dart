import 'package:flutter/material.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/pages/profilepage.dart';
import 'package:motorride/util/widgetutils.dart';
import 'package:motorride/widgets/amountdisplaywidget.dart';
import 'package:motorride/widgets/topnavbar.dart';

class TopInProgressBar extends StatelessWidget {
  const TopInProgressBar({Key key, this.trip}) : super(key: key);
  final Trip trip;
  @override
  Widget build(BuildContext context) {
    return TopNavBar(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage())),
                child: Container(
                  //decoration: ,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: currentUser.photo != null
                        ? NetworkImage(currentUser.photo)
                        : AssetImage("assets/images/user.png"),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(trip.driver.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  WidgetUtils.buildRating(trip.driver.rating ?? 3.5)
                ],
              ),
              CircleAvatar(
                  backgroundImage: trip.driver.photo == null
                      ? AssetImage("assets/images/helmat2.png")
                      : NetworkImage(trip.driver.photo)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  //MyIntent.textPhone(trip.driver.phone);
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            color: Color(0xffeeab05).withOpacity(.3),
                            offset: Offset(0,
                                5)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                        BoxShadow(
                            blurRadius: 18,
                            color: Color(0xffeeab05).withOpacity(.5),
                            offset: Offset(0,
                                6)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                      ],
                      color: Color(0xffeeab05),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.textsms,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              AmountDisplayWidget(
                trip: trip,
                short: true,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    trip.arravialETA,
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  Text(" (${trip.tripDistanceText})",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16))
                ],
              ),
              GestureDetector(
                onTap: () {
                  //MyIntent.callPhone(trip.driver.phone);
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            color: Color(0xff04a56d).withOpacity(.3),
                            offset: Offset(0,
                                5)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                        BoxShadow(
                            blurRadius: 18,
                            color: Color(0xff04a56d).withOpacity(.5),
                            offset: Offset(0,
                                6)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                      ],
                      color: Color(0xff04a56d),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.phone,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("From",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
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
                        trip.pickupAddress.length < 15
                            ? trip.pickupAddress
                            : trip.pickupAddress.substring(0, 15) + "...",
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
                        trip.destinationAddress.length < 15
                            ? trip.destinationAddress
                            : trip.destinationAddress.substring(0, 15) + "...",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
