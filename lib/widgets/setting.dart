import 'package:flutter/material.dart';
import 'package:motorride/bloc/auth_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/pages/changeProfile.dart';
import 'package:motorride/pages/helppage.dart';
import 'package:motorride/pages/register.dart';
import 'package:motorride/util/alerts.dart';

class SettingSection extends StatelessWidget {
  const SettingSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: MyTheme.myPlateDecoration,
        padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Settings",
                    style: TextStyle(color: Colors.black45, fontSize: 13)),
                Icon(Icons.settings, color: Colors.black45, size: 13)
              ],
            ),
            ListTile(
              title: Text(
                'Change profile',
                style: TextStyle(color: MyTheme.primaryColor),
              ),
              subtitle: Text(
                "view and change your profile",
                style: TextStyle(color: Colors.black45),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ChangeProfile();
                }));
              },
              trailing: Icon(
                Icons.bubble_chart,
                color: MyTheme.primaryColor,
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Help',
                style: TextStyle(color: MyTheme.primaryColor),
              ),
              subtitle: Text(
                "get support here",
                style: TextStyle(color: Colors.black45),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return HelpPage();
                }));
              },
              trailing: Icon(
                Icons.live_help,
                color: MyTheme.primaryColor,
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Log out',
                style: TextStyle(color: MyTheme.primaryColor),
              ),
              subtitle: Text(
                "sign out from your account",
                style: TextStyle(color: Colors.black45),
              ),
              onTap: () async {
                Alerts.showPromptDialog(context, "You're about to sign out",
                    "Are you sure you want to continue", () async {
                  await new Authentication().signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => new Register()));
                });
                //new Authentication()..signOut();
              },
              trailing: Icon(
                Icons.power_settings_new,
                color: MyTheme.primaryColor,
              ),
            ),
          ],
        ));
  }
}
