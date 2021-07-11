import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class CurrentSetting {

  // setting information
  late Position location;
  late String city;
  late int month;
  late int year;
  late int day;

  CurrentSetting() {
    month = DateTime.now().month;
    year = DateTime.now().year;
    day = DateTime.now().day;
  }

  Future<void> getCurrentLocation() async {
    location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    // TODO convert coordinates to city
    city = '';
  }

}