import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motorride/bloc/auth_bloc.dart';
import 'package:motorride/constants/theme.dart';
import 'package:motorride/modals/user.dart';
import 'package:motorride/pages/home.dart';

class ChangeProfile extends StatelessWidget {
  ChangeProfile({Key key}) : super(key: key);
  final Authentication auth = new Authentication();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    firstNameController.text = currentUser.name == null
        ? null
        : RegExp(r'^([A-z]+\s+)([A-z]+)$')
            .allMatches(currentUser.name)
            .toList()[0]
            .group(1)
            .trim();

    lastNameController.text = currentUser.name == null
        ? null
        : RegExp(r'^([A-z]+\s+)([A-z]+)$')
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
                          ChangeProfilePicture(),
                          SizedBox(
                            height: 15,
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
                                      context,
                                      currentUser
                                        ..setName(firstNameController.text,
                                            lastNameController.text)
                                        ..setPhone(phoneController.text ??
                                            currentUser.phone)
                                        ..setPhoto(currentUser.photo),
                                      saveTocloud: true, callBack: (context) {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return HomePage(
                                        auth: auth,
                                      );
                                    }));
                                  });
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

class ChangeProfilePicture extends StatefulWidget {
  const ChangeProfilePicture({
    Key key,
  }) : super(key: key);

  @override
  _ChangeProfilePictureState createState() => _ChangeProfilePictureState();
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
        toolbarColor: Colors.deepOrangeAccent,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It');

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://acquired-rite-283713.appspot.com');

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  void _startUpload() {
    /// Unique file name for the file
    String filePath = 'images/${currentUser.userID}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          decoration: MyTheme.avatarDecoration,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: (_imageFile != null)
                ? FileImage(_imageFile)
                : currentUser.photo != null
                    ? NetworkImage(currentUser.photo)
                    : AssetImage("assets/images/user.png"),
          ),
        ),
        Column(children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () => _pickImage(ImageSource.camera)),
              IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery)),
            ],
          ),
          if (_imageFile != null)
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),
          if (_imageFile != null) ...[
            if (_uploadTask != null)

              /// Manage the task state and event subscription with a StreamBuilder
              StreamBuilder<StorageTaskEvent>(
                  stream: _uploadTask.events,
                  builder: (_, snapshot) {
                    var event = snapshot?.data?.snapshot;

                    if (_uploadTask.isComplete) {
                      _storage
                          .ref()
                          .child('images/${currentUser.userID}.png')
                          .getDownloadURL()
                          .then((value) {
                        print("\n\n\nDownloadble URL $value");
                        currentUser.setPhoto(value);
                        Firestore.instance
                            .collection("drivers")
                            .document(currentUser.userID)
                            .updateData({"photo": value});
                      });
                    }
                    double progressPercent = event != null
                        ? event.bytesTransferred / event.totalByteCount
                        : 0;
                    print(progressPercent);
                    return Container(
                      //height: 10,

                      child: Column(
                        children: [
                          if (_uploadTask.isComplete) Text('🎉🎉🎉'),
                          if (_uploadTask.isPaused)
                            FlatButton(
                              child: Icon(Icons.play_arrow),
                              onPressed: _uploadTask.resume,
                            ),

                          if (_uploadTask.isInProgress)
                            FlatButton(
                              child: Icon(Icons.pause),
                              onPressed: _uploadTask.pause,
                            ),

                          // Progress bar
                          Container(
                              width: 100,
                              height: 10,
                              child: LinearProgressIndicator(
                                  value: progressPercent)),
                          Text(
                              '${(progressPercent * 100).toStringAsFixed(2)} % '),
                        ],
                      ),
                    );
                  }),
            if (_uploadTask == null)
              FlatButton.icon(
                label: Text('Upload'),
                icon: Icon(Icons.cloud_upload),
                onPressed: _startUpload,
              ),
          ],
        ]),
      ],
    );
  }
}
