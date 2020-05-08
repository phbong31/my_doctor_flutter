import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_doctor/pages/tab_page.dart';
import 'package:my_doctor/utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  static final String routeName = 'signup_page';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool _isLoading = false;

  signUp(String name, phone, birth, sex, address) async {
    Map data = {
      'name': name,
      'phone': phone,
      'birth' : birth,
      'sex' : sex,
      'address' : address
    };

    var jsonResponse = null;
    var response = await http.post(Constants.SIGNUP_URL, body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => TabPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: emailController.text == "" || passwordController.text == "" ? printLog : () {
          setState(() {
            _isLoading = true;
          });
          signUp(emailController.text, passwordController.text, '', '', '');
          print('signUp submit');
        },
        elevation: 3.0,
        color: Colors.purple,
        child: Text("Sign In", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  void printLog() {
    print(emailController.text);
    print(passwordController.text);
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,

            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerSection() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 50.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text("어디아포",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
          margin: EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Text("회원가입을 위해 정보 입력이 필요합니다",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

