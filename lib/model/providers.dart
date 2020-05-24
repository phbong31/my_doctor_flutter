import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/model/user_info.dart';
import 'package:my_doctor/service/webservice.dart';

import 'board_base.dart';

class ProviderData with ChangeNotifier {
  String name = '';
  String email = '';
  String gender = 'Male';
  String dateOfBirth = '';
  String password = '';
  String position = '';
  String token = '';
  String profileUrl = '';
  String uuid = '';

  String groupId = '';

  User getUserFromProvider () {
    User user = User(0, this.name, this.position, this.profileUrl);
    notifyListeners();
    print('name:$name');
    return user;
  }

  void setGroupId(String id) {
    groupId = id;

    notifyListeners();
  }

  //InputData(this.name, this.position, this.token);

  final storage = FlutterSecureStorage();

  void getUserInfo() async {
    token = await storage.read(key: "aToken");
    name = await storage.read(key: "name");
    position = await storage.read(key: "position");
    profileUrl = await storage.read(key: "profileUrl");

//    print("token:" + token);
//    print("name:" + name);
//    print("position:" + position);
  }

  Future<UserData> getUserData() async {
    final storage = FlutterSecureStorage();
    UserData userData = new UserData();
    userData.name = await storage.read(key: "name");
    userData.position = await storage.read(key: "position");
    userData.token = await storage.read(key: "aToken");
    userData.profileUrl = await storage.read(key: "profileUrl");
    print("...");
    return Future.delayed(
        Duration(seconds: 3), () => userData);
  }

  Future<void> updateInfo() async {
//    print(
//      'before delay'
//    );
    final storage = FlutterSecureStorage();

    name = await storage.read(key: "name");
    position = await storage.read(key: "position");
    token = await storage.read(key: "aToken");
    profileUrl = await storage.read(key: "profileUrl");

//    print("udateInfo : notifyListeners");
//    notifyListeners();
  }

  void delUserInfo() {
    token = "";
    name = "";
    position = "";
    uuid = "";

    notifyListeners();
  }

  void writeJson(var jsonString) async {
    final storage = FlutterSecureStorage();
    Map<String, dynamic> jsonToMap = jsonString;

    for(final dataKey in jsonToMap.keys) {
      await storage.write(key: dataKey, value: jsonToMap[dataKey].toString());
      print("writeJson :"+ dataKey +":"+ jsonToMap[dataKey].toString());
    }
    getUserInfo();
    notifyListeners();
  }

  void deleteStorage() async {
    final storage = FlutterSecureStorage();
    await storage.deleteAll();

    token = "";
    name = "";
    position = "";
    uuid = "";

    notifyListeners();
  }


}