import 'package:flutter/material.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/util/formatter.dart';

class AmountDisplayWidget extends StatelessWidget {
  const AmountDisplayWidget(
      {Key key, @required this.trip, this.inverse = false})
      : super(key: key);

  final Trip trip;
  final bool inverse;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: inverse ? Colors.white : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(50),
              color: inverse ? Colors.white.withAlpha(0) : Color(0xffffff)),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.attach_money,
                color: inverse ? Colors.white : Colors.black,
              ),
              SizedBox(width: 3),
              Text(
                "${Formater().oCcy.format(trip.amount)} br + ${Config.initialPrice} br",
                style: TextStyle(color: inverse ? Colors.white : Colors.black),
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
