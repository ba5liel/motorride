import 'package:flutter/material.dart';
import 'package:motorride/widgets/mybottomsheet.dart';

class DriverInfoBottomSheet extends StatelessWidget {
  const DriverInfoBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 7,
                decoration: BoxDecoration(
                    color: Color(0xffdadce0),
                    borderRadius: BorderRadius.circular(8)),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.timer, color: Color(0xffeeab05)),
              SizedBox(
                width: 5,
              ),
              Text(
                "5:59",
                style: TextStyle(
                    color: Color(0xffeeab05),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Min Remaining",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          color: Color(0xffeeab05).withOpacity(.3),
                          offset: Offset(0,
                              5)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                      BoxShadow(
                          blurRadius: 18,
                          color: Color(0xffeeab05).withOpacity(.5),
                          offset: Offset(0,
                              6)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                    ],
                    color: Color(0xffeeab05),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  Icons.textsms,
                  size: 15,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Color(0xff04a56d),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/helmat2.png')),
                    borderRadius: BorderRadius.circular(15)),
              ),
              SizedBox(
                width: 40,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          color: Color(0xff04a56d).withOpacity(.3),
                          offset: Offset(0,
                              5)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                      BoxShadow(
                          blurRadius: 18,
                          color: Color(0xff04a56d).withOpacity(.5),
                          offset: Offset(0,
                              6)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                    ],
                    color: Color(0xff04a56d),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  Icons.phone,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Basliel Selamu",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (var i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.star,
                    color: Color(0xffeeab05),
                    size: 15,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.star,
                  color: Color(0xffcccccc),
                  size: 15,
                ),
              ),
              Text("4.7",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.all(10),
              color: Colors.red,
              //onPressed: null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Cancle",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.close, color: Colors.white)
                ],
              ))
        ],
      ),
    ));
  }
}
