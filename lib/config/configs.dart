import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  RemoteConfig remoteConfig;
  void init() async {
    remoteConfig = await RemoteConfig.instance;

    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    remoteConfig.setDefaults(<String, dynamic>{
      'initialPrice': 8.0,
      'pricePerKilo': 10.0,
      'orderFeeOrder': .10,
      'baseUrl': "https://motorride.herokuapp.com",
    });
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 10));
      await remoteConfig.activateFetched();
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  String get baseUrl => remoteConfig.getString("baseUrl");
  static String googleMapApiKey = "AIzaSyAGbfIielNV8K0E1-mh7bkjTmkMOKNf_fs";
  static Duration requestRideTimeOut = Duration(minutes: 1);
  double get pricePerKilo => remoteConfig.getDouble('pricePerKilo');
  double get orderFeeOrder => remoteConfig.getDouble('orderFeeOrder');
  double get initialPrice => remoteConfig.getDouble('initialPrice');
  static double findRaduis = 3000;
}
