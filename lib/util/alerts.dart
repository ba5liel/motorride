import 'package:flutter/material.dart';

class Alerts {
  static void showSnackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(label: "ok", onPressed: () {}),
    ));
  }

  static showAlertDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static void showPromptDialog(
      BuildContext context, String title, Widget msg, Function callback) {
    Widget okButton = FlatButton(
      child: Text("yes"),
      onPressed: () {
        callback();
      },
    );
    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: msg,
      actions: [okButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
