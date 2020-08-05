import 'package:flutter/material.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/services/service_locator.dart';
import 'package:motorride/util/formatter.dart';

class AmountDisplayWidget extends StatelessWidget {
  AmountDisplayWidget(
      {Key key, @required this.trip, this.inverse = false, this.short = false})
      : super(key: key);

  final Trip trip;
  final bool inverse;
  final bool short;
  final Config _config = locator<Config>();
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
                short
                    ? "${Formater().oCcy.format(trip.amount + _config.initialPrice)} br"
                    : "${Formater().oCcy.format(trip.amount)} br + ${_config.initialPrice} br",
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
