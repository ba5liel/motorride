import 'package:flutter/material.dart';
import 'package:motorride/bloc/map_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:provider/provider.dart';

class SetMarketCenter extends StatelessWidget {
  const SetMarketCenter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SetMarketType setMarketType =
        context.select((MapBloc m) => m.showSetMarker);

    return AnimatedOpacity(
      duration: Duration(milliseconds: 800),
      curve: Curves.easeIn,
      opacity: setMarketType == SetMarketType.SHOW_NOTHING ? 0 : 1,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  setMarketType == SetMarketType.SHOW_PICKUP
                      ? 'assets/images/pickup.png'
                      : 'assets/images/user_place_destination4.png',
                  scale: 2,
                ),
                Container(
                    color: setMarketType == SetMarketType.SHOW_PICKUP
                        ? MyTheme.primaryColor
                        : Colors.greenAccent,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      setMarketType == SetMarketType.SHOW_PICKUP
                          ? "Set Pick up location here"
                          : "Set Destination location here",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
