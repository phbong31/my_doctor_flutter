import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:my_doctor/pages/register_page.dart';
import 'package:my_doctor/pages/tab_page.dart';
import 'package:my_doctor/service/secure_storage.dart';
import 'package:my_doctor/service/token_service.dart';
import 'package:my_doctor/utils/network_utils.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  static final String routeName = 'login_screen';
  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isKakaoTalkInstalled = false;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
    _initKakaoTalkInstalled();
  }

  _fetchSessionAndNavigate() async {
    var authToken = await Token.getToken();
    if (authToken != null) {
      print("fetchSession token not null!!");
      Navigator.of(context).pushReplacementNamed(TabPage.routeName);
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

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install : ' + installed.toString());

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print(token.toJson());
      print("success");
    } catch (e) {
      print("error on issuing access token: $e");
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch (e) {
      print(e);
    }
  }

  _loginWithTalk() async {
    _showLoading();
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
      var user = await UserApi.instance.me();

      print('######Kakao User Info');
      print(user.toString());
//      var userDecode = json.decode(user.toString());
//      print(userDecode["id"]);
//      print(userDecode["connected_at"]);
      print(user.kakaoAccount.toString());
      print(user.connectedAt.toString());

      var responseJson =
          await NetworkUtils.authenticateSNSUser("kakao", user.id.toString());

      print('response:');
      print(responseJson);

      if (responseJson == null) {
        NetworkUtils.showSnackBar(_scaffoldKey, '등록되지 않은 사용자입니다.');

//          Navigator.of(_scaffoldKey.currentContext)
//              .pushNamed(RegisterScreen.routeName);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    RegisterScreen(arguments: user.id.toString())),
            (Route<dynamic> route) => false);

//        unlinkTalk();
      } else if (responseJson == 'NetworkError') {
        NetworkUtils.showSnackBar(_scaffoldKey, null);
      } else {
//      AuthUtils.insertDetails(_sharedPreferences, responseJson);
        /**
         * Removes stack and start with the new page.
         * In this case on press back on HomePage app will exit.
         * **/
//      print(responseJson['aToken']);
//      Token.writeToken(responseJson['aToken']);
        SecureStorage.writeJson(responseJson).whenComplete(() {
          Navigator.of(context).pushReplacementNamed('/');
        });
      }
    } catch (e) {
      print(e);
    }
    _hideLoading();
  }

  logOutTalk() async {
    try {
      var code = await UserApi.instance.logout();
      print(code.toJson());
    } catch (e) {
      print(e);
    }
  }

  unlinkTalk() async {
    try {
      var code = await UserApi.instance.unlink();
      print(code.toJson());
    } catch (e) {
      print(e);
    }
  }

  Widget _loginScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                child: Container(
                  width: 250,
                  height: 60,
                  padding: EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    image: DecorationImage(
                        image: AssetImage("assets/images/kakao_login_btn.png"),
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(4.0, 4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(22.0, 0, 0, 0),
                    child: Text('카카오톡으로 로그인하기',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )),
                ),
                onTap: () {
                  print(_isKakaoTalkInstalled);
                  _isKakaoTalkInstalled ? _loginWithTalk() : _loginWithKakao();
                })

//            RaisedButton(
//              child: Text("Logout"),
//              onPressed: logOutTalk,
//            )
          ],
        ),
      ),
    );
  }

  Widget _loadingScreen() {
    return Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(strokeWidth: 4.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                'Please Wait',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16.0),
              ),
            )
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
//    isKakaoTalkInstalled();
    return Scaffold(
        key: _scaffoldKey,
        body: _isLoading ? _loadingScreen() : _loginScreen());
  }
}

class LoginDone extends StatelessWidget {
  Future<bool> _getUser() async {
    try {
      User user = await UserApi.instance.me();
      print(user.toString());
    } on KakaoAuthException catch (e) {} catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    _getUser();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Login Success!'),
        ),
      ),
    );
  }
}
