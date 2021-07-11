import 'package:flutter/material.dart';
import 'package:yet_another_prayer_reminder/nav_hub.dart';
import 'package:yet_another_prayer_reminder/screens/loading.dart';

void main() => runApp(
    MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Loading(),
          '/nav_hub': (context) => NavHub(),
        }
    )
);
