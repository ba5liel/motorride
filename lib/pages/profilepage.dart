import 'package:flutter/material.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/pages/mylistpagebuilder.dart';
import 'package:motorride/widgets/profilebody.dart';
import 'package:motorride/widgets/profileinfo.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyListPageBuilder(title: "Profile", children: <Widget>[
      PersonInfo(currentUser.photo, currentUser.name, currentUser.phone,
          currentUser.rating ?? 3.5),
      ProfileBody(),
    ]);
  }
}
