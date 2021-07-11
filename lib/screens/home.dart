
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {


  Map data = {};

  // checks to see if setting has changed and reloads data if required
  // (sends to loading screen for reload of data)
  @override
  void initState() {
    super.initState();
    // TODO maybe put card widget in another function/class and put timer in there for cleaner code
    // refreshes page ever n seconds
    int n = 1;
    new Timer.periodic(Duration(seconds: n), (Timer t) =>
      setState((){
        //debugging
        print(DateTime.now().second);
        //
      })
    );
    WidgetsBinding.instance!.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed || state == AppLifecycleState.resumed) {
      setState(() {
        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // TODO 1 move all the data organization to the loading screen
    // data that was passed through from the loading screen
    data = ModalRoute.of(context)!.settings.arguments as Map;
    int currDay = data['current_day'];
    int currMonth = data['prayer_times']['data'][currDay-1]['date']['gregorian']['month']['number'];
    String currYear = data['prayer_times']['data'][currDay-1]['date']['gregorian']['year'];

    // creates map for storing timings of prayers and other events
    Map timings = data['prayer_times']['data'][currDay-1]['timings'];

    // removing unneeded key-value pairs
    timings.remove('Sunset'); // same as maghrib
    timings.remove('Imsak'); // might be used in future
    timings.remove('Midnight'); // might be used in future

    timings.forEach((key, value) {
      // converts timing to ISO format as a DateTime type for future
      // comparisons with current time
      String formattedMonth = currMonth.toString();
      String formattedDay = currDay.toString();
      if(currMonth < 10) {
        formattedMonth = '0$currMonth';
      }
      if(currDay < 10) {
        formattedDay = '0$currDay';
      }

      // checks if time is already formatted (in cases of app reloading after initial startup, etc)
      if(value is String) {
        String tempTime =value.toString().substring(0,5);
        String formattedTime = '$currYear-$formattedMonth-$formattedDay $tempTime:00';
        timings[key] = DateTime.parse(formattedTime);
      }

      /* TODO fix cases in which timings bleed into the next day but display as current day.
          May depend on timezone of the user, but might not be a problem if we disregard
          midnight timing all together. Might not be a problem actually since midnight could in fact
          be referring to the current day's midnight.
      */

      // debugging
      // print(key+': '+timings[key].toString());
      //
    });

    // TODO 1: end of data section

    // sets up the upcoming and previous timings
    List<String> upcomingDisplayedTiming = ['', ''];
    List<String> previousDisplayedTiming = ['', ''];

    DateTime currentTime = DateTime.now();

    for(String key in timings.keys) {
      if(currentTime.isBefore(timings[key])) {
        List<String> temp = [
          key,
          DateFormat.jm().format(timings[key]).toLowerCase()
        ];
        upcomingDisplayedTiming = temp;
        break;
      }
    }
    print(upcomingDisplayedTiming[0]+', '+upcomingDisplayedTiming[1]);
    print(timings);

    return Scaffold(
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                    children: [
                    Text(
                      'Elk Grove',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontFamily: 'PlayfairDisplayBold'
                      ),
                    ),
                      SizedBox(width: 12,),
                      Text(
                        '(${data['latitude']}, ${data['longitude']})',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
                        ),
                      ),
                    ]
                ),
                //Divider(height: 12, thickness: 2,),
                SizedBox(height: 18,),
                Container(
                  width : double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 15,
                    shadowColor: Colors.lightBlueAccent[100],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${upcomingDisplayedTiming[0]}',
                                style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.black,
                                    fontFamily: 'PlayfairDisplayBold'
                                )
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                      '${upcomingDisplayedTiming[1]}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontFamily: 'PlayfairDisplayBold'
                                      )
                                  ),
                                  SizedBox(height: 4,),
                                  Text(
                                    '-3:28:59',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12,),
                          Text(
                            'Previous',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                  '${previousDisplayedTiming[0]}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: 'PlayfairDisplay'
                                  )
                              ),
                              Spacer(),
                              Text(
                                  '${previousDisplayedTiming[1]}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: 'PlayfairDisplay'
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ),
                  ),
                //),
                Divider(height: 64, thickness: 0.75,),
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                          '${data['prayer_times']['data'][currDay-1]['date']['gregorian']['weekday']['en']}, '
                              '${data['prayer_times']['data'][currDay-1]['date']['gregorian']['month']['en']} '
                              '$currDay, '
                              '$currYear',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontFamily: 'PlayfairDisplay'
                          )
                      ),
                      SizedBox(height: 24,),
                      Text(
                        'Hijri Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                          '${data['prayer_times']['data'][currDay-1]['date']['hijri']['month']['en'].replaceAll('ʿ', '\'')} '
                              '${data['prayer_times']['data'][currDay-1]['date']['hijri']['day']}, '
                              '${data['prayer_times']['data'][currDay-1]['date']['hijri']['year']} AH',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontFamily: 'PlayfairDisplay'
                          )
                      ),
                    ],
                  ),
                ),
                //Text('Fajr: '+prayerData['prayer_times']['data'][4]['timings']['Fajr'])
              ],
            ),
          ),
      ),
    );
  }
}

