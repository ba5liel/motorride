import 'package:flutter/material.dart';
import 'package:motorride/bloc/auth_bloc.dart';
import 'package:motorride/pages/home.dart';
import 'package:motorride/pages/loadingpage.dart';
import 'package:motorride/pages/register.dart';
import 'package:motorride/services/service_locator.dart';

import 'modals/user.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motorride',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Initializer(title: 'Flutter Demo Home Page'),
    );
  }
}

class Initializer extends StatelessWidget {
  Initializer({Key key, this.title}) : super(key: key);

  final String title;
  final Authentication auth = new Authentication();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: auth.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapShot) {
          print(snapShot.data);
          return (snapShot.hasData)
              ? (snapShot.data
                  ? getHomePage(context)
                  : new Register(
                      auth: auth,
                    ))
              : new LoadingPage();
        });
  }

  Widget getHomePage(context) {
    return FutureBuilder(
        future: auth.getUser().catchError((e, s) {
          print("$e $s");
        }),
        builder: (BuildContext context, AsyncSnapshot<User> snapUser) {
          if (snapUser.hasData)
            return HomePage(
              auth: auth,
            );
          return Container();
        });
  }
}
