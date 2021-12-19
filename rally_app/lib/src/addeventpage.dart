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

import 'addeventpage.dart';
import 'classes/eventclass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'auth.dart';
import 'addeventpage.dart';
import 'classes/imageupload.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEventPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(debugLabel: '_AddEventState');
  final _titlecontroller = TextEditingController();
  final _desccontroller = TextEditingController();
  final _locationcontroller = TextEditingController();
  final _thumbnailcontroller = TextEditingController();
  final _demoState = _DatePickerDemoState();
  final _initialDateTime = DateTime.now();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Event'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(19),
            child: Form(
              child: Column(
                children: [
                  TextField(
                      controller: _titlecontroller,
                      decoration: const InputDecoration(
                        hintText: 'Enter a Title',
                      )),
                  DatePickerDemo(),
                  TextField(
                      controller: _locationcontroller,
                      decoration: const InputDecoration(
                        hintText: 'Enter a Location',
                      )),
                  TextField(
                      controller: _desccontroller,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Enter a Description',
                      )),
                ],
              ),
            ),
          ),
          ImageUpload(
            dateTime: _initialDateTime.toString(),
            originalUrl: "https://i.imgur.com/sUFH1Aq.png",
            folder: 'images/',
          ),
          Padding(
            padding: EdgeInsets.only(left: 80, right: 80, top: 15),
            child: Consumer<ApplicationState>(
              builder: (context, appState, _) => ElevatedButton(
                child: const Text("CREATE"),
                style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  //FIXME null check the fields
                  //if (_formKey.currentState!.validate()) {

                  var inst = FirebaseStorage.instance;

                  var url = "";
                  try {
                    url = await inst
                        .ref()
                        .child("images/" + _initialDateTime.toString())
                        .getDownloadURL();
                  } catch (e) {
                    print("no change");
                  }
                  await appState.addEvent(
                      _titlecontroller.text,
                      _desccontroller.text,
                      _DatePickerDemoState.selectedDate,
                      _DatePickerDemoState.dateString,
                      _locationcontroller.text,
                      1,
                      url);
                  _titlecontroller.clear();
                  _desccontroller.clear();
                  _DatePickerDemoState.dateString = "Enter a date";
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
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
  static DateTime selectedDate = DateTime.now();
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
      confirmText: 'Done',
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
