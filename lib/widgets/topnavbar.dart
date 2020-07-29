import 'package:flutter/material.dart';
import 'package:motorride/bloc/map_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:provider/provider.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({Key key, @required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              padding: EdgeInsets.all(6.0),
              decoration: MyTheme.myPlateDecoration,
              child: child,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.edit_location,
                    color: Colors.red,
                  ),
                  Text(
                    context.watch<MapBloc>().address,
                    style: TextStyle(
                        color: MyTheme.secondaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
