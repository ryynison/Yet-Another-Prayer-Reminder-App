import 'package:flutter/material.dart';
import 'package:yet_another_prayer_reminder/services/current_setting.dart';
import 'package:yet_another_prayer_reminder/services/prayer_times.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  /* TODO complete overhaul of data (congregate previous month, current month, and
      next months prayer times into one large list in order avoid monthly edge cases
      (we would still need to compensate for the yearly edge cases though)
  */

  // initializes the prayer time data called from the API/loaded from cache
  // and then navigates to the home screen when the data is loaded
  void initData() async {

    // get current location and time
    CurrentSetting setting = CurrentSetting();
    await setting.getCurrentLocation();

    // sets up prayer times data object and creates prayerData object
    PrayerTimes prayerTimes = PrayerTimes(setting);
    List<Map> monthlyData = await prayerTimes.getPrayerTimes();

    // setting up timing data
    Map todayTimings = monthlyData[1]['data'][setting.day-1]['timings'];
    Map yesterdayTimings;
    Map tomorrowTimings;

    // check if first day of month
    if (setting.day == 1) {
      yesterdayTimings = monthlyData[0]['data'].last['timings'];
    } else {
      yesterdayTimings = monthlyData[1]['data'][setting.day-2]['timings'];
    }
    // check if last day of month
    if(monthlyData[1]['data'][setting.day-1] == monthlyData[1]['data'].last) {
      tomorrowTimings = monthlyData[2]['data'][0]['timings'];
    } else {
      tomorrowTimings = monthlyData[1]['data'][setting.day]['timings'];
    }

    // creating list to format data for all 3 maps
    List<Map> temp = [todayTimings, yesterdayTimings, tomorrowTimings];

    // pruning useless key-value pairs (sunset is same as maghrib, and imsak is unneeded for now)
    temp.forEach((timings) {
      timings.remove('Sunset');
      timings.remove('Imsak');

      timings.forEach((key, value) {
        // converts timing to ISO format as a DateTime type for future
        // comparisons with current time
        String formattedMonth = setting.month.toString();
        String formattedDay = setting.day.toString();
        if(setting.month < 10) {
          formattedMonth = '0${setting.month}';
        }
        if(setting.day < 10) {
          formattedDay = '0${setting.day}';
        }
        // checks if time is already formatted (in cases of app reloading after initial startup, etc)
        if(value is String) {
          String tempTime =value.toString().substring(0,5);
          String formattedTime = '${setting.year}-$formattedMonth-$formattedDay $tempTime:00';
          timings[key] = DateTime.parse(formattedTime);
        }

        // debugging
        //print(key+': '+timings[key].toString());
        //

      });

    });

    // navigation and data transfer to the home screen
    Navigator.pushReplacementNamed(context, '/nav_hub', arguments: {
      // timings
      'today_timings':todayTimings,
      'yesterday_timings':yesterdayTimings,
      'tomorrow_timings':tomorrowTimings,
      // coordinates
      'longitude': prayerTimes.longitude,
      'latitude': prayerTimes.latitude,
      // city
      'city': setting.city //TODO still
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
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
