import 'package:flutter/material.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/util/intent.dart';
import 'package:motorride/widgets/mybottomsheet.dart';

class DriverInfoBottomSheet extends StatelessWidget {
  const DriverInfoBottomSheet(
      {Key key, @required this.trip, @required this.cancleTrip})
      : super(key: key);
  final Function cancleTrip;
  final Trip trip;
  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
        height: 270,
        child: Padding(
          padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
          child: SingleChildScrollView(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.timer, color: Color(0xffeeab05)),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      trip.arravialETA,
                      style: TextStyle(
                          color: Color(0xffeeab05),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Remaining",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        MyIntent.textPhone(trip.driver.phone);
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
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Color(0xff04a56d),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: trip.driver.photo == null
                                  ? AssetImage('assets/images/helmat2.png')
                                  : NetworkImage(trip.driver.photo)),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        MyIntent.callPhone(trip.driver.phone);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("${trip.driver.name} (${trip.tripDistanceText}) Away",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Plate number (${trip.driver.targa})",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
                buildRating(trip.driver.rating ?? 3.5),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: () {
                    cancleTrip();
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.red,
                      //onPressed: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Cancle",
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(Icons.close, color: Colors.white)
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }

  Row buildRating(double rate) {
    int full = rate.floor();
    double forkes = rate - full;
    int half = forkes.round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var i = 0; i < full; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.star,
              color: Color(0xffeeab05),
              size: 15,
            ),
          ),
        if (half == 1)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.star_half,
              color: Color(0xffeeab05),
              size: 15,
            ),
          ),
        for (int i = 0; i < (5 - (full + half)); i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.star,
              color: Color(0xffcccccc),
              size: 15,
            ),
          ),
        Text(rate.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}
