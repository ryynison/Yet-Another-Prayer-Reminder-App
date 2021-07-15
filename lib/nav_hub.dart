import 'package:flutter/material.dart';
import 'package:yet_another_prayer_reminder/screens/home.dart';
import 'package:yet_another_prayer_reminder/screens/settings.dart';
import 'package:bottom_bar_page_transition/bottom_bar_page_transition.dart';

class NavHub extends StatefulWidget {
  const NavHub({Key? key}) : super(key: key);

  @override
  _NavHubState createState() => _NavHubState();
}

class _NavHubState extends State<NavHub> with WidgetsBindingObserver {

  // checks to see if setting has changed and reloads data if required
  // (sends to loading screen for reload of data)
  @override
  void initState() {
    super.initState();
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

  int currIndex = 0;
  List<Widget> screens = <Widget>[
    Home(),
    Settings(),
  ];

  void onTap(int index) {
    setState(() {
      currIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomBarPageTransition(
        builder: (_, currIndex) => screens.elementAt(currIndex),
        currentIndex: currIndex,
        totalLength: screens.length,
        transitionType: TransitionType.fade,
        transitionDuration: Duration(milliseconds: 200),
        transitionCurve: Curves.ease,
      ),
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
                icon: Icon(Icons.settings),
                label: 'Settings',
              )
            ],
            currentIndex: currIndex,
            onTap: onTap
        ),
    );
  }
}
