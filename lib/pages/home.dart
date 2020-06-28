import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/pages/profile.dart';
import 'package:motorride/widgets/googlemap.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f8fc),
      body: Stack(
        children: <Widget>[
          MyGoogleMap(),
         /*  Container(
            height: 80,
            child: AppBar(
              iconTheme: IconThemeData(color: MyTheme.primaryColor),
              elevation: 0,
              backgroundColor: Color(0x00),
            ),
          ), */
          
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
                    new Icon(
                      Icons.account_circle,
                      size: 80.0,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(currentUser.name ?? "",
                        style: TextStyle(color: Colors.white60)),
                    Text(currentUser.phone ?? "")
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
                      onTap: () {},
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
                          return MyProfile();
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
                          return HomePage();
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
