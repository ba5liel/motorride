import 'package:flutter/material.dart';

class WidgetUtils {
  static Row buildRating(double rate) {
    int full = rate.floor();
    double forkes = rate - full;
    int half = forkes.round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var i = 0; i < full; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.star,
              color: Color(0xffeeab05),
              size: 15,
            ),
          ),
        if (half == 1)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.star_half,
              color: Color(0xffeeab05),
              size: 15,
            ),
          ),
        for (int i = 0; i < (5 - (full + half)); i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.star,
              color: Color(0xffcccccc),
              size: 15,
            ),
          ),
        Text(rate.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}
