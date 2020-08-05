import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motorride/modals/triphistory.dart';
import 'package:motorride/pages/home.dart';
import 'package:motorride/util/alerts.dart';
import 'package:motorride/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motorride/modals/user.dart';

//616468
class Authentication {
  SharedPreferences _pref;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.email',
      "https://www.googleapis.com/auth/userinfo.profile",
      "https://www.googleapis.com/auth/admin.directory.user.readonly",
      "https://www.googleapis.com/auth/admin.directory.user"
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _codeController = new TextEditingController();
  FirebaseUser _user;

  Future<void> signOut() async {
    await getPref();
    _pref.remove("user");
    _pref.remove("online");
    _pref.remove("loggedIn");
  }

  Future<bool> isLoggedIn() async {
    await getPref();
    return _pref.getBool("loggedIn") ?? false;
  }

  Future<void> _setUser(User user) async {
    print("_setUse === Called");

    await getPref()
      ..setString("user", json.encode(user.toMap()));
    await _setLoggedIn(true);
    print(await isLoggedIn());
  }

  Future<void> _setLoggedIn(bool value) async {
    await getPref()
      ..setBool("loggedIn", value);
  }

  Future<User> getUser() async {
    currentUser =
        User.fromMap(json.decode((await getPref()).getString("user")));
    print("Current user seted");
    print(currentUser);
    return currentUser;
  }

  Future<bool> onPhoneSignIn(String phone, BuildContext context) async {
    showDialog(context: context, child: LoadingWidget());
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(minutes: 2),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);
          _user = result.user;
          if (_user != null) {
            await _createUser(_user, phone, context);
          } else {
            print("Error");
          }
        },
        verificationFailed: (AuthException exception) {
          Navigator.pop(context);
          print(
            exception.message,
          );
          showDialog(
              context: context,
              child: AlertDialog(
                title: Text("Sms Verification failed"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("please try again! ${exception.message}")
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("ok"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          Navigator.pop(context);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter your code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        try {
                          showDialog(context: context, child: LoadingWidget());
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.getCredential(
                                  verificationId: verificationId,
                                  smsCode: code);

                          AuthResult result =
                              await _auth.signInWithCredential(credential);

                          _user = result.user;

                          if (_user != null) {
                            await _createUser(_user, phone, context);
                          } else {
                            print("Error");
                          }
                        } catch (e) {
                          print("Error $e");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
    return _user != null;
  }

  Future<bool> onGoogleSignIn(BuildContext context, String phone) async {
    try {
      // show loading
      showDialog(context: context, child: LoadingWidget());
      FirebaseUser user = await _handleSignIn(context);
      await _createUser(user, phone, context);
      return true;
    } catch (e, t) {
      print(e);
      print(t);
      return false;
    }
  }

  Future updateUser(BuildContext context, User newUser,
      {bool saveTocloud = false, Function callBack}) async {
    if (saveTocloud)
      Firestore.instance
          .collection('users')
          .document(newUser.userID)
          .setData(currentUser.toMapCompact());
    currentUser = newUser;
    await _setUser(currentUser).then((value) {
      if (callBack != null) callBack(context);
    });
  }

  Future<SharedPreferences> getPref() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
    return _pref;
  }

  Future _createUser(
      FirebaseUser user, String phone, BuildContext context) async {
    if (user == null) {
      Alerts.showSnackBar(context, "Sign in failed");
      return;
    }

    List<TripHistory> tripHistories = [];
    TripHistory inProgress;
    List<DocumentSnapshot> requestHistory = (await Firestore.instance
            .collection('requests')
            .where('userID', isEqualTo: user.uid)
            .getDocuments())
        .documents;
    requestHistory.forEach((e) {
      TripHistory th = new TripHistory.fromMap({
        ...e.data,
        ...{"tripID": e.documentID}
      });
      th.completed == null && th.active == true && th.accepted == true
          ? inProgress = th
          : tripHistories.add(th);
    });
    currentUser = new User(
      photo: user.photoUrl,
      userID: user.uid,
      inProgressTrip: inProgress,
      tripHistories: tripHistories,
      name: user.displayName,
      phone: phone,
    );

    await Firestore.instance
        .collection('users')
        .document(currentUser.userID)
        .setData(
          currentUser.toMapCompact(),
        );
    await _setUser(currentUser).catchError((e, s) {
      print("Error: $e");
      print("s: $s");
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return HomePage(
        auth: this,
      );
    }));
  }

  Future<FirebaseUser> _handleSignIn(context) async {
    FirebaseUser user;
    try {
      bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        user = await _auth.currentUser();
      } else {
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        user = (await _auth.signInWithCredential(credential)).user;
      }
    } catch (e) {
      Alerts.showSnackBar(context, "Sign in failed, Check Internet Connection");
    }
    return user;
  }
}
