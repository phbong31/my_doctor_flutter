import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_doctor/model/user_info.dart';

class UserService {

  static void writeToken(String token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: "aToken", value: token);
    print("Write Token to Secure Storage");
  }

  static Future<String> getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: "aToken");
  }

  static Future<UserData> getUserInfo() async {
    final storage = FlutterSecureStorage();
    UserData userData = new UserData();
    userData.id = int.parse(await storage.read(key: "id"));
    userData.name = await storage.read(key: "name");
    userData.position = await storage.read(key: "position");
    userData.token = await storage.read(key: "aToken");
//    userData.id = await storage.read(key: "id");

    return userData;
  }
}