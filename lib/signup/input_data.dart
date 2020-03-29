import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_doctor/model/user_info.dart';

class InputData with ChangeNotifier {
  String name = '';
  String email = '';
  String gender = 'Male';
  String dateOfBirth = '';
  String password = '';
  String position = '';
  String token = '';
  String profileUrl = '';

  //InputData(this.name, this.position, this.token);

  final storage = FlutterSecureStorage();

  void getUserInfo() async {
    token = await storage.read(key: "aToken");
    name = await storage.read(key: "name");
    position = await storage.read(key: "position");
//    print("token:" + token);
//    print("name:" + name);
//    print("position:" + position);

//    notifyListeners();
  }

  Future<UserData> getUserData() async {
    final storage = FlutterSecureStorage();
    UserData userData = new UserData();
    userData.name = await storage.read(key: "name");
    userData.position = await storage.read(key: "position");
    userData.token = await storage.read(key: "aToken");
    print("...");
    return Future.delayed(
        Duration(seconds: 3), () => userData);
  }

  void updateInfo() async {
    print(
      'before delay'
    );
    final userData = await getUserData();
    name = userData.name;
    position = userData.position;
    token = userData.token;

    print("udateInfo : notifyListeners");
//    notifyListeners();
  }

  void delUserInfo() {
    token = "";
    name = "";
    position = "";

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

    notifyListeners();
  }

}