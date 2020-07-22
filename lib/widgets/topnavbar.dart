import 'package:flutter/material.dart';
import 'package:motorride/bloc/map_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/widgets/thethreedots.dart';
import 'package:provider/provider.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({
    Key key,
  }) : super(key: key);

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
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => context
                              .read<MapBloc>()
                              .openAutoCompleteFrom(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: Color(0xffe8f0fe),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Center(
                                    child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                            color: Color(0xffffffff),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Center(
                                            child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: Color(0xff1a73e8),
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                        ))),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "From, ${context.watch<MapBloc>().pickupAddress}",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xff4a4a4a)),
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffe8eaed),
                                      borderRadius: BorderRadius.circular(25)),
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.search,
                                    size: 14,
                                    color: Color(0xff3c4043),
                                  )),
                              SizedBox(
                                width: 8,
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.read<MapBloc>().choosePickUpLocationOnMap();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffe8eaed),
                                borderRadius: BorderRadius.circular(25)),
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.map,
                              size: 14,
                              color: Color(0xff3c4043),
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  TheThreeDots(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () => null,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => context
                              .read<MapBloc>()
                              .openAutoCompleteTo(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "To,  ${context.watch<MapBloc>().destinationAddress}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xff4a4a4a)),
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffe8eaed),
                                      borderRadius: BorderRadius.circular(25)),
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.search,
                                    size: 14,
                                    color: Color(0xff3c4043),
                                  )),
                              SizedBox(
                                width: 8,
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => context
                            .read<MapBloc>()
                            .chooseDestinationLocationOnMap(),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffe8eaed),
                                borderRadius: BorderRadius.circular(25)),
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.map,
                              size: 14,
                              color: Color(0xff3c4043),
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
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
