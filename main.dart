import 'package:Volunteer/admin/admin/add.dart';
import 'package:Volunteer/admin/events/add.dart';
import 'package:Volunteer/admin/events/list.dart';
import 'package:Volunteer/admin/home_page.dart';
import 'package:Volunteer/home_page.dart';
import 'package:Volunteer/models/events.dart';
import 'package:Volunteer/password_page.dart';
import 'package:Volunteer/profile_page.dart';
import 'package:Volunteer/splash.dart';
import 'package:flutter/material.dart';

import 'admin/admin/list.dart';
import 'admin/cms/list.dart';
import 'admin/user/add.dart';
import 'admin/user/list.dart';
import 'events_page.dart';
import 'login_page.dart';
import 'models/admin.dart';
import 'models/user.dart';
import 'signup_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // routes used in app
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    SignUpPage.tag: (context) => SignUpPage(),
    AdminHomePage.tag: (context) => AdminHomePage(),
    AdminAddPage.tag: (context, {Admin admin}) => AdminAddPage(),
    AdminListPage.tag: (context) => AdminListPage(),
    EventsListPage.tag: (context) => EventsListPage(),
    EventsAddPage.tag: (context, {Events events}) => EventsAddPage(),
    UserListPage.tag: (context) => UserListPage(),
    UserAddPage.tag: (context, {User user}) => UserAddPage(),
    EventsPage.tag: (context) => EventsPage(),
    ProfilePage.tag: (context) => ProfilePage(),
    PasswordPage.tag: (context) => PasswordPage(),
    CmsPage.tag: (context) => CmsPage(),

    // members section
    HomePage.tag: (context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Members App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: SplashScreen(),
      routes: routes,
    );
  }
}
