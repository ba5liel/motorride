import 'package:flutter/material.dart';

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({Key key, @required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            /* image: DecorationImage(
              image: AssetImage('assets/images/motor2.jpg'),
              alignment: Alignment.bottomLeft), */
            boxShadow: [
              BoxShadow(
                  blurRadius: 16,
                  color: Color(0x00).withOpacity(.05),
                  offset: Offset(0,
                      -10)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
              BoxShadow(
                  blurRadius: 18,
                  color: Color(0x00).withOpacity(.075),
                  offset: Offset(0,
                      -12)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11), topRight: Radius.circular(11))),
        child: child);
  }
}
