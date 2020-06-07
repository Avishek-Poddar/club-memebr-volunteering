import 'dart:convert';

import 'package:Volunteer/password_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'API.dart';
import 'controls/form_controls.dart';
import 'controls/my_alert.dart';
import 'drawer.dart';
import 'models/user.dart';
import 'my_nav.dart';

class ProfilePage extends StatefulWidget {
  static String tag = 'profile-page';
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var nameTextController = new TextEditingController();
  var addressTextController = new TextEditingController();
  var phoneTextContoller = new TextEditingController();
  var emailTextContoller = new TextEditingController();

  User _user = new User();

  int completedHours = 0;
  int pendingHours = 0;
  int remainingHours = 0;

  _readData() async {
    final prefs = await SharedPreferences.getInstance();

    int uid = prefs.getInt('user_id') ?? 0;
    print(uid);

    API.getUser(uid).then((response) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);
        print(map['data']);
        _user = User.fromJson(map['data']);
        nameTextController.text = _user.name;
        addressTextController.text = _user.address;
        phoneTextContoller.text = _user.phone;
        emailTextContoller.text = _user.email;
      });
    });
  }

  void formSubmit(BuildContext context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      API.updateUser(_user.id, _user.toMap()).then((response) {
        if (response.status) {
          MyAlert.show("Success", "Profile updated successfully", "Done",
              context: context,
              onClickAction: () =>
                  Navigator.of(context).pushNamed(ProfilePage.tag));
        } else {
          MyAlert.show("Error", response.msg, "Dismiss",
              context: context, onClickAction: () => Navigator.pop(context));
        }
      });
    }
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
    final Size screenSize = MediaQuery.of(context).size;

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        left: 10,
        top: 10,
        right: 10,
        bottom: 10,
      ),
      child: new Form(
        key: this._formKey,
        child: new ListView(children: <Widget>[
          new Label("User Name"),
          new TextFormField(
            keyboardType: TextInputType.text,
            controller: nameTextController,
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'User Name',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter user name';
              }
              return null;
            },
            onSaved: (String value) {
              this._user.name = value;
            },
          ),
          new Label("User Address"),
          new TextFormField(
            keyboardType: TextInputType.text,
            controller: addressTextController,
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'User Address',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter user address';
              }
              return null;
            },
            onSaved: (String value) {
              this._user.address = value;
            },
          ),
          new Label("User Phone"),
          new TextFormField(
            keyboardType: TextInputType.text,
            controller: phoneTextContoller,
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'User Phone',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter user phone';
              }
              return null;
            },
            onSaved: (String value) {
              this._user.phone = value;
            },
          ),
          new Label("User Email"),
          new TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailTextContoller,
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'User Email',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter user email';
              }
              return null;
            },
            onSaved: (String value) {
              this._user.email = value;
            },
          ),
          SizedBox(height: 10.0),
          Visibility(
            visible: true,
            child: new Container(
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text(
                  'Change Password',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(PasswordPage.tag);
                },
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Visibility(
            visible: true,
            child: new Container(
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text(
                  'Update',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  this.formSubmit(context);
                },
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 10.0),
        ]),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Update Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(3, 57, 99, 1),
      ),
      body: body,
      drawer: new MyDrawer(),
      bottomNavigationBar: new MyNav(2, _scaffoldKey),
    );
  }
}
