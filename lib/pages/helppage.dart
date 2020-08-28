import 'package:flutter/material.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/services/calls_and_messages_service.dart';
import 'package:motorride/services/service_locator.dart';

class HelpPage extends StatelessWidget {
  HelpPage({Key key}) : super(key: key);
  final CallsAndMessagesService _callsAndMessagesService =
      locator<CallsAndMessagesService>();
  final Config _config = locator<Config>();
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
                    Text("Help",
                        style: TextStyle(color: MyTheme.secondaryColor)),
                    SizedBox(width: 50)
                  ],
                ),
              ),
              HowTos(
                content: """- Set your initial location on a map
- Set your destination location on a map
- Set the payment and booking schedule, and confirm. No worries, drivers accept cash.
- A nearby driver calls you after accepting the order to verify your exact location
- You can also see the driver’s picture, vehicle license plate and side numbers, and a brief info on the driver. After completing a trip, you can request a paper-based receipt, or review our e-receipt sent out to your email automatically, upon payment confirmation.""",
                title: "How to use",
                subtitle: "Getting started",
              ),
              HowTos(
                content:
                    "Ethiopia's First Motor Hailing app. Book or hail a Motor from anywhere in Addis in minutes. ©2020 Motorride, Copyright reserved",
                title: "Privacy and term",
                subtitle: "Terms and conditions",
              ),
              Column(
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
                                Text("FAQ",
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 13)),
                                Icon(Icons.help_outline,
                                    color: Colors.black45, size: 13)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 15.0, 5, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Contact support",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "basic",
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      _callsAndMessagesService
                                          .call(_config.contact1);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.call,
                                            color: MyTheme.primaryColor,
                                            size: 20),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("Support call 1",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _callsAndMessagesService
                                          .call(_config.contact2);
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Text("Support call 2",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(Icons.call,
                                            color: MyTheme.primaryColor,
                                            size: 20)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
              if(_config.promot) Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: MyTheme.secondaryColor,
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
                                Text("FAQ",
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 13)),
                                Icon(Icons.help_outline,
                                    color: Colors.white60, size: 13)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 15.0, 5, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text("Made with",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800)),
                                      Icon(
                                        Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                      Text("Knovuslab",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Text(
                                    "basic",
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text.rich(TextSpan(
                                  style: TextStyle(color: Colors.white60),
                                  text: "https://www.knovuslab.com \n\n",
                                  children: <InlineSpan>[
                                    TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        text:
                                            "KNOVUSLAB is an innovation lab based in Addis Ababa, Ethiopia. Working on emerging technologies.")
                                  ])),
                            ),
                            Image.asset(
                              "assets/images/knovuslab.png",
                              scale: 2,
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      _callsAndMessagesService
                                          .launchUrl("www.knovuslab.com");
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Text("Visit",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(Icons.launch,
                                            color: MyTheme.primaryColor,
                                            size: 20)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ) 
            ],
          ),
        ));
  }
}

class HowTos extends StatelessWidget {
  final String title;
  final String subtitle;
  final String content;
  final String video;
  HowTos({Key key, this.title, this.subtitle, this.content, this.video})
      : super(key: key);
  final CallsAndMessagesService _callsAndMessagesService =
      locator<CallsAndMessagesService>();
  final Config _config = locator<Config>();

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
                      Text("FAQ",
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
                        Text(title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Text(
                          "basic",
                          style: TextStyle(color: Colors.black45, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(TextSpan(
                        text: "$subtitle \n\n",
                        children: <InlineSpan>[
                          TextSpan(
                              style: TextStyle(color: Colors.black45),
                              text: content)
                        ])),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _callsAndMessagesService
                                .launchUrl(_config.youtubechannel);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.ondemand_video,
                                  color: MyTheme.primaryColor, size: 20),
                              SizedBox(
                                width: 8,
                              ),
                              Text("video",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _callsAndMessagesService
                                .launchUrl(_config.telegrambot);
                          },
                          child: Row(
                            children: <Widget>[
                              Text("Ask",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(Icons.send,
                                  color: MyTheme.primaryColor, size: 20)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
