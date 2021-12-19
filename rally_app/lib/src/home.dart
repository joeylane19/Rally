/**
 * Rally -- Let's get together.
 * Copyright (C) 2021 - Sean Murphy, Matt Finch, Joey Lane, & Will Hayward
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'auth.dart';
import 'widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'inviteinbox.dart';
import 'settings.dart';

class HomePage extends StatelessWidget {
  final String _profilePhoto;
  const HomePage({Key? key, required String profilePhoto})
      : _profilePhoto = profilePhoto,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          ImageUpload(
              user: FirebaseAuth.instance.currentUser != null
                  ? FirebaseAuth.instance.currentUser!.uid
                  : "",
              folder: "profile_photos/",
              profilePhoto: _profilePhoto),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              children: [
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  Header(FirebaseAuth.instance.currentUser!.displayName ??
                      "no name"),
                  const Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.grey,
                  ),
                ] else
                  Center(
                      child: ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text("Login to View Profile"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()));
                    },
                  )),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()));
                      },
                      icon: Icon(Icons.settings),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InviteInbox()));
                      },
                      icon: Icon(Icons.inbox),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageUpload extends StatefulWidget {
  ImageUpload(
      {required this.user, required this.folder, required this.profilePhoto});

  final String user;
  final String folder;
  final String profilePhoto;

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  static String imageUrl =
      "https://static.thenounproject.com/png/4291178-200.png";
  static NetworkImage nImage = NetworkImage(imageUrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: widget.profilePhoto == ""
                          ? nImage
                          : NetworkImage(widget.profilePhoto)),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      spreadRadius: 2,
                      blurRadius: 1,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        ElevatedButton(
          child: Text(
            "Upload Image",
            style: TextStyle(color: Colors.grey),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            textStyle: TextStyle(color: Colors.deepPurple, fontSize: 10),
          ),
          onPressed: () async {
            if (widget.user != "") {
              await uploadImage();
            }
          },
        ),
      ],
    );
  }

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    XFile? image;

    // Check Permissions
    await Permission.photos.request();

    //Select Image
    image = await _imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

    if (image != null) {
      var name = widget.user;
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child(widget.folder + name)
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        nImage = NetworkImage(imageUrl);
      });
    } else {}
  }
}
