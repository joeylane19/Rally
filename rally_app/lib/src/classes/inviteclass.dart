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
import 'package:rally_app/main.dart';
import 'package:provider/provider.dart';
import '../invitepreview.dart';

class InviteClass {
  InviteClass({
    //required this.userId,
    required this.eventId,
    required this.eventname,
  });
  final String eventId;
  final String eventname;
}

//class users (use for members and invites subscriptions)

class InvitesClass extends StatefulWidget {
  const InvitesClass({required this.invites});
  final List<InviteClass> invites; // new

  @override
  _InvitesState createState() => _InvitesState();
}

class _InvitesState extends State<InvitesClass> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            children: [
              for (var invite in widget.invites.reversed)
                Card(
                  child: ListTile(
                    title: Text(invite.eventname),
                    trailing: IconButton(
                        onPressed: () {
                          appState.addMember(
                              FirebaseAuth.instance.currentUser?.uid ?? "no id",
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  "no name",
                              "member",
                              invite.eventId);
                          appState.deleteInvite(invite.eventId);
                        },
                        icon: Icon(Icons.check)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InvitePreview(eventid: invite.eventId),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
