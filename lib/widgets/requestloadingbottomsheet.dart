import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/widgets/mybottomsheet.dart';

class RequestLoadingBottomSheet extends StatelessWidget {
  const RequestLoadingBottomSheet({
    Key key, @required this.msg
  }) : super(key: key);
  final String msg;
  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/loading.gif"),
              )),
              child: Center(
                  child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: MyTheme.primaryColor),
                      child: Center(
                          child: Text(
                        msg,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )))),
            ),
          )
        ],
      ),
    );
  }
}
