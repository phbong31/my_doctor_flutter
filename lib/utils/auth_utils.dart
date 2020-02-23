import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {

  static final String endPoint = '/pps/auth/login.jsp';

  // Keys to store and fetch data from SharedPreferences
  static final String authTokenKey = 'auth_token';
  static final String userIdKey = 'user_id';
  static final String nameKey = 'name';
  static final String roleKey = 'role';
  static final String aToken = 'aToken';


  static String getToken(SharedPreferences prefs) {
    return prefs.getString(authTokenKey);
  }

  static insertDetails(SharedPreferences prefs, var response) {
    prefs.setString(authTokenKey, response['auth_token']);
    var user = response['user'];
    prefs.setString(aToken, user['aToken']);
//    prefs.setString(nameKey, user['name']);
  }

}