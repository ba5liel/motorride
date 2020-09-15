import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:motorride/bloc/auth_bloc.dart';
import 'package:motorride/bloc/listeners_bloc.dart';
import 'package:motorride/bloc/server_bloc.dart';
import 'package:motorride/bloc/trip_bloc.dart';
import 'package:motorride/config/configs.dart';
import 'package:motorride/modals/driver.dart';
import 'package:motorride/modals/trip.dart';
import 'package:motorride/modals/triphistory.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/pages/completepage.dart';
import 'package:motorride/services/service_locator.dart';
import 'package:motorride/util/alerts.dart';
import 'package:motorride/util/formulas.dart';
import 'package:google_maps_webservice/places.dart' as wsp;
import 'package:google_maps_webservice/geocoding.dart' as gc;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart' as gc;
import 'package:motorride/widgets/confirmationBottomSheet.dart';
import 'package:motorride/widgets/driverinfobootmsheet.dart';
import 'package:motorride/widgets/requestloadingbottomsheet.dart';
import 'package:motorride/pages/canclepage.dart';

LatLng preCenter = LatLng(9.0336617, 38.7512801);
enum SetMarketType { SHOW_PICKUP, SHOW_DESTINATION, SHOW_NOTHING }

class MapBloc with ChangeNotifier, NodeServer, TripBloc, MyListeners {
  MapBloc(this.context, this.auth) {
    init();
    notifyListeners();
  }
  final Authentication auth;
  BuildContext context;
  gc.Geolocator _geolocator = new gc.Geolocator();
  Location _location = new Location();
  LatLng _currentLocation;
  LatLng _destination;
  LatLng get destination => _destination;
  LatLng get pickup => _pickup;
  String destinationAddress;
  LatLng _pickup;
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  String pickupAddress = "your Location";
  List<Marker> _markers = List();
  bool _permission = false;
  wsp.Prediction _prediction;
  List<Marker> get markers => _markers;
  LatLng get currentLocation => _currentLocation;
  String address = "unnamed road";
  double tilt;
  GoogleMapController mapContoller;
  SetMarketType showSetMarker = SetMarketType.SHOW_NOTHING;
  LatLng _cameraCenter;
  StreamSubscription<List<dynamic>> roomChangeSubscription;
  BitmapDescriptor youicon;
  BitmapDescriptor drivericon;
  BitmapDescriptor destIcon;
  BitmapDescriptor pickupIcon;
  bool tripInProgress = false;
  final FirebaseMessaging _fcm = locator<FirebaseMessaging>();
  final Config _config = locator<Config>();

  wsp.GoogleMapsPlaces _places =
      new wsp.GoogleMapsPlaces(apiKey: Config.googleMapApiKey);

  set setMapContoller(GoogleMapController c) {
    print('++++++++++GoogleMapController======== settted');
    mapContoller = c;
  }

  void init() async {
    try {
      preCenter = LatLng(9.0336617, 38.7512801);
      await initializeIcons();
      await initializeCurrentLocation();
      _addYouMarker();
      notifyListeners();
      print("initializeCurrentLocation $currentLocation");
      _geolocator
          .placemarkFromCoordinates(
              _currentLocation.latitude, _currentLocation.longitude)
          .catchError((e) {
        print("placemarkFromCoordinates carp his pants again");
      }).then((value) {
        address = value[0].name;
        print(address);
        notifyListeners();
      });
    } catch (e) {
      Alerts.showSnackBar(context, "No Internet Connection!");
    } finally {
      await _config.init();
      print("MapBloc Initalized ${_config.initialPrice}");
      sendLocation(currentUser.userID, _currentLocation, context);
      if (currentUser.inProgressTrip == null) listenToRoomChanges();
      //listen for my location change
      listenToLocationChange();
      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );
      _fcm.subscribeToTopic("announcementuser");
      // listen to rooms
    }
  }

  Future<void> loadPreviousTrip() async {
    if (currentUser.inProgressTrip != null) {
      print(
          "currentUser.inProgressTrip.trip.complete ${currentUser.inProgressTrip.trip.complete}");
      print("currentUser.inProgressTrip ${currentUser.inProgressTrip}");
      currentUser.inProgressTrip.trip.cancle = goToCanclationPage;
      currentUser.inProgressTrip.trip.complete = goToCompletePage;
      closeDriverListerner();
      print(
          "currentUser.inProgressTrip.polys ${currentUser.inProgressTrip.polys}");
      _pickup = currentUser.inProgressTrip.trip.pickup;
      _destination = currentUser.inProgressTrip.trip.destination;
      listenToTripDriver(showDriverTripLocationOnMap);
      if (currentUser.inProgressTrip.phase == TRIPPHASES.FROMLOCATIONTOPICKUP) {
        showRoute(currentUser.inProgressTrip.polys,
            currentUser.inProgressTrip.trip.pickup, _currentLocation,
            isDest: false, callback: () {
          mapContoller.animateCamera(CameraUpdate.newLatLngBounds(
              MyFormulas.boundsFromLatLngList([
                _currentLocation,
                currentUser.inProgressTrip.trip.pickup,
              ]),
              100));

          tripInProgress = true;
          notifyListeners();
        });
      } else {
        showRoute(currentUser.inProgressTrip.polys,
            currentUser.inProgressTrip.trip.destination, _currentLocation,
            isDest: true, callback: () {
          showBothMarkers(currentUser.inProgressTrip.trip.pickup,
              currentUser.inProgressTrip.trip.destination);
          mapContoller.animateCamera(CameraUpdate.scrollBy(0, 30));
          mapContoller.animateCamera(CameraUpdate.newLatLngBounds(
              MyFormulas.boundsFromLatLngList([
                _currentLocation,
                currentUser.inProgressTrip.trip.destination,
              ]),
              150));
          tripInProgress = true;

          notifyListeners();
        });
      }
    }
  }

  void showBothMarkers(LatLng pickup, LatLng dest) {
    showPickUpMarker(pickup);
    showDestinationMarker(dest);
  }

  void showPickUpMarker(LatLng pickup) {
    _markers.add(new Marker(
        zIndex: 9999,
        position: pickup,
        icon: pickupIcon,
        markerId: MarkerId("pickup"),
        infoWindow: InfoWindow(
            title: "Pick Up",
            snippet: "Your Pick Up location",
            onTap: () {
              print("request driver");
            })));
    mapContoller.animateCamera(CameraUpdate.newLatLng(
      pickup,
    ));
    mapContoller.animateCamera(CameraUpdate.scrollBy(0, 30));
  }

  void showDestinationMarker(LatLng dest) {
    _markers.add(new Marker(
        zIndex: 9999,
        position: dest,
        icon: destIcon,
        markerId: MarkerId("dest"),
        infoWindow: InfoWindow(
            title: "Destination",
            snippet: "Your Pick Up location",
            onTap: () {
              print("request driver");
            })));
    mapContoller.animateCamera(CameraUpdate.newLatLngBounds(
        MyFormulas.boundsFromLatLngList([
          _currentLocation,
          dest,
        ]),
        150));
    mapContoller.animateCamera(CameraUpdate.scrollBy(0, 30));
  }

  listenToLocationChange() {
    _location.onLocationChanged.listen((event) async {
      _currentLocation = LatLng(event.latitude, event.longitude);
      if (_currentLocation != null &&
          preCenter != null &&
          _currentLocation != preCenter &&
          MyFormulas.getDistanceFromLatLonInKm(
                  _currentLocation.latitude,
                  _currentLocation.longitude,
                  preCenter.latitude,
                  preCenter.longitude) >
              0.05) {
        try {
          preCenter = _currentLocation;
          print("listenToLocationChange therefore i changed sent my location");
          await sendLocation(currentUser.userID, _currentLocation, context);
          address = (await _geolocator.placemarkFromCoordinates(
                  _currentLocation.latitude, _currentLocation.longitude))[0]
              .name;
          print(address);
          _markers.removeWhere(
              (element) => element.markerId.value == currentUser.userID);
          _addYouMarker();
        } catch (e) {
          Alerts.showSnackBar(context, "No Internet Connection!");
        }
      }
    });
  }

  Future initializeIcons() async {
    youicon = BitmapDescriptor.fromBytes(
        await MyFormulas.getBytesFromAsset("assets/images/user_place.png", 50));
    drivericon = BitmapDescriptor.fromBytes(
        await MyFormulas.getBytesFromAsset("assets/images/motor_icon.png", 50));
    destIcon = BitmapDescriptor.fromBytes(await MyFormulas.getBytesFromAsset(
        "assets/images/user_place_destination4.png", 100));
    pickupIcon = BitmapDescriptor.fromBytes(
        await MyFormulas.getBytesFromAsset("assets/images/pickup.png", 100));
  }

  Future initializeCurrentLocation() async {
    await changeLocationSetting(accuracy: LocationAccuracy.high, interval: 0);
    _currentLocation = await getCurrentLocation();
    if (_currentLocation == null) {
      Alerts.showSnackBar(context, "can't get location");
      _currentLocation = await getCurrentLocation();
    }
  }

  void listenToRoomChanges() {
    roomChangeSubscription = roomController.stream.listen((rooms) async {
      print("======== Room Stream returned a value =========== $rooms");
      if (rooms != null && rooms.length > 0) {
        listenToDrivers(rooms, showDriversLocationOnMap);
      }
    });
  }

  showDriverTripLocationOnMap(DocumentSnapshot doc) {
    drivers = [];
    LatLng newCords = new LatLng(doc.data["lat"], doc.data["lng"]);
    drivers.add(new Driver.fromMap(doc.data)..setCords(newCords));
    showAllMarkers();
    notifyListeners();
  }

  showDriversLocationOnMap(QuerySnapshot docs) async {
    print("CHange Detected in DATABase\n");
    print(docs.documents);
    _markers = [];
    drivers = [];
    docs.documents.forEach((doc) async {
      if (doc.data["online"] == false || doc.data["available"] == false) {
        return;
      }
      print(doc.data);
      print(doc.data["online"]);

      LatLng newCords = new LatLng(doc.data["lat"], doc.data["lng"]);

      drivers.add(new Driver.fromMap(doc.data)..setCords(newCords));
    });
    print(drivers);

    showAllMarkers();
    notifyListeners();
  }

  void showAllMarkers() {
    _addYouMarker();
    _markers = [..._markers]..addAll(drivers
        .map((Driver e) => new Marker(
            zIndex: 9999,
            position: e.cords,
            icon: drivericon,
            markerId: MarkerId(e.userID),
            infoWindow: InfoWindow(title: "Motorride Driver", onTap: () {})))
        .toList());
    if (_pickup != null) showPickUpMarker(_pickup);
    if (_destination != null) showDestinationMarker(_destination);
  }

  void closeRoomChangeListener() {
    if (roomChangeSubscription != null) roomChangeSubscription.cancel();
  }

  Future<void> changeLocationSetting(
      {LocationAccuracy accuracy, int interval}) async {
    await _location.changeSettings(accuracy: accuracy, interval: interval);
  }

  Future<void> goToCurrentLocation() async {
    if (_currentLocation == null) await getCurrentLocation();
    tilt = tilt == 90 ? 0 : 90;
    mapContoller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: 17.0, tilt: tilt),
      ),
    );
    print("goToCurrentLocation called notifyListeners()");
  }

  Future<LatLng> getCurrentLocation() async {
    LocationData location;
    try {
      bool serviceStatus = await _location.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission =
            (await _location.requestPermission() == PermissionStatus.granted);
        print("Permission: $_permission");
        if (_permission) {
          location = await _location
              .getLocation()
              .timeout(Duration(seconds: 10), onTimeout: () {
            return null;
          });
          print(location);
          return location == null
              ? null
              : LatLng(location.latitude, location.longitude);
        }
      } else {
        bool serviceStatusResult = await _location.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          return getCurrentLocation();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
      } else if (e.code == 'SERVICE_STATUS_ERROR') {}
      //location = null;
    }
    return null;
  }

  void openAutoCompleteFrom(BuildContext context) async {
    try {
      _prediction = await PlacesAutocomplete.show(
        logo: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _pickup = _currentLocation;
                setPickUp();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xffe8f0fe),
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.my_location,
                          color: Color(0xff1a73e8),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Your Location'),
                        Divider(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                choosePickUpLocationOnMap();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xffe8eaed),
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.map,
                          color: Color(0xff3c4043),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Choose on Map',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onError: (e) {
          print("Error-e\n\n\n");
          print(e.hasNoResults);
          print(e.errorMessage);
        },
        context: context,
        apiKey: Config.googleMapApiKey,
        mode: Mode.overlay, // Mode.overlay
        language: "en",
        components: [wsp.Component(wsp.Component.country, "et")],
      );
      if (_prediction != null) {
        //Same API_KEY as above
        wsp.PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(_prediction.placeId);

        pickupAddress = _prediction.description;
        _pickup = new LatLng(detail.result.geometry.location.lat,
            detail.result.geometry.location.lng);
        setPickUp();
        notifyListeners();
      }
    } catch (e, t) {
      print(e);
      print(t);
    }
  }

  void openAutoCompleteTo(BuildContext context) async {
    try {
      _prediction = await PlacesAutocomplete.show(
        logo: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                chooseDestinationLocationOnMap();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Color(0xffe8eaed),
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.map,
                          color: Color(0xff3c4043),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Choose on Map',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onError: (e) {
          print("Error-e\n\n\n");
          print(e.hasNoResults);
          print(e.errorMessage);
        },
        context: context,
        apiKey: Config.googleMapApiKey,
        mode: Mode.overlay, // Mode.overlay
        language: "en",
        components: [wsp.Component(wsp.Component.country, "et")],
      );
      if (_prediction != null) {
        wsp.PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(_prediction.placeId);
        print(_prediction.description);
        destinationAddress = _prediction.description;
        _destination = new LatLng(detail.result.geometry.location.lat,
            detail.result.geometry.location.lng);
        setDestination(context);
      }
    } catch (e, t) {
      print(e);
      print(t);
      throw e;
    }
  }

  void setPickUp() {
    print("setPick up Called");
    _markers.removeWhere((element) => element.markerId.value == "pickup");

    _markers = [..._markers]..add(new Marker(
        zIndex: 9999,
        position: _pickup,
        icon: pickupIcon,
        markerId: MarkerId("pickup"),
        infoWindow: InfoWindow(
            title: "Pick Up",
            snippet: "Your Pick Up location",
            onTap: () {
              print("request driver");
            })));
    mapContoller.animateCamera(CameraUpdate.newLatLngBounds(
        MyFormulas.boundsFromLatLngList([
          _currentLocation,
          _pickup,
          if (_destination != null) _destination
        ]),
        100));

    notifyListeners();
  }

  Future<void> showRoute(List<dynamic> polys, LatLng origin, LatLng dest,
      {bool isDest, Function callback}) async {
    polylinePoints = PolylinePoints();
    // Generating the list of coordinates to be used for
    // drawing the polylines
    // Adding the coordinates to the list
    if (polys.isNotEmpty) {
      polys.forEach((point) {
        polylineCoordinates.add(LatLng(point["lat"], point["lng"]));
      });
    }
    // Defining an ID
    PolylineId id = PolylineId(isDest ? 'dest' : 'pickup');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: isDest ? Colors.blue : Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
    print(polylines);
    mapContoller.animateCamera(CameraUpdate.newLatLngBounds(
        MyFormulas.boundsFromLatLngList([origin, dest]), 80));
    if (callback != null) {
      callback();
    }
    notifyListeners();
  }

  Future<void> requestRide(BuildContext context, Trip trip) async {
    closeRoomChangeListener();
    closeDriverListerner();
    await request(trip, (TripHistory th) {
      auth.updateUser(context, currentUser..setInProgressTrip(th),
          callBack: (context) {
        currentUser.inProgressTrip.trip.complete = goToCompletePage;

        listenToTripDriver(showDriverTripLocationOnMap);
        Navigator.pop(context);
        showRoute(
            currentUser.inProgressTrip.polys, trip.driver.cords, trip.pickup,
            isDest: false);
        tripInProgress = true;
        notifyListeners();
        showBottomSheet(
            context: context,
            builder: (context) => Wrap(children: [
                  DriverInfoBottomSheet(
                    trip: currentUser.inProgressTrip.trip,
                    cancleTrip: (BuildContext context) {
                      print("cancleTrip");
                      goToCanclationPage(context);
                    },
                  )
                ]));
      });
    }, () async {
      closeRoomChangeListener();
      roomChangeSubscription.resume();
      await auth.updateUser(
          context,
          currentUser
            ..addHistory(currentUser.inProgressTrip)
            ..setInProgressTrip(null));
      tripInProgress = false;
      Navigator.pop(context);
      Alerts.showAlertDialog(context, "Service Unavailabe in you're region",
          "Sorry We can not provide our service at this time please try again later");
      notifyListeners();
    }, (TripHistory th) {
      auth.updateUser(context, currentUser..setInProgressTrip(th),
          callBack: () {
        showRoute(
            currentUser.inProgressTrip.polys, trip.driver.cords, trip.pickup,
            isDest: false);
        Alerts.showAlertDialog(context, "Your driver has arrived",
            "meet your driver at the pick up location");
        notifyListeners();
      });
    });
  }

  void cancleRoute() {
    polylinePoints = null;
    polylineCoordinates = [];
    polylines = {};
    mapContoller.animateCamera(CameraUpdate.newLatLng(_currentLocation));
    _markers = [];
    _addYouMarker();
    tripInProgress = false;
  }

  void goToCanclationPage(BuildContext context) {
    print("goToCanclationPage");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CanclePage(
                  cancle: (String why) async {
                    await auth.updateUser(
                        context,
                        currentUser
                          ..addHistory(currentUser.inProgressTrip)
                          ..setInProgressTrip(null));
                    tripInProgress = false;
                    cancleRoute();
                    Navigator.pop(context);
                    closeDriverTripListerner();
                    resumeDriverStream();
                    cancleTrip(why);
                    notifyListeners();
                  },
                )));
  }

  void goToCompletePage(BuildContext context) {
    Navigator.pop(context);
    Driver d = currentUser.inProgressTrip.trip.driver;
    auth.updateUser(
        context,
        currentUser
          ..addHistory(currentUser.inProgressTrip..setComplete(true))
          ..setInProgressTrip(null));
    tripInProgress = false;
    cancleRoute();
    _markers = [];
    _addYouMarker();
    closeDriverTripListerner();
    resumeDriverStream();
    notifyListeners();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CompletePage(
                  driver: d,
                )));
  }

  void resumeDriverStream() {
    if (driversStream != null) {
      driversStream.resume();
    } else {
      listenToRoomChanges();
    }
  }

  Future<void> setDestination(BuildContext context) async {
    _markers.removeWhere((element) => element.markerId.value == "destination");
    _markers = [..._markers]..add(new Marker(
        zIndex: 9999,
        position: _destination,
        icon: BitmapDescriptor.fromBytes(await MyFormulas.getBytesFromAsset(
            "assets/images/user_place_destination4.png", 100)),
        markerId: MarkerId("destination"),
        infoWindow: InfoWindow(
            title: "Destination",
            onTap: () {
              print("request driver");
            })));
    mapContoller.animateCamera(CameraUpdate.newLatLngBounds(
        MyFormulas.boundsFromLatLngList(
            [_currentLocation, _destination, if (_pickup != null) _pickup]),
        100));
    notifyListeners();
    showConformationSheet(context);
  }

  void showConformationSheet(BuildContext context) async {
    if (drivers.length == 0)
      return Alerts.showAlertDialog(
          context,
          "Service Unavailabe in you're region",
          "Sorry We can not provide our service at this time please try again later");
    showBottomSheet(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: RequestLoadingBottomSheet(
                msg: "Gathering Info",
              ),
            ));
    try {
      Map<String, dynamic> eTA =
          await calculateETA(_pickup ?? _currentLocation, _destination);
      trip = new Trip(
          pickup: _pickup ?? _currentLocation,
          destination: _destination,
          user: currentUser,
          tripDistance: eTA['distance']["value"] / 1,
          tripDistanceText: eTA['distance']["text"],
          eTA: eTA["duration"]["value"] / 1,
          arravialETA: eTA["duration"]["text"],
          pickupAddress: pickupAddress ?? address,
          destinationAddress: destinationAddress,
          nubmersOfDrivers: drivers.length,
          amount: (eTA['distance']["value"] * _config.pricePerKilo / 1000) +
              _config.initialPrice);
      sortDriverByShortestDistance(_pickup ?? _currentLocation, trip.amount);
      Navigator.pop(context);
      showBottomSheet(
          context: context,
          builder: (context) =>
              ConfirmationBottomSheet(trip: trip, requestRide: requestRide));
    } catch (e) {
      print(e);
      Navigator.pop(context);
      Alerts.showAlertDialog(context, "Gathering Info Failed",
          "This is due to network connection. Please try again");
    }
  }

  void setCameraCenter(LatLng pos) {
    _cameraCenter = pos;
  }

  void setChooseOnMap(BuildContext context) async {
    print("setChooseOnMap");
    try {
      if (showSetMarker == SetMarketType.SHOW_PICKUP) {
        print("pick up choosen");
        _pickup = _cameraCenter;
        showSetMarker = SetMarketType.SHOW_NOTHING;
        pickupAddress = (await _geolocator.placemarkFromCoordinates(
                _pickup.latitude, _pickup.longitude))[0]
            .name;
        setPickUp();
      }
      if (showSetMarker == SetMarketType.SHOW_DESTINATION) {
        print("Destination choosen");
        _destination = _cameraCenter;
        showSetMarker = SetMarketType.SHOW_NOTHING;
        destinationAddress = (await _geolocator.placemarkFromCoordinates(
                _destination.latitude, _destination.longitude))[0]
            .name;
        await setDestination(context);
      }
    } catch (e) {
      print(e);
      Alerts.showSnackBar(context, "Fetch address name failed");
      destinationAddress = "Unamed Road";
      await setDestination(context);
    }
  }

  void choosePickUpLocationOnMap() {
    showSetMarker = SetMarketType.SHOW_PICKUP;
    notifyListeners();
  }

  void chooseDestinationLocationOnMap() {
    showSetMarker = SetMarketType.SHOW_DESTINATION;
    notifyListeners();
  }

  void closeChooseOnMap() {
    showSetMarker = SetMarketType.SHOW_NOTHING;
    notifyListeners();
  }

  Marker _addYouMarker() {
    Marker user = new Marker(
        zIndex: 999,
        icon: youicon,
        position: _currentLocation,
        markerId: MarkerId(currentUser.name ?? currentUser.phone),
        infoWindow: InfoWindow(title: "You", onTap: () {}));
    _markers.add(user);
    return user;
  }
}
