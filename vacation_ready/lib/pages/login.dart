import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utilities/user_info.dart';
import 'create_trip.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/userinfo.email'
  ],
);

class SignIn extends StatefulWidget {
  @override
  State createState() => new SignInState();
}

class SignInState extends State<SignIn> {
  GoogleSignInAccount _currentUser;
  String emailText = "", passwordText = "";
  bool isValid = false;
  bool triedLoggingIn = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _buildBody();
      }
    });

    //_googleSignIn.signInSilently();
  }

  Future<Null> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      userName = _currentUser.displayName;
      email = _currentUser.email;
    } catch (error) {
      print(error);
    }
  }

  Future<Null> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  Widget _buildBody() {
    final logo = new Image.asset(
      'images/vacation_ready_logo.png',
      width: 450.0,
      height: 150.0,
    );

    
    // if logged in, take the user to the home page
    if (_currentUser != null) {
      return new CreateTrip();
    } else {
      return Scaffold(
          backgroundColor: Colors.black87,
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                new Padding(padding: EdgeInsets.only(top: 20.0)),
                SizedBox(height: 14.0),
                new FlatButton(
                  child: Image(
                      image: new AssetImage('images/google_sign_in.png'),
                      width: 185.0,
                      height: 45.0),
                  onPressed: _handleSignIn,
                ),
              ],
            ),
          ),
        );
      }
  }
  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: _buildBody()
    ));
  }
  }


