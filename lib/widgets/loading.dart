import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key, this.caption}) : super(key: key);
  final String caption;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0),
      elevation: 0,
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
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
            if (caption != null)
              Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    caption,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
