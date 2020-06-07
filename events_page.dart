import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'API.dart';
import 'controls/form_controls.dart';
import 'controls/my_alert.dart';
import 'drawer.dart';
import 'models/events.dart';
import 'my_nav.dart';

class EventsPage extends StatefulWidget {
  static String tag = 'events-page';
  @override
  _EventsPageState createState() => new _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  int _userId = 0;
  int _isAdmin = 0;
  String _userName = '';
  String _selectedType = 'All';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map<DateTime, List> _events = {};
  Map<DateTime, List> _filteredEvents = {};
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime eventDay = DateTime.now();
  Map<int, Events> _allEvents = {};

  @override
  void initState() {
    super.initState();
    _readData();

    final _selectedDay = DateTime.now();

    _selectedEvents = _events[_selectedDay] ?? [];

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  void _getEvents() {
    var es = new List<Events>();
    API.getEvents(userId: _userId).then((response) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);
        Iterable list = map['data'];
        es = list.map((model) => Events.fromJson(model)).toList();
        for (Events e in es) {
          _allEvents.addAll(<int, Events>{e.id: e});

          if (_events.containsKey(e.date)) {
            _events[e.date].add(e.id);
            _filteredEvents[e.date].add(e.id);
          } else {
            _events.addAll(<DateTime, List>{
              e.date: [e.id]
            });
            _filteredEvents.addAll(<DateTime, List>{
              e.date: [e.id]
            });
          }

          _events[e.date] = Set.of(_events[e.date]).toList();
          _filteredEvents[e.date] = Set.of(_filteredEvents[e.date]).toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      eventDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  _readData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = prefs.getInt('user_id') ?? 0;
      _isAdmin = prefs.getInt('is_admin') ?? 0;
      _userName = prefs.getString('user_name') ?? '';

      _getEvents();
    });
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
      bottomNavigationBar: new MyNav(1, _scaffoldKey),
      drawer: new MyDrawer(),
      backgroundColor: Color(0xFFFAFBFC),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 0, left: 20.0, right: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new Label("Event Type"),
                      new DropdownButton<String>(
                        value: this._selectedType,
                        onChanged: (String value) {
                          setState(() {
                            _selectedType = value;
                            _getEvents();
                          });
                        },
                        items: <String>[
                          'All',
                          'Games',
                          'Training',
                          'Canteen',
                          'Social'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              )),
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList(context)),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    _events.forEach((date, ids) async {
      _filteredEvents.addAll(<DateTime, List>{date: ids});
    });

    if (_selectedType != 'All') {
      _filteredEvents.forEach((date, ids) {
        for (int i = 0; i < ids.length; i++) {
          Events e = _allEvents[ids[i]];
          if (e.type != _selectedType) {
            ids.removeAt(i);
          }
        }
      });
    }

    return TableCalendar(
      calendarController: _calendarController,
      events: _filteredEvents,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[],
        ),
      ],
    );
  }

  Widget _buildEventList(context) {
    return ListView(
      children: _selectedEvents
          .map((eventId) => Container(
                decoration: BoxDecoration(
                  color: _allEvents[eventId].color,
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(_allEvents[eventId].name),
                  trailing: new Visibility(
                    child: RaisedButton(
                      onPressed: () => {
                        API.applyEvents(_userId, eventId).then((response) {
                          MyAlert.show(
                              "Success", "Applied for the event", "Done",
                              context: context,
                              onClickAction: () => {
                                    Navigator.of(context)
                                        .pushNamed(EventsPage.tag)
                                  });
                        })
                      },
                      color: Colors.lightBlueAccent,
                      child: new Text("Apply"),
                    ),
                    visible: _allEvents[eventId].status == 'red' &&
                        !_allEvents[eventId].applied,
                  ),
                  onTap: () {
//                    Navigator.of(context).pushNamed(EventsAddPage.tag);
//                    Navigator.pushNamed(context, EventsAddPage.tag,
//                        arguments: _allEvents[eventId]);
                  },
                ),
              ))
          .toList(),
    );
  }
}
