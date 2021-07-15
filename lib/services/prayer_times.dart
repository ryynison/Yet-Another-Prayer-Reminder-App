import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:yet_another_prayer_reminder/services/current_setting.dart';
import 'package:path_provider/path_provider.dart';

class PrayerTimes {

  // current setting information
  late String latitude;
  late String longitude;
  late int month;
  late int year;

  // additional options for calculating prayer times
  late int method;
  late int school;
  late int latAdjustmentMethod;

  PrayerTimes(CurrentSetting setting, {int method = 2, int school = 0, int latAdjustmentMethod = 1}) {
    latitude = setting.location.latitude.toStringAsFixed(3);
    longitude = setting.location.longitude.toStringAsFixed(3);
    month = setting.month;
    year = setting.year;

    this.method = method;
    this.school = school;
    this.latAdjustmentMethod = latAdjustmentMethod;
  }

  Future<List<Map>> getPrayerTimes() async {

    int callMonth;
    int callYear;

    List<Map> loadedCache = []; //[monthBefore, monthCurrent, monthAfter]

    for (int i = month - 1; i <= month + 1; i++) {

      // check edge cases for first day of year and last day for year
      if (i < 1) {
        callMonth = 12;
        callYear = year-1;
      } else if (i > 12) {
        callMonth = 1;
        callYear = year+1;
      } else {
        callMonth = i;
        callYear = year;
      }

      // setup for caching
      /* adjustedLat & adjustedLong designed such that same cache is used if not
       too far from original location (within ~11km) */
      String adjustedLat = double.parse(latitude).toStringAsFixed(1).replaceAll('.', 'p');
      String adjustedLong = double.parse(longitude).toStringAsFixed(1).replaceAll('.', 'p');
      String cacheName = '$callYear-$callMonth-${adjustedLat}_$adjustedLong.json';
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File cache = File('${appDocDir.path}/$cacheName');

      // make a call only if no cache already exists
      if (!cache.existsSync()) {
        print('No cache exists: ');
        String endpoint = 'http://api.aladhan.com/v1/calendar?' +
            'latitude=$latitude' +
            '&longitude=$longitude' +
            '&method=$method' +
            '&month=$callMonth' +
            '&year=$callYear' +
            '&latitudeAdjustmentMethod=$latAdjustmentMethod' +
            '&school=$school';

        // API call
        print('Making API call');
        Response response = await get(Uri.parse(endpoint));

        // save API call as json cache
        print('Cached at ${appDocDir.path}/$cacheName');
        cache.writeAsStringSync(response.body,
            flush: true, mode: FileMode.write);
      } else print('Cache already exists at ${appDocDir.path}/$cacheName');

      // load saved caches into ordered list (loadedCache)
      loadedCache.add(json.decode(cache.readAsStringSync()));
    }

    return loadedCache;

  }

}
