import 'package:flutter/material.dart';

class MyTheme {
  static Color primaryColor = Color(0xffff5500);
  static Color secondaryColor = Color(0xff212121);
  static Color bgColor = Color(0xfff7f8fc);
  static BoxDecoration scaffoldboxDecoration = BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/pbg.png"), fit: BoxFit.cover));
  static BoxDecoration myPlateDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(3)),
    boxShadow: [
      BoxShadow(
          blurRadius: 16,
          color: Color(0x00).withOpacity(.05),
          offset: Offset(
              0, 10)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
      BoxShadow(
          blurRadius: 18,
          color: Color(0x00).withOpacity(.075),
          offset: Offset(
              0, 12)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
    ],
  );
  static BoxDecoration avatarDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(100)),
    boxShadow: [
      BoxShadow(
          blurRadius: 16,
          color: Color(0x00).withOpacity(.05),
          offset: Offset(
              0, 10)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
      BoxShadow(
          blurRadius: 18,
          color: Color(0x00).withOpacity(.075),
          offset: Offset(
              0, 12)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
    ],
  );
}
