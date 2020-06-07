import 'dart:async';
import 'dart:convert';

import 'package:Volunteer/API.dart';
import 'package:Volunteer/admin/events/add.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_page.dart';
import 'drawer.dart';
import 'models/user.dart';
import 'my_nav.dart';

class ChatListPage extends StatefulWidget {
  static String tag = 'chat-list';
  @override
  _ChatListState createState() => new _ChatListState();
}

class _ChatListState extends State<ChatListPage> {
  var history = new List<User>();
  int _userId = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _getChatHistory(int id) {
    API.getChatHistory(id).then((response) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);
        Iterable list = map['data'];
        history = list.map((model) => User.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _readData();
    Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_userId != 0) {
        _getChatHistory(_userId);
      }
    });
  }

  _readData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = prefs.getInt('user_id') ?? 0;

      _getChatHistory(_userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final body = ListView.separated(
      itemCount: history.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(history[index].name),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.of(context).pushNamed(ChatPage.tag);
            Navigator.pushNamed(context, ChatPage.tag,
                arguments: history[index]);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Chat"), actions: <Widget>[
        // action button
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EventsAddPage.tag);
              },
            ),
          ),
        )
      ]),
      body: body,
      drawer: new MyDrawer(),
      bottomNavigationBar: new MyNav(3, _scaffoldKey),
    );
  }
}
