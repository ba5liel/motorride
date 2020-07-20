import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';

class MyListPageBuilder extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const MyListPageBuilder(
      {Key key, @required this.title, @required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: MyTheme.scaffoldboxDecoration,
        child: SingleChildScrollView(
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
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(title, style: TextStyle(color: Colors.white)),
                    SizedBox(width: 50)
                  ],
                ),
              ),
              Column(
                children: children,
              )
            ],
          ),
        ),
      ),
    );
  }
}
