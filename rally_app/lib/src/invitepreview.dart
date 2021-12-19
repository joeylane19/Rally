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
import 'package:rally_app/src/widgets.dart';

import 'classes/messageclass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../main.dart';
import 'auth.dart';
import 'classes/eventclass.dart';
import 'dart:async';
import 'editeventpage.dart';
import 'members.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class InvitePreview extends StatelessWidget {
  final String _eventid;

  const InvitePreview({
    Key? key,
    required String eventid,
  })  : _eventid = eventid,
        super(key: key);

  String convertToDay(String dateString) {
    return int.parse(dateString.substring(8)).toString();
  }

  String convertToMonth(String dateString) {
    switch (int.parse(dateString.substring(5, 7))) {
      case 1:
        return "JAN";
      case 2:
        return "FEB";
      case 3:
        return "MAR";
      case 4:
        return "APR";
      case 5:
        return "MAY";
      case 6:
        return "JUN";
      case 7:
        return "JUL";
      case 8:
        return "AUG";
      case 9:
        return "SEP";
      case 10:
        return "OCT";
      case 11:
        return "NOV";
      case 12:
        return "DEC";
    }
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Consumer<ApplicationState>(
      builder: (context, appState, _) => Column(
        children: [
          for (var event in appState.invitedevents)
            if (event.id == _eventid)
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                // month
                                convertToMonth(event.date),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              // day
                              Text(
                                convertToDay(event.date),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // event title
                              Text(
                                event.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // hosted by row
                              Row(
                                children: [
                                  Text(
                                    "Hosted by ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    event.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.person,
                        )),
                    Text(event.participants.toString()),
                  ],
                ),
              ),
        ],
      ),
    );

    Widget textSection = Consumer<ApplicationState>(
      builder: (context, appState, _) => Column(children: [
        for (var event in appState.invitedevents)
          if (event.id == _eventid)
            Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                event.desc,
                softWrap: true,
              ),
            ),
      ]),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              children: [
                Card(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // TO EDIT PAGE
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.black),
                      onPressed: () {
                        appState.deleteInvite(_eventid);
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.black),
                      onPressed: () {
                        appState.addMember(
                            FirebaseAuth.instance.currentUser?.uid ?? "no id",
                            FirebaseAuth.instance.currentUser?.displayName ??
                                "no name",
                            "member",
                            _eventid);
                        appState.deleteInvite(_eventid);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
                titleSection,
                for (var event in appState.invitedevents)
                  if (event.id == _eventid)
                    Image.network(
                      event.thumbnail,
                      width: 600,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
              ],
            ),
          ),
          textSection,
        ],
      ),
    );
  }
}
