import 'package:Volunteer/profile_page.dart';
import 'package:flutter/material.dart';

import 'events_page.dart';
import 'home_page.dart';

class MyNav extends Drawer {
  int currentIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey;

  MyNav(this.currentIndex, this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).pushNamed(HomePage.tag);
        } else if (index == 1) {
          Navigator.of(context).pushNamed(EventsPage.tag);
        } else if (index == 2) {
          Navigator.of(context).pushNamed(ProfilePage.tag);
        } else if (index == 3) {
          scaffoldKey.currentState.openDrawer();
        }
      }, // new
      currentIndex: currentIndex, // new
      items: [
        new BottomNavigationBarItem(
          backgroundColor: Color.fromRGBO(3, 57, 99, 1),
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        new BottomNavigationBarItem(
          backgroundColor: Color.fromRGBO(3, 57, 99, 1),
          icon: Icon(Icons.calendar_today),
          title: Text('Events'),
        ),
        new BottomNavigationBarItem(
          backgroundColor: Color.fromRGBO(3, 57, 99, 1),
          icon: Icon(Icons.account_circle),
          title: Text('Profile'),
        ),
        new BottomNavigationBarItem(
          backgroundColor: Color.fromRGBO(3, 57, 99, 1),
          icon: Icon(Icons.more_horiz),
          title: Text('More'),
        ),
      ],
    );
  }
}
