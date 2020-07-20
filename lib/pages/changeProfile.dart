import 'package:flutter/material.dart';
import 'package:motorride/bloc/auth_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/user.dart';

class ChangeProfile extends StatelessWidget {
  ChangeProfile({Key key}) : super(key: key);
  final Authentication auth = new Authentication();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    firstNameController.text = RegExp(r'^([A-z]+\s+)([A-z]+)$')
        .allMatches(currentUser.name)
        .toList()[0]
        .group(1)
        .trim();

    lastNameController.text = RegExp(r'^([A-z]+\s+)([A-z]+)$')
        .allMatches(currentUser.name)
        .toList()[0]
        .group(2)
        .trim();

    return Scaffold(
        backgroundColor: MyTheme.bgColor,
        body: Form(
          key: formKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/pbg.png",
                    ),
                    fit: BoxFit.cover)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text("Change Profile",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(width: 50)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 16,
                              color: Color(0x00).withOpacity(.05),
                              offset: Offset(0,
                                  10)), //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                          BoxShadow(
                              blurRadius: 18,
                              color: Color(0x00).withOpacity(.075),
                              offset: Offset(0,
                                  12)) //0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 70,
                          ),
                          if (currentUser.phone == null)
                            Text("Phone Number is not set :/ Set it up"),
                          TextFormField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: "First your name",
                              labelStyle: TextStyle(color: Color(0xffcccccc)),
                              icon: Icon(
                                Icons.account_circle,
                                color: MyTheme.secondaryColor,
                              ),
                            ),
                            validator: (v) {
                              if (v.isEmpty) {
                                return "Your name is required";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              labelText: "Enter your father's name",
                              labelStyle: TextStyle(color: Color(0xffcccccc)),
                              icon: Icon(
                                Icons.supervised_user_circle,
                                color: MyTheme.secondaryColor,
                              ),
                            ),
                            validator: (v) {
                              if (v.isEmpty) {
                                return "Father's name is required";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          if (currentUser.phone == null)
                            TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v.isEmpty) {
                                    return "phone number is required";
                                  }
                                  if (!RegExp(r'^(\+?2519)|(09)([0-9]){8,8}$')
                                      .hasMatch(v)) {
                                    return "please enter a proper 'Phone number'";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Phone number",
                                  icon: Icon(
                                    Icons.call,
                                    color: MyTheme.secondaryColor,
                                  ),
                                  labelStyle:
                                      TextStyle(color: Color(0xffcccccc)),
                                )),
                          SizedBox(height: 10.0),
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            color: MyTheme.secondaryColor,
                            onPressed: () {
                              if (formKey.currentState.validate())
                                try {
                                  auth.updateUser(
                                      currentUser.userID,
                                      firstNameController.text,
                                      lastNameController.text,
                                      phoneController.text ?? currentUser.phone,
                                      currentUser.photo,
                                      context);
                                } catch (e) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(e.toString()),
                                    action: SnackBarAction(
                                        label: "ok",
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ));
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
                                'Update',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
