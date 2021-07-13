
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {

  void setState(func) {
    if (mounted) super.setState(func);
  }

  Map data = {};

  // checks to see if setting has changed and reloads data if required
  // (sends to loading screen for reload of data)
  @override
  void initState() {
    super.initState();
    // TODO maybe put card widget in another function/class and put timer in there for cleaner code
    // sets state every n seconds
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
    if (state == AppLifecycleState.resumed) {
      setState(() {
        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // data that was passed through from the loading screen
    data = ModalRoute.of(context)!.settings.arguments as Map;

    // sets up the upcoming and previous timings
    List<String> upcomingDisplayedTiming = ['', ''];
    List<String> previousDisplayedTiming = ['', ''];

    DateTime currentTime = DateTime.now();

    // Determining previous/upcoming display times
    // (will probably be overhauled completely later, current solution is pure jank)
    for(String key in data['today_timings'].keys) {
      if(currentTime.isBefore(data['today_timings'][key])) {
        List<String> temp1 = [];
        String keyTemp;
        switch(key) {
          case 'Fajr': {
            keyTemp = 'Midnight';
            temp1 = [
              keyTemp,
              DateFormat.jm().format(data['yesterday_timings'][keyTemp]).toLowerCase()
            ];
          } break;
          case 'Sunrise': {
            keyTemp = 'Fajr';
            temp1 = [
              keyTemp,
              DateFormat.jm().format(data['today_timings'][keyTemp]).toLowerCase()
            ];
          } break;
          case 'Dhuhr': {
            keyTemp = 'Sunrise';
            temp1 = [
              keyTemp,
              DateFormat.jm().format(data['today_timings'][keyTemp]).toLowerCase()
            ];
          } break;
          case 'Asr': {
            keyTemp = 'Dhuhr';
            temp1 = [
              keyTemp,
              DateFormat.jm().format(data['today_timings'][keyTemp]).toLowerCase()
            ];
          } break;
          case 'Maghrib': {
            keyTemp = 'Asr';
            temp1 = [
              keyTemp,
              DateFormat.jm().format(data['today_timings'][keyTemp]).toLowerCase()
            ];
          } break;
          case 'Isha': {
            keyTemp = 'Maghrib';
            temp1 = [
              keyTemp,
              DateFormat.jm().format(data['today_timings'][keyTemp]).toLowerCase()
            ];
          } break;
          case 'Midnight': {
            keyTemp = 'Isha';
            temp1 = [
              keyTemp,
              DateFormat.jm().format(data['tomorrow_timings'][keyTemp]).toLowerCase()
            ];
          } break;
        }

        previousDisplayedTiming = temp1;

        List<String> temp2 = [
          key,
          DateFormat.jm().format(data['today_timings'][key]).toLowerCase()
        ];
        upcomingDisplayedTiming = temp2;
        break;
      }
    }

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
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
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
                          '',
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
                          '',
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

