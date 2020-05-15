import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Consts.dart';
import 'admin/home_page.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<Map<String, dynamic>> loginUser({Map body}) async {
    return http
        .post(Consts.LOGIN_URL, body: body)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      // check if server response is valid or not
      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      Map<String, dynamic> map = json.decode(response.body);
      // check if user is valid or not
      if (map['status'] == false) {
        _showDialog(map['msg']);
        return map;
      }
      // if user is valid store the user name and id in session
      _save(map['data']['id'] as int, map['data']['name'],
          map['data']['is_admin'] as int);

      return map;
    });
  }

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
          setState(() {
            this.isLoading = true;
          });
          var params = new Map<String, dynamic>();
          params["email"] = emailController.text;
          params["password"] = passwordController.text;

          loginUser(body: params).then((map) {
            if (map['status']) {
              // if user is valid then redirect according to user type
              SharedPreferences.getInstance().then((prefs) {
                if (prefs.getInt('is_admin') != null &&
                    prefs.getInt('is_admin') == 1) {
                  Navigator.of(context).pushNamed(AdminHomePage.tag);
                } else {
                  Navigator.of(context).pushNamed(HomePage.tag);
                }
              });
            }
            setState(() {
              this.isLoading = false;
            });
          });
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: this.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Text('Login', style: TextStyle(color: Colors.white)),
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
                      "Log In",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 20.0),
                    email,
                    SizedBox(height: 8.0),
                    password,
                    SizedBox(height: 24.0),
                    loginButton,
                    forgotLabel,
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
