import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/bloc/map_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:provider/provider.dart';

class MyGoogleMap extends StatelessWidget {
  const MyGoogleMap({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MapBloc>(
              create: (BuildContext context) => MapBloc()),
        ],
        child: Builder(builder: (BuildContext context) {
          return Stack(children: <Widget>[
            Builder(builder: (BuildContext context) {
              LatLng center = context.watch<MapBloc>().currentLocation;
              preCenter = center;
              return center == null
                  ? Container()
                  : GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 17.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        Completer()..complete(controller);
                      },
                      markers: Set<Marker>.of(context.watch<MapBloc>().markers),
                    );
            }),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 50,
                        offset: Offset(0, 5),
                        spreadRadius: 50)
                  ],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      padding: EdgeInsets.all(6.0),
                      decoration: MyTheme.myPlateDecoration,
                      child: Row(
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
                                  .openAutoComplete(context),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "search destination",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xff4a4a4a)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 0, 10.0, 0),
                                    child: Icon(Icons.search),
                                  )
                                ],
                              ),
                            ),
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
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red),
                            child: Center(
                              child: Text(
                                "SOS",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    color: Color(0x00).withOpacity(.16),
                                    offset: Offset(0,
                                        0)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                                BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x00).withOpacity(.23),
                                    offset: Offset(0,
                                        1)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                              ],
                            ),
                            padding: EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 0,
                                          spreadRadius: 1,
                                          color: Color(0x00).withOpacity(.5),
                                          offset: Offset(0,
                                              0)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                                      BoxShadow(
                                          blurRadius: 0,
                                          spreadRadius: 1,
                                          color: Color(0x00).withOpacity(.05),
                                          offset: Offset(0,
                                              0)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      await context
                                          .read<MapBloc>()
                                          .goToCurrentLocation();
                                    },
                                    icon: Icon(
                                      Icons.my_location,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ))
          ]);
        }));
  }
}
