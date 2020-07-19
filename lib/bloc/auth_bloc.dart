import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motorride/pages/home.dart';
import 'package:motorride/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motorride/modals/user.dart';

class Authentication {
  SharedPreferences _pref;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/user.phonenumbers.read',
      'https://www.googleapis.com/auth/userinfo.email',
      "https://www.googleapis.com/auth/userinfo.profile"
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _codeController = new TextEditingController();
  FirebaseUser _user;

  void signOut() {}
  Future<bool> isLoggedIn() async {
    await getPref();
    return _pref.getBool("loggedIn") ?? false;
  }

  void _setUser(User user) async {
    await Firestore.instance
        .collection('users')
        .document(user.userID)
        .setData(user.toMap());
    await _setLoggedIn(true);
    await getPref()
      ..setString("user", json.encode(user.toMap()));
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
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);
          _user = result.user;
          if (_user != null) {
            _createUser(_user, context);
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
                  children: <Widget>[Text("please try again!")],
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
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);

                        AuthResult result =
                            await _auth.signInWithCredential(credential);

                        _user = result.user;

                        if (_user != null) {
                          _createUser(_user, context);
                        } else {
                          print("Error");
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

  Future<bool> onGoogleSignIn(BuildContext context) async {
    try {
      FirebaseUser user = await _handleSignIn();
      _createUser(user, context);
      return true;
    } catch (e, t) {
      print(e);
      print(t);
      return false;
    }
  }

  Future<SharedPreferences> getPref() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
    return _pref;
  }

  void _createUser(FirebaseUser user, BuildContext context) {
    currentUser = new User(
        userID: user.uid,
        name: user.displayName,
        phone: user.phoneNumber,
        rating: 5.0);
    _setUser(currentUser);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return HomePage();
    }));
  }

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user;

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
    return user;
  }
}
