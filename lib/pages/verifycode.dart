import 'package:flutter/material.dart';
import 'package:motorride/constants/theme.dart';

class VerifyOTP extends StatelessWidget {
  VerifyOTP({Key key, this.callback}) : super(key: key);
  final Function(BuildContext, String) callback;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController codeController = TextEditingController();

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
                        height: 40,
                      ),
                      TextFormField(
                          controller: codeController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v.isEmpty) {
                              return "Enter your code please";
                            }
                            if (!RegExp(r'^([0-9]){4,6}$').hasMatch(v)) {
                              return "please enter a proper Code";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Verfication code",
                            icon: Icon(
                              Icons.verified_user,
                              color: MyTheme.secondaryColor,
                            ),
                            labelStyle: TextStyle(color: Color(0xffcccccc)),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(0),
                        color: MyTheme.secondaryColor,
                        onPressed: () {
                          if (!formKey.currentState.validate()) return;
                          callback(context, codeController.text.trim());
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
                            'Verify',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
