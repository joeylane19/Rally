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

class MessagesPage extends StatelessWidget {
  final String _eventid;

  const MessagesPage({
    Key? key,
    required String eventid,
  }) : _eventid = eventid;

  @override
  Widget build(BuildContext context) {
    final _messageController = TextEditingController();
    final _scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Messages"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10, bottom: 18, right: 10, left: 10),
        controller: _scrollController,
        child: Column(
          children: [
            Consumer<ApplicationState>(
              builder: (context, appState, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (appState.loginState ==
                      ApplicationLoginState.loggedIn) ...[
                    MessagesClass(
                      messages: appState.getMessages(_eventid),
                      eventid: _eventid,
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                            focusColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: Icon(Icons.send_rounded),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black)),
                        onPressed: () async {
                          await appState.addMessage(
                            _messageController.text,
                            _eventid,
                          );
                          _messageController.clear();
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ],
          ),
        )
      ],
    );
  }
}
