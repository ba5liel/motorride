import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/driver.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CompletePage extends StatefulWidget {
  const CompletePage({Key key, @required this.driver}) : super(key: key);

  final Driver driver;

  @override
  _CompletePageState createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  double newRateing;
  @override
  void initState() {
    super.initState();
    newRateing = widget.driver.rating ?? 3.5;
  }

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
                  Text("Trip Completed",
                      style: TextStyle(color: MyTheme.secondaryColor)),
                  SizedBox(width: 50)
                ],
              ),
            ),
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
                  Text("Trip Completed",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: MyTheme.bgColor,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: widget.driver.photo == null
                                  ? AssetImage('assets/images/helmat2.png')
                                  : NetworkImage(widget.driver.photo)),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      "$newRateing",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Center(
                        child: SmoothStarRating(
                            allowHalfRating: true,
                            onRated: (v) {
                              setState(() {
                                newRateing = v;
                              });
                            },
                            starCount: 5,
                            rating: widget.driver.rating ?? 3.5,
                            size: 35.0,
                            isReadOnly: false,
                            color: Color(0xffeeab05),
                            borderColor: Color(0xffeeab05),
                            spacing: 0.0)),
                    Column(
                      children: [
                        FlatButton(
                          color: MyTheme.primaryColor,
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("drivers")
                                .doc(widget.driver.userID)
                                .update({
                              "rating":
                                  (newRateing + (widget.driver.rating ?? 3.5)) /
                                      2
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Text(
                                "Rate ${widget.driver.name}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Text(
                                "No, Thanks",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyTheme.secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
