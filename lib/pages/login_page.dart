import 'dart:async';
import 'dart:convert' show json;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_doctor/utils/sign_in.dart';

import 'first_screen.dart';
import 'main_list.dart';


class LoginPage extends StatefulWidget {
@override
_LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FirstScreen();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Google로 로그인하기',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



//
//class LoginPage extends StatefulWidget {
//  @override
//  State createState() => SignInDemoState();
//}
//
//class SignInDemoState extends State<LoginPage> {
//  GoogleSignInAccount _currentUser;
//  String _contactText;
//
//  GoogleSignIn _googleSignIn = GoogleSignIn(
//    scopes: <String>[
//      'email',
//      'https://www.googleapis.com/auth/contacts.readonly',
//    ],
//  );
//
//  @override
//  void initState() {
//    super.initState();
//    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
//      setState(() {
//        _currentUser = account;
//      });
//      if (_currentUser != null) {
//        _handleGetContact();
//      }
//    });
//    _googleSignIn.signInSilently();
//  }
//
//  Future<void> _handleGetContact() async {
//    setState(() {
//      _contactText = "Loading contact info...";
//    });
//    final http.Response response = await http.get(
//      'https://people.googleapis.com/v1/people/me/connections'
//          '?requestMask.includeField=person.names',
//      headers: await _currentUser.authHeaders,
//    );
//    if (response.statusCode != 200) {
//      setState(() {
//        _contactText = "People API gave a ${response.statusCode} "
//            "response. Check logs for details.";
//      });
//      print('People API ${response.statusCode} response: ${response.body}');
//      return;
//    }
//    final Map<String, dynamic> data = json.decode(response.body);
//    final String namedContact = _pickFirstNamedContact(data);
//    setState(() {
//      if (namedContact != null) {
//        _contactText = "I see you know $namedContact!";
//      } else {
//        _contactText = "No contacts to display.";
//      }
//    });
//  }
//
//  String _pickFirstNamedContact(Map<String, dynamic> data) {
//    final List<dynamic> connections = data['connections'];
//    final Map<String, dynamic> contact = connections?.firstWhere(
//          (dynamic contact) => contact['names'] != null,
//      orElse: () => null,
//    );
//    if (contact != null) {
//      final Map<String, dynamic> name = contact['names'].firstWhere(
//            (dynamic name) => name['displayName'] != null,
//        orElse: () => null,
//      );
//      if (name != null) {
//        return name['displayName'];
//      }
//    }
//    return null;
//  }
//
//  Future<void> _handleSignIn() async {
//    try {
//      await _googleSignIn.signIn();
//    } catch (error) {
//      print("_handleSignIn():"+error.toString());
//    }
//  }
//
//  Future<void> _handleSignOut() => _googleSignIn.disconnect();
//
//  Widget _buildBody() {
//    if (_currentUser != null) {
//      return Column(
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
//        children: <Widget>[
//          ListTile(
//            leading: GoogleUserCircleAvatar(
//              identity: _currentUser,
//            ),
//            title: Text(_currentUser.displayName ?? ''),
//            subtitle: Text(_currentUser.email ?? ''),
//          ),
//          const Text("Signed in successfully."),
//          Text(_contactText ?? ''),
//          RaisedButton(
//            child: const Text('SIGN OUT'),
//            onPressed: _handleSignOut,
//          ),
//          RaisedButton(
//            child: const Text('REFRESH'),
//            onPressed: _handleGetContact,
//          ),
//        ],
//      );
//    } else {
//      return Column(
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
//        children: <Widget>[
//          const Text("You are not currently signed in."),
//          RaisedButton(
//            child: const Text('SIGN IN'),
//            onPressed: _handleSignIn,
//          ),
//        ],
//      );
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          title: const Text('Google Sign In'),
//        ),
//        body: ConstrainedBox(
//          constraints: const BoxConstraints.expand(),
//          child: _buildBody(),
//        ));
//  }
//}