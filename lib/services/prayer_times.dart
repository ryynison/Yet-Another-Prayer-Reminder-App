import 'dart:convert';
import 'package:http/http.dart';
import 'package:yet_another_prayer_reminder/services/current_setting.dart';

class PrayerTimes {

  // final data from API call
  late Map prayerTimesData;

  // current setting information
  late String latitude;
  late String longitude;
  late String month;
  late String year;

  // additional options for calculating prayer times
  late String method;
  late String school;
  late String latAdjustmentMethod;


  PrayerTimes(CurrentSetting setting, {String method='2', String school='0', String latAdjustmentMethod='1'}) {
    latitude = setting.location.latitude.toStringAsFixed(3);
    longitude = setting.location.longitude.toStringAsFixed(3);
    month = setting.month.toString();
    year = setting.year.toString();

    this.method = method;
    this.school = school;
    this.latAdjustmentMethod = latAdjustmentMethod;
  }

  Future<Map> getPrayerTimes() async {

    String endpoint = 'http://api.aladhan.com/v1/calendar?'
        +'latitude=$latitude'
        +'&longitude=$longitude'
        +'&method=$method'
        +'&month=$month'
        +'&year=$year'
        +'&latitudeAdjustmentMethod=$latAdjustmentMethod'
        +'&school=$school';

    Response response = await get(Uri.parse(endpoint));
    prayerTimesData = jsonDecode(response.body);

    return prayerTimesData;
  }
}