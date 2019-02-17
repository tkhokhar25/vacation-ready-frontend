import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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

  Future<Null> _handleLocalSignIn() async {
    triedLoggingIn = true;

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$emailText:$passwordText'));
    http.Response response = await http.get(
        serverAddress+'/api/fulltree/getChildrenOfNode?nodeType=root',
        headers: {
          "Authorization": basicAuth,
          "Content-Type": "application/json",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Allow-Methods": "*",
          "Content-Encoding": "gzip",
          "Access-Control-Allow-Origin": "*"
        });

    if (response.statusCode == 200) {
      setState(() {
        isValid = true;
        email = emailText;
        auth = basicAuth;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
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
      'images/atom_white.png',
      width: 150.0,
      height: 50.0,
    );

    final email = new TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: TextStyle(color: Colors.white70),
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: new TextStyle(color: Colors.white30),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      onChanged: (String str) {
        setState(() {
          emailText = str;
        });
      },
    );

    final password = new TextField(
        obscureText: true,
        autofocus: false,
        style: TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: new TextStyle(color: Colors.white30),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
        onChanged: (String str) {
          setState(() {
            passwordText = str;
          });
        });

    final loginButton = new Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: _handleLocalSignIn,
          color: Colors.red,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final message = new Text(
      !isValid && triedLoggingIn
          ? "Invalid Credentials Entered!"
          : "",
      style:
          new TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );

    if (_currentUser != null || isValid) {
      return new DisplayData('', '');
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
              message,
              new Padding(padding: EdgeInsets.only(bottom: 20.0)),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              const Text("OR", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
      child: _buildBody(),
    ));
  }
}