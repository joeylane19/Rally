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
import 'package:flutter/cupertino.dart';

import 'addeventpage.dart';
import 'classes/eventclass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../main.dart';
import 'auth.dart';
import 'addeventpage.dart';
import 'event.dart';
import 'classes/imageupload.dart';

class EditEventPage extends StatelessWidget {
  final String _eventid;
  final String _title;
  final String _name;
  final DateTime _date_time;
  final String _date;
  final String _location;
  final String _desc;
  final int _participants;
  final String _thumbnail;
  final _initialDateTime = DateTime.now();

  //this is not pulling information so if edited will remain static FIXME
  EditEventPage(
      {Key? key,
      required String eventid,
      required String title,
      required String name,
      required DateTime date_time,
      required String date,
      required String location,
      required String desc,
      required int participants,
      required String thumbnail})
      : _eventid = eventid,
        _title = title,
        _name = name,
        _date_time = date_time,
        _date = date,
        _location = location,
        _desc = desc,
        _participants = participants,
        _thumbnail = thumbnail,
        super(key: key);

  DateTime selectedDate = DateTime.now();

  Future<void> deleteEvent(BuildContext context, String eventid) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    return FirebaseFirestore.instance
        .collection('events')
        .doc(eventid)
        .delete()
        .then((value) {
      print("Success!");
    });
  }

  void _delete(BuildContext context, _eventid) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: Text('Please Confirm'),
            content: Text(
                'This action is irreversible. Are you sure you want to delete this event?'),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () {
                  deleteEvent(context, _eventid);
                },
                child: Text('Yes'),
                isDefaultAction: true,
                isDestructiveAction: true,
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
                isDefaultAction: false,
                isDestructiveAction: false,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var _titlecontroller = TextEditingController(text: _title);
    var _desccontroller = TextEditingController(text: _desc);
    var _locationcontroller = TextEditingController(text: _location);
    var _participantscontroller =
        TextEditingController(text: _participants.toString());
    var _thumbnailcontroller = TextEditingController(text: _thumbnail);
    var _demoState = _DatePickerDemoState();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) => ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                var inst = FirebaseStorage.instance;
                var url = _thumbnail;
                try {
                  url = await inst
                      .ref()
                      .child("images/" + _initialDateTime.toString())
                      .getDownloadURL();
                } catch (e) {
                  print("no change");
                }

                await appState.editEvent(
                    this._eventid,
                    _titlecontroller.text,
                    _desccontroller.text,
                    _date_time,
                    _date,
                    _locationcontroller.text,
                    int.parse(_participantscontroller.text),
                    url);
                Navigator.pop(
                  context,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(19),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                      controller: _titlecontroller,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      )),
                  TextFormField(
                      controller: _locationcontroller,
                      decoration: InputDecoration(
                        labelText: 'Location',
                      )),
                  TextFormField(
                      controller: _desccontroller,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      )),
                  TextFormField(
                      controller: _participantscontroller,
                      decoration: InputDecoration(
                        labelText: 'Participants',
                      )),
                ],
              ),
            ),
          ),
          ImageUpload(
            dateTime: _initialDateTime.toString(),
            originalUrl: _thumbnail,
            folder: 'images/',
          ),
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
          icon: Icon(Icons.delete),
          label: Text("Delete Event"),
          onPressed: () {
            _delete(context, _eventid);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class DatePickerDemo extends StatefulWidget {
  @override
  _DatePickerDemoState createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<DatePickerDemo> {
  /// Which holds the selected date
  /// Defaults to today's date.
  DateTime selectedDate = DateTime.now();
  static String dateString = "Enter a date";

  /// This decides which day will be enabled
  /// This will be called every time while displaying day in calender.
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 5000))))) {
      return true;
    }
    return false;
  }

  _selectDate(BuildContext context) {
    return buildMaterialDatePicker(context);
  }

  // Widget iconButton =
  //     IconButton(onPressed: () {}, icon: Icons.calendar_today_outlined);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "${dateString}",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(
          width: 20.0,
        ),
        IconButton(
            icon: Icon(Icons.calendar_today_outlined),
            iconSize: 20,
            color: Colors.grey[500],
            onPressed: () => _selectDate(context)),
      ],
    );
  }

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              initialDateTime: selectedDate,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      selectableDayPredicate: _decideWhichDayToEnable,
      helpText: 'Select booking date',
      cancelText: 'Not now',
      confirmText: 'Book',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Booking date',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateString = selectedDate.toString().split(' ')[0];
      });
  }
}
