import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:my_doctor/pages/login_page.dart';
import 'package:my_doctor/pages/login_page_kakao.dart';
import 'package:my_doctor/service/secure_storage.dart';
import 'package:my_doctor/service/token_service.dart';
import 'package:my_doctor/utils/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';

class NetworkUtils {
  static final String host = productionHost;
  static final String productionHost = 'http://hsbong.synology.me:8080';
  static final String developmentHost = 'http://192.168.31.110:3000';

  static dynamic authenticateUser(String email, String password) async {
    var uri = host + AuthUtils.endPoint;

    try {
      final response = await http.post(
          uri,
          body: {
            'email': email,
            'password': password
          }
      );

      final responseJson = json.decode(response.body);
      return responseJson;

    } catch (exception) {
      print(exception);
      if(exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic authenticateSNSUser(String from, String uuid) async {
    var uri = host + AuthUtils.endPoint;
//    print("URI:"+uri);
    try {
      final response = await http.post(
          uri,
          body: {
            'from': from,
            'uuid': uuid
          }
      );

      final responseJson = json.decode(response.body);
      return responseJson;

    } catch (exception) {
      print(exception);
      if(exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static logoutUser(BuildContext context) {
//    prefs.setString(AuthUtils.authTokenKey, null);
//    prefs.setInt(AuthUtils.userIdKey, null);
//    prefs.setString(AuthUtils.nameKey, null);
//    signOutGoogle();
    logOutTalk();

    SecureStorage.deleteStorage();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      ModalRoute.withName('/'),
    );
  }

  static logOutTalk() async {
    try {
//      var code = await UserApi.instance.logout();
      var code = await UserApi.instance.unlink();
    } catch (e) {
      print(e);
    }
  }

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(message ?? 'You are offline'),
        )
    );
  }

  static fetch(var authToken, var endPoint) async {
    var uri = host + endPoint;

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': authToken
        },
      );

      final responseJson = json.decode(response.body);
      return responseJson;

    } catch (exception) {
      print(exception);
      if(exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
}