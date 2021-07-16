
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void setState(func) {
    if (mounted) super.setState(func);
  }

  Map data = {};

  // checks to see if setting has changed and reloads data if required
  // (sends to loading screen for reload of data)
  @override
  void initState() {
    super.initState();
    // sets state every n seconds
    int n = 1;
    new Timer.periodic(Duration(seconds: n), (Timer t) =>
      setState((){})
    );
  }

  @override
  Widget build(BuildContext context) {

    // data that was passed through from the loading screen
    data = ModalRoute.of(context)!.settings.arguments as Map;

    // sets up the upcoming and previous timings
    List upcomingTiming = ['', ''];
    List previousTiming = ['', ''];

    DateTime currentTime = DateTime.now();

    // Determining previous/upcoming display times
    // (will probably be overhauled completely later, current solution is pure jank)
    for(String key in data['today_timings'].keys) {
      if(currentTime.isBefore(data['today_timings'][key])) {
        List temp1 = [];
        String keyTemp;
        switch(key) {
          case 'Fajr': {
            keyTemp = 'Isha';
            temp1 = [
              keyTemp,
              data['yesterday_timings'][keyTemp]
            ];
          } break;
          case 'Sunrise': {
            keyTemp = 'Fajr';
            temp1 = [
              keyTemp,
              data['today_timings'][keyTemp]
            ];
          } break;
          case 'Dhuhr': {
            keyTemp = 'Sunrise';
            temp1 = [
              keyTemp,
              data['today_timings'][keyTemp]
            ];
          } break;
          case 'Asr': {
            keyTemp = 'Dhuhr';
            temp1 = [
              keyTemp,
              data['today_timings'][keyTemp]
            ];
          } break;
          case 'Maghrib': {
            keyTemp = 'Asr';
            temp1 = [
              keyTemp,
              data['today_timings'][keyTemp]
            ];
          } break;
          case 'Isha': {
            keyTemp = 'Maghrib';
            temp1 = [
              keyTemp,
              data['today_timings'][keyTemp]
            ];
          } break;
        }

        previousTiming = temp1;

        List temp2 = [
          key,
          data['today_timings'][key]
        ];

        upcomingTiming = temp2;
        break;
      } else {
        // quick patch for displayed timing after isha and before next day starts,
        // reveals fragility of current system (☉__☉”)
        upcomingTiming = [
          'Fajr',
          data['tomorrow_timings']['Fajr']
        ];
        previousTiming = [
          'Isha',
          data['today_timings']['Isha']
        ];

      }
    }

    print(data['yesterday_timings']);
    print(data['today_timings']);
    print(data['tomorrow_timings']);
    print('\n');

    // Calculate time difference for countdown timer
    int difference = upcomingTiming[1].difference(currentTime).inSeconds;
    int k = 7;
    if (difference>=36000) {
      k = 8;
    }
    String countdown = '- ${Duration(seconds: difference).toString().substring(0,k)}';


    return Scaffold(
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                    children: [
                    Text(
                      data['city'],
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
                                '${upcomingTiming[0]}',
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
                                      '${DateFormat.jm().format(upcomingTiming[1]).toLowerCase()}',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontFamily: 'PlayfairDisplayBold'
                                      )
                                  ),
                                  SizedBox(height: 4,),
                                  Text(
                                    countdown,
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
                                  '${previousTiming[0]}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: 'PlayfairDisplay'
                                  )
                              ),
                              Spacer(),
                              Text(
                                  '${DateFormat.jm().format(previousTiming[1]).toLowerCase()}',
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
              ],
            ),
          ),
      ),
    );
  }
}

