import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motorride/bloc/map_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/widgets/fogeffect.dart';
import 'package:motorride/widgets/setmarketcenter.dart';
import 'package:motorride/widgets/topnavbar.dart';
import 'package:provider/provider.dart';

class MyGoogleMap extends StatelessWidget {
  const MyGoogleMap({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<MapBloc>(
          create: (BuildContext context) => MapBloc()),
    ], child: AllStacks());
  }
}

class AllStacks extends StatelessWidget {
  const AllStacks({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Notify Listeerns called rebuilding !!\n\n\n");
    return Builder(builder: (context) {
      return MapBackground();
    });
  }
}

class MapBackground extends StatelessWidget {
  const MapBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("build again");
    LatLng center = context.select((MapBloc m) => m.currentLocation);
    preCenter = center;
    return Stack(children: <Widget>[
      center == null
          ? Container()
          : GoogleMap(
              //myLocationEnabled: true,
              mapType: MapType.normal,
              onCameraMove: (CameraPosition position) {
                context.read<MapBloc>().setCameraCenter(position.target);
              },
              initialCameraPosition: CameraPosition(
                target: center,
                zoom: 17.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                context.read<MapBloc>().setMapContoller = controller;
              },
              markers: Set<Marker>.of(context.select((MapBloc m) => m.markers)),
            ),
      FogEffect(),
      TopNavBar(),
      BottomNavBar(),
      SetMarketCenter()
    ]);
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                 if(context.select((MapBloc m) => m.destination) != null) ShowConformationBtn(),
                  ChooseOnMap(),
                  SizedBox(
                    height: 10,
                  ),
                  CloseChoosenOnMapBtn(),
                  SizedBox(
                    height: 10,
                  ),
                  SosAndMyLocationBtn(),
                ],
              ),
            ),
          ],
        ));
  }
}

class ChooseOnMap extends StatelessWidget {
  const ChooseOnMap({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SetChoosenOnMapBtn();
  }
}

class SosAndMyLocationBtn extends StatelessWidget {
  const SosAndMyLocationBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: Colors.red),
          child: Center(
            child: Text(
              "SOS",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
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
                  borderRadius: BorderRadius.all(Radius.circular(100)),
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
                    await context.read<MapBloc>().goToCurrentLocation();
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
    );
  }
}

class CloseChoosenOnMapBtn extends StatelessWidget {
  const CloseChoosenOnMapBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        AnimatedOpacity(
          duration: Duration(milliseconds: 800),
          curve: Curves.easeIn,
          opacity: context.select((MapBloc m) => m.showSetMarker) ==
                  SetMarketType.SHOW_NOTHING
              ? 0
              : 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(100)),
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
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 0,
                          spreadRadius: 1,
                          color: Color(0xffffffff).withOpacity(.5),
                          offset: Offset(0,
                              0)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                      BoxShadow(
                          blurRadius: 0,
                          spreadRadius: 1,
                          color: Color(0xffffffff).withOpacity(.05),
                          offset: Offset(0,
                              0)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                    ],
                  ),
                  child: IconButton(
                    onPressed: () async {
                      context.read<MapBloc>().closeChooseOnMap();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class SetChoosenOnMapBtn extends StatelessWidget {
  const SetChoosenOnMapBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Builder(builder: (context) {
          SetMarketType type = context.select((MapBloc m) => m.showSetMarker);
          return AnimatedOpacity(
            duration: Duration(milliseconds: 800),
            curve: Curves.easeIn,
            opacity: type == SetMarketType.SHOW_NOTHING ? 0 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: MyTheme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(100)),
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
                      color: MyTheme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 0,
                            spreadRadius: 1,
                            color: Color(0xffffffff).withOpacity(.5),
                            offset: Offset(0,
                                0)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                        BoxShadow(
                            blurRadius: 0,
                            spreadRadius: 1,
                            color: Color(0xffffffff).withOpacity(.05),
                            offset: Offset(0,
                                0)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                      ],
                    ),
                    child: IconButton(
                      onPressed: () async {
                        context.read<MapBloc>().setChooseOnMap(context);
                      },
                      icon: Icon(
                        type == SetMarketType.SHOW_PICKUP
                            ? Icons.location_on
                            : Icons.flag,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}

class ShowConformationBtn extends StatelessWidget {
  const ShowConformationBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Builder(builder: (context) {
          bool destinationIsSet =
              context.select((MapBloc m) => m.destinationAddress) == null;
          return AnimatedOpacity(
            duration: Duration(milliseconds: 800),
            curve: Curves.easeIn,
            opacity: destinationIsSet ? 0 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: MyTheme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(100)),
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
                      color: MyTheme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 0,
                            spreadRadius: 1,
                            color: Color(0xffffffff).withOpacity(.5),
                            offset: Offset(0,
                                0)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                        BoxShadow(
                            blurRadius: 0,
                            spreadRadius: 1,
                            color: Color(0xffffffff).withOpacity(.05),
                            offset: Offset(0,
                                0)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                      ],
                    ),
                    child: IconButton(
                      onPressed: () async {
                        context.read<MapBloc>().showConformationSheet(context);
                      },
                      icon: Icon(
                        Icons.navigation,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        })
      ],
    );
  }
}
