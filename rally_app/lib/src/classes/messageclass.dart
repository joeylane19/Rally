/**
 * Rally -- Let's get together.
 * Copyright (C) 2021 - Sean Murphy, Matt Finch, Joey Lane, & Will Hayward
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../auth.dart';
import '../event.dart';
import '../widgets.dart';
import 'package:rally_app/main.dart';

class MessageClass {
  MessageClass({
    required this.id,
    required this.userId,
    required this.name,
    required this.text,
    required this.timestamp,
  });
  final String id;
  final String userId;
  final String name;
  final String text;
  final Timestamp timestamp;
}

class MessagesClass extends StatefulWidget {
  const MessagesClass({required this.messages, required this.eventid});
  final List<MessageClass> messages; // new
  final String eventid;

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<MessagesClass> {
  bool checkUser(String id) {
    if (id != FirebaseAuth.instance.currentUser!.uid) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final _messageController = TextEditingController();
    var reciever = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        SingleChildScrollView(
          child: Column(children: [
            for (var message in widget.messages.reversed)
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(children: [
                    Align(
                        alignment: (checkUser(message.userId)
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Text(checkUser(message.userId)
                            ? message.name
                            : "You" +
                                "  " +
                                message.timestamp.toDate().month.toString() +
                                "/" +
                                message.timestamp.toDate().day.toString())),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Align(
                        alignment: (checkUser(message.userId)
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (checkUser(message.userId)
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            message.text,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ])),
          ]),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
