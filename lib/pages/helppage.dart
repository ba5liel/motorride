import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key key}) : super(key: key);

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
                content:
                    "For quickly making a snapshot, you can omit 'push'. In this mode, non-option arguments are not allowed to prevent a misspelled subcommand from making an unwanted stash entry",
                title: "How to use",
                subtitle: "Getting started",
              ),
              HowTos(
                content:
                    "When pathspec is given to git stash push, the new stash entry records the modified states only for the files that match the pathspec. The index entries and working tree files are then rolled",
                title: "Privacy and term",
                subtitle: "Terms and conditions",
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
  const HowTos({Key key, this.title, this.subtitle, this.content, this.video})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
              decoration: MyTheme.myPlateDecoration,
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
                          onTap: () {},
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
                          onTap: () {},
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
