import 'dart:async';
import 'dart:convert' show json;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_doctor/pages/tab_page.dart';
import 'package:my_doctor/service/secure_storage.dart';
import 'package:my_doctor/service/token_service.dart';
import 'package:my_doctor/signup/input_data.dart';
import 'package:my_doctor/signup/input_data.dart';
import 'package:my_doctor/signup/signup_page.dart';
import 'package:my_doctor/utils/auth_utils.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:my_doctor/utils/network_utils.dart';
import 'package:my_doctor/utils/sign_in.dart';
import 'package:my_doctor/utils/validators.dart';
import 'package:my_doctor/widgets/email_field.dart';
import 'package:my_doctor/widgets/error_box.dart';
import 'package:my_doctor/widgets/google_login_button.dart';
import 'package:my_doctor/widgets/password_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first_screen.dart';
import 'main_list.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//  SharedPreferences _sharedPreferences;
  bool _isError = false;
  bool _obscureText = true;
  bool _isLoading = false;
  TextEditingController _emailController, _passwordController;
  String _errorText, _emailError, _passwordError;

//  //flutter_secure_storage
//  final storage = new FlutterSecureStorage();
//  void setToken() async {
//    await storage.write(key: "aToken", value: Constants.TOKEN);
//    print("SET TOKEN################# ");
//  }


  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  _fetchSessionAndNavigate() async {
//    _sharedPreferences = await _prefs;
    var authToken = await Token.getToken();
    if (authToken != null) {
      print("fetchSession token not null!!");
      Navigator.of(_scaffoldKey.currentContext)
          .pushReplacementNamed(TabPage.routeName);
    }
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  _authenticateUser() async {
    _showLoading();
    if (_valid()) {
      var responseJson = await NetworkUtils.authenticateUser(
          _emailController.text, _passwordController.text);

      print(responseJson);

      if (responseJson == null) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
      } else if (responseJson == 'NetworkError') {
        NetworkUtils.showSnackBar(_scaffoldKey, null);
      } else if (responseJson['errors'] != null) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid Email/Password');
      } else {
//        AuthUtils.insertDetails(_sharedPreferences, responseJson);
        /**
         * Removes stack and start with the new page.
         * In this case on press back on HomePage app will exit.
         * **/
        Navigator.of(_scaffoldKey.currentContext)
            .pushReplacementNamed(TabPage.routeName);
      }
      _hideLoading();
    } else {
      setState(() {
        _isLoading = false;
        _emailError;
        _passwordError;
      });
    }
  }

  _authenticateGoogleUser() async {
    _showLoading();

    signInWithGoogle().then((value) async {
      print("google login return :"+value);

    var responseJson = await NetworkUtils.authenticateSNSUser(
        "google", value);

    print(responseJson);

    if (responseJson == null) {
      NetworkUtils.showSnackBar(_scaffoldKey, '등록되지 않은 사용자입니다.');
      Navigator.of(_scaffoldKey.currentContext)
          .pushNamed(SignUpPage.routeName);
      signOutGoogle();
    } else if (responseJson == 'NetworkError') {
      NetworkUtils.showSnackBar(_scaffoldKey, null);
    } else if (responseJson['errors'] != null) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid Email/Password');
    } else {
//      AuthUtils.insertDetails(_sharedPreferences, responseJson);
      /**
       * Removes stack and start with the new page.
       * In this case on press back on HomePage app will exit.
       * **/
//      print(responseJson['aToken']);
//      Token.writeToken(responseJson['aToken']);
      SecureStorage.writeJson(responseJson);
//      InputData inputData = new InputData();
////      inputData.writeJson(responseJson);
//      inputData.updateInfo();

      Navigator.of(_scaffoldKey.currentContext)
          .pushReplacementNamed('/');
    }
    });

    _hideLoading();
  }


  _valid() {
    bool valid = true;

    if (_emailController.text.isEmpty) {
      valid = false;
      _emailError = "Email can't be blank!";
    } else if (!_emailController.text.contains(EmailValidator.regex)) {
      valid = false;
      _emailError = "Enter valid email!";
    }

    if (_passwordController.text.isEmpty) {
      valid = false;
      _passwordError = "Password can't be blank!";
    } else if (_passwordController.text.length < 6) {
      valid = false;
      _passwordError = "Password is invalid!";
    }

    return valid;
  }

  Widget _loginScreen() {
    return new Container(
      child: new ListView(
        padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0),
        children: <Widget>[
          ErrorBox(isError: _isError, errorText: _errorText),
          EmailField(
              emailController: _emailController, emailError: _emailError),
          PasswordField(
            passwordController: _passwordController,
            obscureText: _obscureText,
            passwordError: _passwordError,
            togglePassword: _togglePassword,
          ),
          new GoogleLoginButton(onPressed: _authenticateGoogleUser)
        ],
      ),
    );
  }

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _loadingScreen() {
    return new Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: new Center(
            child: new Column(
          children: <Widget>[
            new CircularProgressIndicator(strokeWidth: 4.0),
            new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                'Please Wait',
                style:
                    new TextStyle(color: Colors.grey.shade500, fontSize: 16.0),
              ),
            )
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: _isLoading ? _loadingScreen() : _loginScreen());
  }
}

//
//class _LoginPageState extends State<LoginPage> {
//
//  final storage = new FlutterSecureStorage();
//
//  void setToken() async {
//    await storage.write(key: "aToken", value: Constants.TOKEN);
//    print("SET TOKEN################# ");
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//        color: Colors.white,
//        child: Center(
//          child: Column(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Image(image: AssetImage("assets/images/soo_logo.jpg"), height: 300.0),
//              SizedBox(height: 50),
//              _signInButton(),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _signInButton() {
//    return OutlineButton(
//      splashColor: Colors.grey,
//      onPressed: () {
//        signInWithGoogle().whenComplete(() {
//          setToken();
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) {
//                return TabPage();
//              },
//            ),
//          );
//        });
//      },
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//      highlightElevation: 0,
//      borderSide: BorderSide(color: Colors.grey),
//      child: Padding(
//        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//        child: Row(
//          mainAxisSize: MainAxisSize.min,
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
//            Padding(
//              padding: const EdgeInsets.only(left: 10),
//              child: Text(
//                'Google로 로그인하기',
//                style: TextStyle(
//                  fontSize: 20,
//                  color: Colors.grey,
//                ),
//              ),
//            ),
//
//          ],
//        ),
//      ),
//    );
//  }
//}
