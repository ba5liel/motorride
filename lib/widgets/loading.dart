import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);
  //340653
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: SingleChildScrollView(
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
              SizedBox(height: 20),
              Text(
                "Initialzing...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
