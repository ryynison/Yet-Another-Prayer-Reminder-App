import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geocoder/geocoder.dart';


class CurrentSetting {

  // setting information
  late Position location;
  late String city;
  late String country;
  late int month;
  late int year;
  late int day;

  CurrentSetting() {
    month = DateTime.now().month;
    year = DateTime.now().year;
    day = DateTime.now().day;
  }

  Future<void> getCurrentLocation() async {

    /* TODO prevent trying to get city name if not
        traveled certain distance to prevent loading slow down */

    // get coordinates of current position
    location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

    // get city and country name from location for displaying
    final coordinates = Coordinates(location.latitude, location.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    if (addresses.first.locality != null) {
      city = ''+addresses.first.locality.toString();
    } else {
      city = 'Unknown';
    }
    if (addresses.first.countryName != null) {
      country = ''+addresses.first.countryName.toString();
    } else {
      country = 'Unknown';
    }
  }

}