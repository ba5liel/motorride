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
                  SetChoosenOnMapBtn(),
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
            if (false)
              MyBottomSheet(
                child: Stack(
                  children: <Widget>[
                    StartTrip(),
                    if (false)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/loading.gif"),
                          )),
                          child: Center(
                              child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: MyTheme.primaryColor),
                                  child: Center(
                                      child: Text(
                                    "Requesting Driver",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )))),
                        ),
                      )
                  ],
                ),
              ),
            MyBottomSheet(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 7,
                        decoration: BoxDecoration(
                            color: Color(0xffdadce0),
                            borderRadius: BorderRadius.circular(8)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.timer, color: Color(0xffeeab05)),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "5:59",
                        style: TextStyle(
                            color: Color(0xffeeab05),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Min Remaining",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: Color(0xffeeab05).withOpacity(.3),
                                  offset: Offset(0,
                                      5)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                              BoxShadow(
                                  blurRadius: 18,
                                  color: Color(0xffeeab05).withOpacity(.5),
                                  offset: Offset(0,
                                      6)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                            ],
                            color: Color(0xffeeab05),
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.textsms,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Color(0xff04a56d),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/helmat2.png')),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  color: Color(0xff04a56d).withOpacity(.3),
                                  offset: Offset(0,
                                      5)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                              BoxShadow(
                                  blurRadius: 18,
                                  color: Color(0xff04a56d).withOpacity(.5),
                                  offset: Offset(0,
                                      6)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                            ],
                            color: Color(0xff04a56d),
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.phone,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Basliel Selamu",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (var i = 0; i < 4; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.star,
                            color: Color(0xffeeab05),
                            size: 15,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.star,
                          color: Color(0xffcccccc),
                          size: 15,
                        ),
                      ),
                      Text("4.7",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.red,
                      //onPressed: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Cancle",
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(Icons.close, color: Colors.white)
                        ],
                      ))
                ],
              ),
            ))
          ],
        ));
  }
}

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({Key key, @required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            /* image: DecorationImage(
              image: AssetImage('assets/images/motor2.jpg'),
              alignment: Alignment.bottomLeft), */
            boxShadow: [
              BoxShadow(
                  blurRadius: 16,
                  color: Color(0x00).withOpacity(.05),
                  offset: Offset(0,
                      -10)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
              BoxShadow(
                  blurRadius: 18,
                  color: Color(0x00).withOpacity(.075),
                  offset: Offset(0,
                      -12)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11), topRight: Radius.circular(11))),
        child: child);
  }
}

class RequestLoading extends StatefulWidget {
  RequestLoading({Key key}) : super(key: key);

  @override
  _RequestLoadingState createState() => _RequestLoadingState();
}

class _RequestLoadingState extends State<RequestLoading>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: AnimatedBuilder(
        animation:
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildContainer(100 * _controller.value),
              _buildContainer(200 * _controller.value),
              _buildContainer(300 * _controller.value),
              _buildContainer(400 * _controller.value),
              _buildContainer(500 * _controller.value),
              Align(child: Text("Requesting Driver")),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContainer(double radius) {
    return ClipRRect(
      //clipper: ,
      borderRadius: BorderRadius.circular(500),
      child: Transform.scale(
        scale: 2.3,
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(1 - _controller.value),
          ),
        ),
      ),
    );
  }
}

class StartTrip extends StatelessWidget {
  const StartTrip({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 7,
                decoration: BoxDecoration(
                    color: Color(0xffdadce0),
                    borderRadius: BorderRadius.circular(8)),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "21 min",
                style: TextStyle(color: Colors.green, fontSize: 22),
              ),
              Text(" (9.6Km)",
                  style: TextStyle(color: Colors.grey[600], fontSize: 22))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Drivers",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "10 Nearby",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("From",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.my_location,
                        size: 14,
                      ),
                      Text(
                        "Bethel Hospital",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("To",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w300)),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.my_location,
                        size: 14,
                      ),
                      Text(
                        "Bole AirPOrt",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Material(
                  child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xff3b78e7)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.navigation, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Start",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ))),
              SizedBox(
                width: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xffffff)),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.attach_money),
                    SizedBox(width: 3),
                    Text(
                      "600 br",
                      style: TextStyle(),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
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
                        context.read<MapBloc>().setChooseOnMap();
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
