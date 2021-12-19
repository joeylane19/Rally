/**
 * Rally -- Let's get together.
 * Copyright (C) 2021 - Sean Murphy, Matt Finch, Joey Lane, & Will Hayward
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

import 'package:flutter/material.dart';
import 'package:rally_app/main.dart';
import 'package:provider/provider.dart';

class UserClass {
  UserClass({
    required this.userId,
    required this.name,
    required this.bio,
  });
  final String userId;
  final String name;
  final String bio;
}

//class users (use for members and invites subscriptions)

class UsersClass extends StatefulWidget {
  const UsersClass({required this.users});
  final List<UserClass> users; // new

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<UsersClass> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        //increase size of text and alignment
        const Text("Users"),
        const SizedBox(height: 8),
        //NEED SCROLLABLE or ListView
        Column(children: [
          for (var user in widget.users.reversed)
            Card(
              child: ListTile(
                title: Text(user.name),
                //subtitle: Text(user.bio),
              ),
            ),
        ]),
        const SizedBox(height: 8),
      ],
    );
  }
}

class InviteUsersClass extends StatefulWidget {
  const InviteUsersClass(
      {required this.users, required this.eventid, required this.eventname});
  final List<UserClass> users; // new
  final String eventid;
  final String eventname;

  @override
  _InviteUsersState createState() => _InviteUsersState();
}

class _InviteUsersState extends State<InviteUsersClass> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        //increase size of text and alignment
        const Text("Users"),
        const SizedBox(height: 8),
        //NEED SCROLLABLE or ListView
        Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(children: [
            for (var user in widget.users.reversed)
              Card(
                child: ListTile(
                    title: Text(user.name),
                    //subtitle: Text(user.bio),

                    onTap: () {
                      appState.addInvite(
                          user.userId, widget.eventname, widget.eventid);

                      Navigator.pop(context);
                      // add and show a green checkmark
                      //eventually check they are not already invited
                    }),
              ),
          ]),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
