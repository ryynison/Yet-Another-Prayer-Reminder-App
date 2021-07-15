
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: Container(
            color: Colors.black,
            child: Center(
              child: Container(
                height: 120,
                width: 120,
                color: Colors.red,
              )
            ),
          ),
      ),
    );
  }
}

