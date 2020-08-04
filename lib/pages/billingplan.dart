import 'package:flutter/material.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/constants/theme.dart';

class BillingPlanPage extends StatelessWidget {
  const BillingPlanPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.bgColor,
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text("Billing Plan",
                        style: TextStyle(color: MyTheme.secondaryColor)),
                    SizedBox(width: 50)
                  ],
                ),
              ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Billing plan",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 13)),
                            Icon(Icons.help_outline,
                                color: Colors.black45, size: 13)
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 15.0, 5, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Current",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "billing plan",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text.rich(TextSpan(
                              text: "Price Pre Kilometer: ",
                              children: <InlineSpan>[
                                TextSpan(
                                    style: TextStyle(color: Colors.green),
                                    text: "${Config.pricePerKilo} Br")
                              ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text.rich(TextSpan(
                              text: "Inital Price: ",
                              children: <InlineSpan>[
                                TextSpan(
                                    style: TextStyle(color: Colors.green),
                                    text: "${Config.initialPrice} Br")
                              ])),
                        ),
                      ],
                    )),
              )
            ])));
  }
}
