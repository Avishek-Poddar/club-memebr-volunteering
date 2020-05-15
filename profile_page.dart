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
  static String tag = 'Profile_Page';
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  User _user = new User();

  bool _isEdit = false;

  int _userId = 0;
  int _isAdmin = 0;
  String _userName = '';

  int completedHours = 0;
  int CommittedHours = 0;
  int remainingHours = 0;

  _readData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = prefs.getInt('user_id') ?? 0;
      _isAdmin = prefs.getInt('is_admin') ?? 0;
      _userName = prefs.getString('user_name') ?? '';
    });
  }

  void formSubmit(BuildContext context) {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_isEdit) {
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
      } else {}
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
    final User arg = ModalRoute.of(context).settings.arguments;

    if (arg is User) {
      _user = arg;
      _isEdit = true;
      this._user.password = '';
    }

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
            initialValue: this._user.name,
          ),
          new Label("User Phone"),
          new TextFormField(
            keyboardType: TextInputType.text,
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
            initialValue: this._user.phone,
          ),
          new Label("User Email"),
          new TextFormField(
            keyboardType: TextInputType.emailAddress,
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
            initialValue: this._user.email,
          ),
          new Label("User Password"),
          new TextFormField(
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'User Password',
            ),
            validator: (value) {
              if (_isEdit) {
                return null;
              }
              if (value.isEmpty) {
                return 'Please enter user password';
              }
              return null;
            },
            onSaved: (String value) {
              this._user.password = value;
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
