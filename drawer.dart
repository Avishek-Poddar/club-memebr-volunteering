import 'package:Volunteer/login_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class MyDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Image.asset('assets/logo-new.png'),
          decoration: BoxDecoration(
            color: Color.fromRGBO(3, 57, 99, 1),
          ),
        ),
        ListTile(
          title: Text('Home'),
          onTap: () {
            Navigator.of(context).pushNamed(HomePage.tag);
          },
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pushNamed(LoginPage.tag);
          },
        ),
      ],
    ));
  }
}
