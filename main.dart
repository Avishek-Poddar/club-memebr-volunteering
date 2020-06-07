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
import 'admin/request/list.dart';
import 'admin/user/add.dart';
import 'admin/user/list.dart';
import 'chat_list.dart';
import 'chat_page.dart';
import 'events_page.dart';
import 'forget_page.dart';
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
    ForgetPage.tag: (context) => ForgetPage(),
    AdminHomePage.tag: (context) => AdminHomePage(),
    AdminAddPage.tag: (context, {Admin admin}) => AdminAddPage(),
    AdminListPage.tag: (context) => AdminListPage(),
    EventsListPage.tag: (context) => EventsListPage(),
    EventsAddPage.tag: (context, {Events events}) => EventsAddPage(),
    UserListPage.tag: (context) => UserListPage(),
    UserAddPage.tag: (context, {User user}) => UserAddPage(),
    EventsPage.tag: (context) => EventsPage(),
    ProfilePage.tag: (context) => ProfilePage(),
    ChatListPage.tag: (context) => ChatListPage(),
    ChatPage.tag: (context, {User user}) => ChatPage(),
    PasswordPage.tag: (context) => PasswordPage(),
    CmsPage.tag: (context) => CmsPage(),
    RequestListPage.tag: (context) => RequestListPage(),

    // members section
    HomePage.tag: (context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volunteer App',
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

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.user});
  final String text;
  final String name;
  final String user;
  @override
  Widget build(BuildContext context) {
    if (user == 'me') {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text(this.name,
                      style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(
                      text,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: new CircleAvatar(child: new Text("Me")),
            ),
          ],
        ),
      );
    } else {
      return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child:
                  new CircleAvatar(child: new Text(this.name[0].toUpperCase())),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(this.name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
