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

class MemberClass {
  MemberClass({
    required this.userId,
    required this.name,
    required this.role,
  });
  final String userId;
  final String name;
  final String role;
}

//class Members (use for members and invites subscriptions)

class MembersClass extends StatefulWidget {
  const MembersClass({required this.members});
  final List<MemberClass> members; // new

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<MembersClass> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const SizedBox(height: 8),
        Column(children: [
          for (var member in widget.members.reversed)
            Card(
              child: ListTile(
                title: Text(member.name),
                subtitle: Text(member.role),
              ),
            ),
        ]),
        const SizedBox(height: 8),
      ],
    );
  }
}
