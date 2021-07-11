import 'package:flutter/material.dart';
import 'package:yet_another_prayer_reminder/screens/home.dart';

class NavHub extends StatefulWidget {
  const NavHub({Key? key}) : super(key: key);

  @override
  _NavHubState createState() => _NavHubState();
}

class _NavHubState extends State<NavHub> {
  int currIndex = 0;
  List<Widget> widgets = <Widget>[
    Home(),
    Center(child: Text('test'))
  ];

  void onTap(int index) {
    setState(() {
      currIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.elementAt(currIndex),
      bottomNavigationBar:
          // TODO change bottom nav bar to nicer design
        BottomNavigationBar(
          items:
            const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Test',
              )
            ],
            currentIndex: currIndex,
            onTap: onTap
        ),
    );
  }
}
