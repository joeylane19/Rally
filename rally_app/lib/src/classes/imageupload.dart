/**
 * Rally -- Let's get together.
 * Copyright (C) 2021 - Sean Murphy, Matt Finch, Joey Lane, & Will Hayward
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUpload extends StatefulWidget {
  ImageUpload(
      {required this.dateTime,
      required this.folder,
      required this.originalUrl});

  final String dateTime;
  final String folder;
  final String originalUrl;

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  // String imageUrl;
  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Text(
            "Upload Image",
            style: TextStyle(color: Colors.grey),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            textStyle: TextStyle(color: Colors.deepPurple, fontSize: 10),
          ),
          onPressed: () {
            uploadImage();
          },
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
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
                  child: (imageUrl != "")
                      ? Image.network(imageUrl)
                      : Image.network(widget.originalUrl)),
            ],
          ),
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
      var name = widget.dateTime;
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child(widget.folder + name)
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {}
  }
}
