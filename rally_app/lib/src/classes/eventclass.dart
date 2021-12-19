/**
 * Rally -- Let's get together.
 * Copyright (C) 2021 - Sean Murphy, Matt Finch, Joey Lane, & Will Hayward
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../event.dart';
import '../widgets.dart';

class EventClass {
  EventClass({
    required this.id,
    required this.name,
    required this.title,
    required this.date_time,
    required this.date,
    required this.location,
    required this.desc,
    required this.participants,
    required this.thumbnail,
  });
  final String id;
  final String name;
  final String title;
  final DateTime date_time;
  final String date;
  final String location;
  final String desc;
  final int participants;
  final String thumbnail;
}

class EventsClass extends StatefulWidget {
  const EventsClass({required this.events});
  final List<EventClass> events; // new

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<EventsClass> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        //increase size of text and alignment
        const Header("Your Events"),
        const SizedBox(height: 8),
        //NEED SCROLLABLE or ListView
        //NEED to filter based on the events you are part of
        Column(children: [
          for (var event in widget.events.reversed)
            if (event.name == FirebaseAuth.instance.currentUser!.displayName)
              Card(
                child: ListTile(
                  leading: Image.network(event.thumbnail),
                  title: Text(event.title),
                  subtitle: Text((event.name ==
                          FirebaseAuth.instance.currentUser!.displayName)
                      ? "You"
                      : event.name),
                  trailing: Column(
                    children: [
                      Icon(Icons.person_outline),
                      Text(event.participants.toString()),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPage(
                                eventid: event.id,
                              )),
                    );
                  },
                ),
              ),
        ]),

        const SizedBox(height: 16),
        //increase size of text and alignment
        const Header("Events"),
        const SizedBox(height: 8),
        //NEED SCROLLABLE or ListView
        //NEED to filter based on the events you are part of
        widget.events.isNotEmpty
            ? Column(children: [
                for (var event in widget.events.reversed)
                  if (event.name !=
                      FirebaseAuth.instance.currentUser!.displayName)
                    Card(
                      child: ListTile(
                        leading: Image.network(event.thumbnail),
                        title: Text(event.title),
                        subtitle: Text((event.name ==
                                FirebaseAuth.instance.currentUser!.displayName)
                            ? "You"
                            : event.name),
                        trailing: Column(
                          children: [
                            Icon(Icons.person_outline),
                            Text(event.participants.toString()),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventPage(
                                      eventid: event.id,
                                    )),
                          );
                        },
                      ),
                    ),
              ])
            : Center(child: Text("No Events")),
        const SizedBox(height: 8),
      ],
    );
  }
}

//NEED TO DUPLICATE EVENTS CLASS AND MAKE EVENT PAGE CLASS
