import 'package:flutter/material.dart';

class TheThreeDots extends StatelessWidget {
  const TheThreeDots({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      SizedBox(
        width: 50,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5),
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(25)),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(25)),
            ),
            Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(25)),
            ),
          ],
        ),
      )
    ]);
  }
}
