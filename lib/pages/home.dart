import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motorride/bloc/auth_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/pages/helppage.dart';
import 'package:motorride/pages/inprogresspage.dart';
import 'package:motorride/pages/profilepage.dart';
import 'package:motorride/widgets/googlemap.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final Authentication auth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f8fc),
      body: Stack(
        children: <Widget>[
          MyGoogleMap(
            auth: auth,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: MyTheme.secondaryColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                child: new DrawerHeader(
                    child: Column(
                  children: <Widget>[
                    (currentUser.phone == null)
                        ? new Icon(
                            Icons.account_circle,
                            size: 80.0,
                            color: Colors.white,
                          )
                        : CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(currentUser.photo),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(currentUser.name ?? "",
                        style: TextStyle(color: Colors.white60)),
                    Text(currentUser.phone ?? "",
                        style: TextStyle(color: Colors.white60))
                  ],
                )),
                decoration: BoxDecoration(
                    //image: DecorationImage(
                    //image: AssetImage('assets/images/virus2.png'),
                    //colorFilter: ColorFilter.linearToSrgbGamma(),
                    //),

                    color: MyTheme.secondaryColor),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'In Progress',
                        style: TextStyle(color: MyTheme.primaryColor),
                      ),
                      subtitle: Text(
                        "see your bookings",
                        style: TextStyle(color: Colors.white30),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return InProgressPage();
                        }));
                      },
                      trailing: Icon(
                        Icons.priority_high,
                        color: MyTheme.primaryColor,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'profile',
                        style: TextStyle(color: MyTheme.primaryColor),
                      ),
                      subtitle: Text(
                        "view and change your profile",
                        style: TextStyle(color: Colors.white30),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ProfilePage();
                        }));
                      },
                      trailing: Icon(
                        Icons.bubble_chart,
                        color: MyTheme.primaryColor,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Help',
                        style: TextStyle(color: MyTheme.primaryColor),
                      ),
                      subtitle: Text(
                        "get support here",
                        style: TextStyle(color: Colors.white30),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return HelpPage();
                        }));
                      },
                      trailing: Icon(
                        Icons.live_help,
                        color: MyTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
