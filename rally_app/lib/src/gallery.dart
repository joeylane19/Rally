/**
 * Rally -- Let's get together.
 * Copyright (C) 2021 - Sean Murphy, Matt Finch, Joey Lane, & Will Hayward
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:flutter/cupertino.dart';

import 'addeventpage.dart';
import 'classes/eventclass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'auth.dart';
import 'addeventpage.dart';
import 'classes/imageupload.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'classes/imageupload.dart';

class GalleryPage extends StatelessWidget {
  GalleryPage({required this.eventId, required this.photos});

  final String eventId;
  List<String> photos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Photo Gallery'),
        ),
        body: ListView(
          children: [
            Gallery(eventId: eventId, photos: photos),
          ],
        ));
  }
}

class Gallery extends StatefulWidget {
  Gallery({required this.eventId, required this.photos});

  final String eventId;
  List<String> photos;

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GridView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // A grid view with 3 items per row
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemCount: widget.photos.length,
        itemBuilder: (BuildContext context, int index) =>
            Image.network(widget.photos[index]),
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
          uploadImage();
        },
      ),
    ]);
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
      String name = DateTime.now().toString();
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child('galleries/' + widget.eventId + '/' + name)
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        widget.photos.add(downloadUrl);
      });
    } else {}
  }
}
