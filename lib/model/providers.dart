import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/model/user_info.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';

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
  int id;

  String groupId = '';

  User getUserFromProvider () {
    User user = User(id:id, name:this.name, position:this.position, profileUrl:this.profileUrl);
    notifyListeners();
    print('name:$name');
    return user;
  }

  void setProfileUrl() async {
    profileUrl = Constants.PHOTO_VIEW_URL + await storage.read(key: "photoId") + "?token="+ token;
    notifyListeners();

  }

  void setGroupId(String id) {
    groupId = id;

    notifyListeners();
  }

  //InputData(this.name, this.position, this.token);

  final storage = FlutterSecureStorage();

  Future<void> getUserInfo() async {
    id = int.parse(await storage.read(key: "id"));
    token = await storage.read(key: "aToken");
    name = await storage.read(key: "name");
    position = await storage.read(key: "position");
    profileUrl = Constants.PHOTO_VIEW_URL + await storage.read(key: "photoId") + "?token="+ token;

//    print("token:" + token);
//    print("name:" + name);
//    print("position:" + position);
  }

  Future<UserData> getUserData() async {
    final storage = FlutterSecureStorage();
    UserData userData = new UserData();

    userData.id = int.parse(await storage.read(key: "id"));
    userData.name = await storage.read(key: "name");
    userData.position = await storage.read(key: "position");
    userData.token = await storage.read(key: "aToken");
    userData.profileUrl = Constants.PHOTO_VIEW_URL + await storage.read(key: "photoId") + "?token="+ userData.token;
    print("...");
    return Future.delayed(
        Duration(seconds: 3), () => userData);
  }

  Future<void> updateInfo() async {
//    print(
//      'before delay'
//    );
    final storage = FlutterSecureStorage();

    id = int.parse(await storage.read(key: "id"));
    name = await storage.read(key: "name");
    position = await storage.read(key: "position");
    token = await storage.read(key: "aToken");
    profileUrl = Constants.PHOTO_VIEW_URL + await storage.read(key: "photoId") + "?token="+ await storage.read(key: "aToken");

//    print("udateInfo : notifyListeners");
//    notifyListeners();
  }

  void delUserInfo() {
    id = 0;
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

    id = 0;
    token = "";
    name = "";
    position = "";
    uuid = "";

    notifyListeners();
  }


}