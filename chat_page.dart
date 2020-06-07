import 'dart:async';
import 'dart:convert';

import 'package:Volunteer/API.dart';
import 'package:Volunteer/admin/admin_drawer.dart';
import 'package:Volunteer/admin/events/add.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'models/user.dart';
import 'my_nav.dart';

class ChatPage extends StatefulWidget {
  static String tag = 'chat-page';
  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  User _user = new User();
  int _userId = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textController = new TextEditingController();

  _getChats(int id, int other) {
    if (other == 0) {
      return;
    }
    API.getChats(id, other).then((response) {
      setState(() {
        _messages.clear();
        Map<String, dynamic> map = json.decode(response.body);
        Iterable list = map['data'];
        for (int i = 0; i < list.length; i++) {
          var chat = list.elementAt(i);
          ChatMessage message = new ChatMessage(
            //new
            text: chat['message'],
            name: chat['sender']['name'],
            user: chat['sender']['id'] == _userId ? 'me' : 'other',
          );
          setState(() {
            //new
            _messages.insert(0, message); //new
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_userId != 0 && _user != null) {
        _getChats(_userId, _user.id);
      }
    });

    _readData();
  }

  _readData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = prefs.getInt('user_id') ?? 0;

      _getChats(_userId, _user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final User arg = ModalRoute.of(context).settings.arguments;

    if (arg is User) {
      _user = arg;
    }

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
      body: new Column(
        //modified
        children: <Widget>[
          //new
          new Flexible(
            //new
            child: new ListView.builder(
              //new
              padding: new EdgeInsets.all(8.0), //new
              reverse: true, //new
              itemBuilder: (_, int index) => _messages[index], //new
              itemCount: _messages.length, //new
            ), //new
          ), //new
          new Divider(height: 1.0), //new
          new Container(
            //new
            decoration:
                new BoxDecoration(color: Theme.of(context).cardColor), //new
            child: _buildTextComposer(), //modified
          ), //new
        ], //new
      ),
      drawer: new MyAdminDrawer(),
      bottomNavigationBar: new MyNav(3, _scaffoldKey),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      //new
      data: new IconThemeData(color: Theme.of(context).accentColor), //new
      child: new Container(
        //modified
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                autocorrect: false,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ), //new
    );
  }

  void _handleSubmitted(String text) {
    API.sendMessage(_userId, _user.id, _textController.text).then((response) {
      _textController.clear();
      ChatMessage message = new ChatMessage(
        //new
        text: text,
        name: "B",
        user: "me",
      ); //new
      setState(() {
        //new
        _messages.insert(0, message); //new
      });
    });
  }
}
