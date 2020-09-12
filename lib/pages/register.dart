import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:motorride/bloc/auth_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/util/alerts.dart';

class Register extends StatelessWidget {
  Register({Key key, this.auth}) : super(key: key);
  final Authentication auth;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final PhoneNumber _number = PhoneNumber(isoCode: 'ET');
  final TextEditingController phoneController = TextEditingController();
  final List<String> phoneNumber = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyTheme.primaryColor,
        body: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 18, 10, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  color: Colors.black38)
                            ]),
                        child: InternationalPhoneNumberInput(
                          inputDecoration: InputDecoration(
                              fillColor: Colors.white,
                              border: InputBorder.none),
                          onInputChanged: (PhoneNumber number) {
                            phoneNumber.add(number.phoneNumber);
                          },
                          ignoreBlank: false,
                          autoValidate: false,
                          initialValue: _number,
                          selectorTextStyle: TextStyle(color: Colors.black),
                          textFieldController: phoneController,
                          inputBorder: InputBorder.none,
                        ),
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(0),
                        color: MyTheme.secondaryColor,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            auth.onPhoneSignIn(
                                phoneNumber[phoneNumber.length - 1], context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                    color: Colors.black38)
                              ]),
                          width: double.infinity,
                          child: Text(
                            'SignUp',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              height: 2, width: 100.0, color: Colors.black38),
                          Text(
                            "OR",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                          Container(
                              height: 2, width: 100.0, color: Colors.black38)
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xff4285f4),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  color: Colors.black38)
                            ]),
                        child: Builder(builder: (context) {
                          return FlatButton(
                            padding: EdgeInsets.all(10),
                            onPressed: () async {
                              if (phoneNumber.length == 0 ||
                                  phoneNumber[phoneNumber.length - 1] == null ||
                                  !RegExp(r'^(\+?2519)|(09)([0-9]){8,8}$')
                                      .hasMatch(phoneNumber[
                                          phoneNumber.length - 1])) {
                                Alerts.showAlertDialog(
                                    context,
                                    "Invalid Phone Number",
                                    "Enter a valid Phonr Number in order to continue");
                                return;
                              }
                              bool signinsuccess = await auth.onGoogleSignIn(
                                  context,
                                  phoneNumber[phoneNumber.length - 1].trim());
                              print("signinsuccess $signinsuccess");
                              if (!signinsuccess) {
                                Navigator.pop(context);
                                Alerts.showSnackBar(
                                    context, "Sign In failed please try again");
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/google.png",
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  "Sign up with Google",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
