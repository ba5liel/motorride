import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motorride/modals/triphistory.dart';
import 'package:motorride/pages/home.dart';
import 'package:motorride/pages/verifycode.dart';
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
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  auth.User _user;

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
    print("get User called");
    currentUser =
        User.fromMap(json.decode((await getPref()).getString("user")));
    print("Current user seted ${currentUser.tripHistories}");
    Map<String, dynamic> data = (await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.userID)
            .get())
        .data();
    currentUser.setRating(data["rating"] ?? 3.5);
    return currentUser;
  }

  Future<bool> onPhoneSignIn(String phone, BuildContext context) async {
    showDialog(
        context: context,
        child: LoadingWidget(
          caption: "Verifying Number...",
        ));
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(minutes: 2),
        verificationCompleted: (auth.AuthCredential credential) async {
          try {
            auth.UserCredential result =
                await _auth.signInWithCredential(credential);
            _user = result.user;
            if (_user != null) {
              await _createUser(_user, phone, context);
            } else {
              print("Error");
            }
          } catch (e) {
            Navigator.pop(context);

            showDialog(
                context: context,
                child: AlertDialog(
                  title: Text("Sms Verification failed"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[Text("please try again! $e")],
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
          }
        },
        verificationFailed: (auth.FirebaseAuthException exception) {
          Navigator.pop(context);
          throw exception;
          print(exception);
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new VerifyOTP(
                          callback: (BuildContext context, String code) async {
                        if (!RegExp(r'^([0-9]){4,8}$').hasMatch(code)) {
                          Navigator.pop(context);
                          return;
                        }
                        showDialog(
                            context: context,
                            child: LoadingWidget(
                              caption: "Verifying OTP...",
                            ));
                        try {
                          auth.AuthCredential credential =
                              auth.PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);

                          auth.UserCredential result =
                              await _auth.signInWithCredential(credential);
                          _user = result.user;

                          if (_user != null) {
                            _createUser(_user, phone, context);
                          } else {
                            print("Error");
                          }
                        } catch (e) {
                          Alerts.showAlertDialog(context, "sign in failed",
                              "Session Expried please try again");
                          Navigator.pop(context);
                        }
                      })));
        },
        codeAutoRetrievalTimeout: (String vid) {
          if (currentUser != null) return;
          Navigator.pop(context);
          Alerts.showAlertDialog(
              context, "Time Out", "TIme out code auto retrieval");
          print("TIme out code auto retrieval");
        });
    return _user != null;
  }

  Future<bool> onGoogleSignIn(BuildContext context, String phone) async {
    try {
      // show loading
      showDialog(
          context: context,
          child: LoadingWidget(
            caption: "getting account..",
          ));
      auth.User user = await _handleSignIn(context);
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
      FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.userID)
          .set(currentUser.toMapCompact());
    currentUser = newUser;
    await _setUser(currentUser).then((value) {
      if (callBack != null) callBack(context);
    });
  }

  Future<SharedPreferences> getPref() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
    return _pref;
  }

  Future _createUser(auth.User user, String phone, BuildContext context) async {
    if (user == null) {
      Alerts.showSnackBar(context, "Sign in failed, try again");
      return;
    }
    print(user.uid);
    Map<String, dynamic> data = {};

    try {
      DocumentReference dataRef =
          FirebaseFirestore.instance.collection('drivers').doc(user.uid);
      print("DocumentReference \n\n error not thrown");
      DocumentSnapshot docSnap = await dataRef.get();
      if (docSnap.exists) data = docSnap.data();
    } catch (e) {
      print("Error creating user $e");
    } finally {
      List<TripHistory> tripHistories = [];
      TripHistory inProgress;
      List<DocumentSnapshot> requestHistory = (await FirebaseFirestore.instance
              .collection('requests')
              .where('userID', isEqualTo: user.uid)
              .get())
          .docs;
      requestHistory.forEach((e) {
        TripHistory th = new TripHistory.fromMap({
          ...e.data(),
          ...{"tripID": e.id}
        });
        th.completed == null && th.active == true && th.accepted == true
            ? inProgress = th
            : tripHistories.add(th);
      });
      currentUser = new User(
          photo: user.photoURL,
          userID: user.uid,
          inProgressTrip: inProgress,
          tripHistories: tripHistories,
          name: user.displayName,
          phone: phone,
          rating: data != null ? (data["rating"] ?? 3.5) : 3.5);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.userID)
          .set(
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
  }

  Future<auth.User> _handleSignIn(context) async {
    auth.User user;
    try {
      bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        user = _auth.currentUser;
      } else {
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final auth.AuthCredential credential =
            auth.GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken);
        user = (await _auth.signInWithCredential(credential)).user;
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      Alerts.showSnackBar(context, "Sign in failed, Check Internet Connection");
    }
    return user;
  }
}
