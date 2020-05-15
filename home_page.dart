import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'API.dart';
import 'controls/form_controls.dart';
import 'drawer.dart';
import 'my_nav.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _userId = 0;
  int _isAdmin = 0;
  String _userName = '';

  int completedHours = 0;
  int pendingHours = 0;
  int remainingHours = 0;


  _readData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = prefs.getInt('user_id') ?? 0;
      _isAdmin = prefs.getInt('is_admin') ?? 0;
      _userName = prefs.getString('user_name') ?? '';

      print(_userId);
      _getHours(_userId);
    });
  }

  void _getHours(int Id) {
    API.getMyHours(Id).then((response) {
      Map<String, dynamic> map = json.decode(response.body);
      var hours = map['data'];
      print(hours);
      setState(() {
        completedHours = hours['completed'] > 100 ? 100 : hours['completed'];
        pendingHours = hours['pending'] > 100 ? 100 : hours['pending'];
        remainingHours = hours['remaining'] > 100 ? 100 : hours['remaining'];

      });
    });
  }

  @override
  void initState() {
    super.initState();
    _readData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(3, 57, 99, 1),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Label("Completed Hours"),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 30.0,
              animationDuration: 2000,
              percent: (completedHours / 100) > 0 ? (completedHours / 100) : 0,
              center: Text("${completedHours} % of total hour"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.green,
            ),
          ),
          new Label("Committed Hours"),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 30.0,
              animationDuration: 2000,
              percent: (pendingHours / 100) > 0 ? (pendingHours / 100) : 0,
              center: Text("${pendingHours} % of total hour"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.orange,
            ),
          ),
          new Label("Remaining Hours"),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 30.0,
              animationDuration: 2000,
              percent: (remainingHours / 100) > 0 ? (remainingHours / 100) : 0,
              center: Text("${remainingHours} % of total hour"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.red,
            ),
          ),
        ],
      ),
      drawer: new MyDrawer(),
      bottomNavigationBar: new MyNav(0, _scaffoldKey),
    );
  }
}
