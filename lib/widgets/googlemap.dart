import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/bloc/map_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/modals/user.dart';
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
          LatLng center = context.watch<MapBloc>().center;
          context
              .watch<MapBloc>()
              .sendLocation(currentUser.userID, center, keep: true);
          preCenter = center;
          List<Driver> drivers = context.watch<MapBloc>().drivers;
          drivers.add(new Driver("test")..setCords(new LatLng(55, 66)));
          return Stack(children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: context.watch<MapBloc>().center ??
                    LatLng(9.0336617, 38.7512801),
                zoom: 13.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                context.read<MapBloc>().completer.complete(controller);
              },
              markers: Set<Marker>.of(context.watch<MapBloc>().markers),
            ),
            Positioned(
                top: (MediaQuery.of(context).size.height / 2) - 50,
                left: 25,
                width: MediaQuery.of(context).size.width - 50,
                height: (MediaQuery.of(context).size.width / 2) - 50,
                child: GridView.builder(
                  itemCount: drivers.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 5.0,
                      child: new Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: new Text(
                          'd_ID ${drivers[index].id}\nLat ${drivers[index].cords.latitude}, Lat ${drivers[index].cords.longitude}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                )),
            Container(
              margin: EdgeInsets.only(top: 80),
              height: 60,
              decoration:
                  BoxDecoration(color: MyTheme.bgColor, boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 30,
                    spreadRadius: 15,
                    offset: Offset(0, 30),
                    color: MyTheme.bgColor)
              ]),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Select your pickup",
                        style: TextStyle(
                            fontSize: 20, color: MyTheme.primaryColor),
                      ),
                    ),
                    Text(
                      "unnamed road",
                      style: TextStyle(color: MyTheme.secondaryColor),
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
                          Icon(
                            Icons.my_location,
                            color: Colors.red,
                            size: 40,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                          padding: EdgeInsets.all(0),
                          color: MyTheme.secondaryColor,
                          onPressed: () {},
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "set pickup",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ))
                    ],
                  ),
                ))
          ]);
        }));
  }
}
