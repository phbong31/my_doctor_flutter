import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/common.dart';


class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    KakaoContext.clientId = "0fe74bc1afa0a00174cf4bda8a7e5fda";
    //KakaoContext.javascriptClientId = "a527841dd8ee52cb4318f6e389f28c9e";
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {


  @override
  void initState() {
    super.initState();
    _initKakaoTalkInstalled();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  bool _isKakaoTalkInstalled = true;

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
     // Navigator.of(context).pushReplacementNamed("/main");

    } catch (e) {
      print("error on issuing access token: $e");
    }
  }

//  _userApi() async {
//    try {
//      User user = await UserApi.instance.me();
//      // do anything you want with user instance
//    } on KakaoAuthException catch (e) {
//      if (e.code == ApiErrorCause.INVALID_TOKEN) { // access token has expired and cannot be refrsehd. access tokens are already cleared here
//        Navigator.of(context).pushReplacementNamed('/login'); // redirect to login page
//      }
//    } catch (e) {
//      // other api or client-side errors
//    }
//  }

  @override
  Widget build(BuildContext context) {
    isKakaoTalkInstalled();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kakao Flutter SDK Login"),
        actions: [],
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(child: Text("Login"), onPressed: _loginWithKakao),
              RaisedButton(
                  child: Text("Login with Talk"),
                  onPressed: _isKakaoTalkInstalled ? _loginWithTalk : null),
            ],
          )),
    );
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
      print(code);
    } catch (e) {
      print(e);
    }
  }

  _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
      print("success: "+code);
    } catch (e) {
      print(e);
    }
  }
}