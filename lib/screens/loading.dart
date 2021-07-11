import 'package:flutter/material.dart';
import 'package:yet_another_prayer_reminder/services/current_setting.dart';
import 'package:yet_another_prayer_reminder/services/prayer_times.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // TODO push to github
  /* TODO complete overhaul of data (congregate previous month, current month, and
      next months prayer times into one large list in order avoid monthly edge cases
      (we would still need to compensate for the yearly edge cases though)
  */

  // initializes the prayer time data called from the API
  // and then navigates to the home screen when the data is loaded
  void initPrayerTimes() async {
    // get current location and time
    CurrentSetting setting = CurrentSetting();
    await setting.getCurrentLocation();
    // sets up prayer times data object
    PrayerTimes prayerTimes = PrayerTimes(setting);
    await prayerTimes.getPrayerTimes();

    // navigation to the home screen
    Navigator.pushReplacementNamed(context, '/nav_hub', arguments: {
      'prayer_times': prayerTimes.prayerTimesData,
      'longitude': prayerTimes.longitude,
      'latitude': prayerTimes.latitude,
      'current_day': setting.day,
      'city': setting.city
    });
  }

  @override
  void initState() {
    super.initState();
    initPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(child: Text('Insert Loading Animation Here')))
        // TODO loading screen
        );
  }
}
