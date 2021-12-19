/**
 * Rally -- Let's get together.
 * Copyright (C) 2021 - Sean Murphy, Matt Finch, Joey Lane, & Will Hayward
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'src/home.dart';
import 'src/events.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavMenu extends StatefulWidget {
  static const route = '/';
  @override
  State<StatefulWidget> createState() {
    return NavMenuState();
  }
}

class NavMenuState extends State<NavMenu> {
  int _currentIndex = 0;
  static String _profilePhoto = "";

  //String abtitle = 'Rally';
  static List<Widget> _children = [
    EventsPage(),
    HomePage(profilePhoto: _profilePhoto),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text(abtitle),
        backgroundColor: Colors.white,
      ),
      */
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.palette_rounded),
            label: 'events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'profile',
            //backgroundColor: Colors.white,
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account_rounded),
            label: 'groups',
            //backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'profile',
            //backgroundColor: Colors.white,
          )
          */
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black26,
      ),
    );
  }

  void onTabTapped(int index) async {
    if (index == 1 && FirebaseAuth.instance.currentUser != null) {
      var inst = FirebaseStorage.instance;
      var paths = await inst.ref().child('profile_photos/').listAll();
      print(paths.items);
      Iterable<String> photos = [];
      if (!paths.items.isEmpty) {
        photos = (paths.items.map((e) => e.fullPath));
        String url = 'profile_photos/' + FirebaseAuth.instance.currentUser!.uid;
        if (photos.contains(
            'profile_photos/' + FirebaseAuth.instance.currentUser!.uid)) {
          var profilePhoto = await inst.ref().child(url).getDownloadURL();
          setState(() {
            _profilePhoto = profilePhoto;
            _children = [
              EventsPage(),
              HomePage(profilePhoto: _profilePhoto),
            ];
          });
        }
      }
    }

    setState(() {
      _currentIndex = index;

      /*
      switch (index) {
        case 0:
          {
            abtitle = 'home';
          }
          break;
        case 1:
          {
            abtitle = 's3nds';
          }
          break;
        case 2:
          {
            abtitle = 'groups';
          }
          break;
        case 3:
          {
            abtitle = 'profile';
          }
          break;
      }
      */
    });
  }
}
