/**
 * Rally -- Let's get together.
 * Copyright (C) 2021 - Sean Murphy, Matt Finch, Joey Lane, & Will Hayward
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

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
import 'classes/memberclass.dart';
import 'classes/userclass.dart';
import 'dart:async';

class InvitePage extends StatelessWidget {
  //get messages here and event info

  final String _eventid;
  final String _name;
  const InvitePage({
    Key? key,
    required String eventid,
    required String name,
  })  : _eventid = eventid,
        _name = name,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Card(
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Header("Invite to " + _name),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  const Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.grey,
                  ),
                  InviteUsersClass(
                    users: appState.users,
                    eventid: _eventid,
                    eventname: _name,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
