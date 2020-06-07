import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'API.dart';
import 'controls/my_alert.dart';
import 'login_page.dart';
import 'signup_page.dart';

class ForgetPage extends StatefulWidget {
  static String tag = 'forget-page';
  @override
  _ForgetPageState createState() => new _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child: Image.asset('assets/logo-new.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          API.forgotPassword(emailController.text).then((response) {
            if (response.status) {
              MyAlert.show("Success", "OTP sent to email successfully", "Done",
                  context: context,
                  onClickAction: () =>
                      Navigator.of(context).pushNamed(LoginPage.tag));
            } else {
              MyAlert.show("Error", response.msg, "Dismiss",
                  context: context,
                  onClickAction: () => Navigator.pop(context));
            }
          });
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: this.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Text('Send OTP', style: TextStyle(color: Colors.white)),
      ),
    );

    final signupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(SignUpPage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue,
        child: Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Color(0xFFFAFBFC),
      body: new Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        decoration: myBoxDecoration(), //       <--- BoxDecoration here
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              logo,
              new Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    new Text(
                      "Forgot Password",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 20.0),
                    email,
                    SizedBox(height: 8.0),
                    loginButton,
                    SizedBox(height: 34.0),
                    FlatButton(
                      child: Text(
                        'Copyright © 2019 All rights reserved. v1.0.01\n\nDeveloped by BSY',
                        style: TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }

  void _showDialog(String msg) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        width: 0,
        color: Colors.blue,
      ),
    );
  }

  _save(int userId, String name, int isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_id', userId);
    prefs.setInt('is_admin', isAdmin);
    prefs.setString('user_name', name);
  }
}
