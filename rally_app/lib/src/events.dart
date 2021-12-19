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
import 'package:rally_app/src/settings.dart';

import 'addeventpage.dart';
import 'classes/eventclass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'auth.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
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
                  EventsClass(
                    events: appState.events, // new
                  ),
                ] else
                  Center(
                      child: ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text("Login to View Events"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()));
                    },
                  )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
          icon: Icon(Icons.add),
          label: Text("Create an event"),
          onPressed: () {
            if (FirebaseAuth.instance.currentUser != null)
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddEventPage()));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
