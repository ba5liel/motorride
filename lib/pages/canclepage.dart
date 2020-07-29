import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';

class CanclePage extends StatelessWidget {
  const CanclePage({Key key, @required this.cancle}) : super(key: key);
  final Function(String) cancle;
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
                  Text("Canclation",
                      style: TextStyle(color: MyTheme.secondaryColor)),
                  SizedBox(width: 50)
                ],
              ),
            ),
            Text("Why do you want to cancle"),
            ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Just want to try"),
                  onTap: cancle("Just want to try"),
                ),
                Divider(),
                ListTile(
                  title: Text("Way Expensive"),
                  onTap: cancle("Expensive"),
                ),
                Divider(),
                ListTile(
                  title: Text("Not Safe"),
                  onTap: cancle("Not Safe"),
                ),
                Divider(),
                ListTile(
                  title: Text("Not Comfortable"),
                  onTap: cancle("Not comfortable"),
                ),
              ],
            )
          ],
        ));
  }
}
