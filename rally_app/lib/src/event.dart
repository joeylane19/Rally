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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:share_plus/share_plus.dart';

import 'messagespage.dart';
import 'gallery.dart';

class EventPage extends StatelessWidget {
  //get messages here and event info
  final String _eventid;

  const EventPage({
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
    final _messageController = TextEditingController();

    Widget titleSection = Consumer<ApplicationState>(
      builder: (context, appState, _) => Column(
        children: [
          for (var event in appState.events)
            if (event.id == _eventid)
              Container(
                padding: const EdgeInsets.all(15),
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
                              Text(
                                event.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // hosted by row
                              if (event.name ==
                                  FirebaseAuth
                                      .instance.currentUser!.displayName)
                                Text(
                                  "Hosted by you!",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              if (event.name !=
                                  FirebaseAuth
                                      .instance.currentUser!.displayName)
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MembersPage(
                                    eventid: _eventid, name: event.title)),
                          );
                        },
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.deepPurple,
                        )),
                    Text(event.participants.toString()),
                  ],
                ),
              ),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(children: [
              for (var eventi in appState.events)
                if (eventi.id == _eventid)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                            backgroundColor: Colors.deepPurple),
                        onPressed: () {
                          final Event event = Event(
                            title: eventi.title,
                            description: eventi.desc,
                            location: eventi.location,
                            startDate: DateTime.parse(eventi.date),
                            endDate: DateTime.parse(eventi.date),
                            allDay: true,
                            iosParams: IOSParams(
                              reminder: Duration(),
                            ),
                          );
                          Add2Calendar.addEvent2Cal(event);
                        },
                        icon: Icon(Icons.calendar_today_rounded,
                            color: Colors.white),
                        label: Text("Add to Calendar"),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                            backgroundColor: Colors.deepPurple),
                        onPressed: () {
                          onShare(context, eventi.title, "subject");
                        },
                        icon: Icon(Icons.share, color: Colors.white),
                        label: Text("Share"),
                      )
                    ],
                  ),
            ]));

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              children: [
                for (var eventi in appState.events)
                  if (eventi.id == _eventid)
                    Column(
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
                            if (eventi.name ==
                                FirebaseAuth.instance.currentUser!.displayName)
                              IconButton(
                                icon: Icon(CupertinoIcons.pencil,
                                    color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditEventPage(
                                              date_time: eventi.date_time,
                                              date: eventi.date,
                                              location: eventi.location,
                                              desc: eventi.desc,
                                              name: eventi.name,
                                              eventid: eventi.id,
                                              title: eventi.title,
                                              thumbnail: eventi.thumbnail,
                                              participants: eventi.participants,
                                            )),
                                  );
                                },
                              ),
                          ],
                        )),
                        Image.network(
                          eventi.thumbnail,
                          width: 600,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        titleSection,
                        _buildLocationRow(eventi.location),
                        SizedBox(height: 10),
                        _descriptionSection(eventi.desc),
                        SizedBox(height: 10),

                        // NEW FEATURE ROW
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // ADD TO CALENDAR ROW
                              GestureDetector(
                                  onTap: () {
                                    final Event event = Event(
                                      title: eventi.title,
                                      description: eventi.desc,
                                      location: eventi.location,
                                      startDate: DateTime.parse(eventi.date),
                                      endDate: DateTime.parse(eventi.date),
                                      allDay: true,
                                      iosParams: IOSParams(
                                        reminder: Duration(
                                            /* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
                                      ),
                                    );
                                    Add2Calendar.addEvent2Cal(event);
                                  },
                                  child: _buildButtonColumn(
                                      Colors.black,
                                      Icons.calendar_today_outlined,
                                      "CALENDAR")),

                              // PHOTO GALLERY ROW
                              GestureDetector(
                                  onTap: () async {
                                    var inst = FirebaseStorage.instance;
                                    var paths = await inst
                                        .ref()
                                        .child('galleries/' + _eventid)
                                        .listAll();
                                    List<String> photos = [];
                                    if (!paths.items.isEmpty) {
                                      photos = await Future.wait(paths.items
                                          .map((e) => inst
                                              .ref()
                                              .child(e.fullPath)
                                              .getDownloadURL()));
                                    }

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GalleryPage(
                                                eventId: _eventid,
                                                photos: photos)));
                                  },
                                  child: _buildButtonColumn(Colors.black,
                                      Icons.photo_album, "PHOTOS")),
                              // SHARE ROW
                              GestureDetector(
                                  onTap: () {
                                    onShare(context, eventi.title, "subject");
                                  },
                                  child: _buildButtonColumn(
                                      Colors.black, Icons.share, " SHARE ")),
                            ]),
                      ],
                    ),
              ],
            ),
          ),
          // buttonSection,
          SizedBox(
            height: 8,
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  const Divider(
                    height: 8,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessagesPage(
                                  eventid: _eventid,
                                )),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Expanded(
                          child: Card(
                              child: Column(children: [
                        Card(
                            shadowColor: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text("Recent Messages",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))))),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Consumer<ApplicationState>(
                              builder: (context, appState, _) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (appState.loginState ==
                                            ApplicationLoginState.loggedIn) ...[
                                          if (appState
                                                  .getMessages(_eventid)
                                                  .length ==
                                              0)
                                            Text("No messages",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ))
                                          else
                                            MessagesClass(
                                              //FIXME
                                              messages: appState
                                                  .getMessages(_eventid)
                                                  .take(2)
                                                  .toList(),
                                              eventid: _eventid, // new
                                            ),
                                        ]
                                      ])),
                        )
                      ]))),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column getRecentMessage(List<MessageClass> messages) {
    if (messages.length > 0) {
      MessageClass mess = messages.elementAt(0);
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mess.text.length > 30
                ? mess.text.substring(0, 30) + "..."
                : mess.text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            mess.name,
            style: TextStyle(fontSize: 12),
          ),
        ],
      );
    }
    return Column(children: [
      Text(
        "No current messages",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    ]);
  }
}

Row _calendarButtons(Color color) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    _buildButtonColumn(color, Icons.calendar_today_rounded, 'ADD TO CALENDAR'),
    _buildButtonColumn(color, Icons.photo_album, 'PHOTOS'),
    _buildButtonColumn(color, Icons.share, 'SHARE'),
  ]);
}

Column _buildButtonColumn(Color color, IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color),
      Container(
        margin: const EdgeInsets.only(top: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    ],
  );
}

Row _buildLocationRow(String loc) {
  return Row(
    children: [
      SizedBox(
        width: 10,
      ),
      Icon(
        Icons.location_on,
        color: Colors.black,
      ),
      SizedBox(
        width: 10,
      ),
      Text(loc),
    ],
  );
}

Padding _descriptionSection(String desc) {
  return Padding(
    padding: EdgeInsets.only(right: 15, left: 15, bottom: 15),
    child: Text(
      desc,
      softWrap: true,
    ),
  );
}

void onShare(BuildContext context, String text, String subject) async {
  await Share.share(
    text,
    subject: subject,
  );
}
