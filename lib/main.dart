import 'package:flutter/material.dart';
import 'package:motorride/bloc/auth_bloc.dart';
import 'package:motorride/pages/home.dart';
import 'package:motorride/pages/loadingpage.dart';
import 'package:motorride/pages/register.dart';
import 'package:motorride/services/service_locator.dart';
import 'package:motorride/services/calls_and_messages_service.dart';

import 'modals/user.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motorride',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        //ff5500
        //212121
        primarySwatch: Colors.orange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Initializer(title: 'Flutter Demo Home Page'),
    );
  }
}

class Initializer extends StatelessWidget {
  Initializer({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  final Authentication auth = new Authentication();
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets
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
      future: auth.getUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapUser) {
          if(snapUser.hasData && currentUser == snapUser.data)
          return HomePage();
          return Container();
        });
  }
}
