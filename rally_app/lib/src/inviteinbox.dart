/**
 * Rally -- Let's get together.
 * Copyright (C) 2021 - Sean Murphy, Matt Finch, Joey Lane, & Will Hayward
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:rally_app/src/addeventpage.dart';
import 'package:rally_app/src/inviteflow.dart';
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
import 'classes/inviteclass.dart';

import 'classes/memberclass.dart';
import 'dart:async';

class InviteInbox extends StatelessWidget {
  const InviteInbox({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invites")),
      body: ListView(
        children: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  InvitesClass(
                    invites: appState.getUserInvites(
                        FirebaseAuth.instance.currentUser?.uid ?? "no id"),
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
