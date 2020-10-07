import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  RemoteConfig remoteConfig;
  Future init() async {
    remoteConfig = await RemoteConfig.instance;

    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    remoteConfig.setDefaults(<String, dynamic>{
      'initialPrice': 8.0,
      'pricePerKilo': 10.0,
      'maxradius': 3,
      'orderFeeOrder': .10,
      'free': false,
      'promot': false,
      'youtubechannel':
          "www.youtube.com/channel/UCHw0GdCl8YWzFSqreOIOckw?view_as=subscriber",
      'telegrambot': "t.me/Motorridebot",
      'contact2': "+25154920304",
      'contact1': "+25154920304",
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
  String get youtubechannel => remoteConfig.getString("youtubechannel");
  String get telegrambot => remoteConfig.getString("telegrambot");
  String get contact1 => remoteConfig.getString("contact1");
  String get contact2 => remoteConfig.getString("contact2");
  static String googleMapApiKey = "AIzaSyAGbfIielNV8K0E1-mh7bkjTmkMOKNf_fs";
  double get maxRadius => remoteConfig.getDouble("maxradius");
  static Duration requestRideTimeOut = Duration(minutes: 1);
  double get pricePerKilo => remoteConfig.getDouble('pricePerKilo');
  double get orderFeeOrder => remoteConfig.getDouble('orderFeeOrder');
  double get initialPrice => remoteConfig.getDouble('initialPrice');
  bool get promot => remoteConfig.getBool('promot');
  static double findRaduis = 3000;
}
