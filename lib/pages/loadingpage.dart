import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: Stack(children: <Widget>[
                Positioned(
                    top: 2,
                    left: 2,
                    bottom: 2,
                    right: 3,
                    child: CircularProgressIndicator(
                      backgroundColor: MyTheme.primaryColor,
                      strokeWidth: 10,
                    )),
                Center(child: Image.asset('assets/images/logo.png')),
              ]),
            ),
            SizedBox(height: 50),
            Text("Initialzing..."),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
