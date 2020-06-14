import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_doctor/utils/constants.dart';

class User {
  int id;
  String name;
  int birth;
  String phone;
  String password;
  String email;
  String uniqueId;
  int department_id;
  String department;
  String signupDate;
  String mDate;
  int userLevel;
  int role;
  String profileUrl;
  String kImageUrl;
  String position;
  String token;
  int photoId; //profilePhotoId

//  User(this.id, this.name, this.position, this.profileUrl);

  User({this.id, this.name, this.birth, this.phone, this.password, this.email,
      this.uniqueId, this.department_id, this.department, this.signupDate,
      this.mDate, this.userLevel, this.role, this.profileUrl, this.kImageUrl,
      this.position, this.token, this.photoId});

  static Future<User> getUserInfo() async {
    final storage = FlutterSecureStorage();
    return User(id:int.parse(await storage.read(key: "id")),
        name: await storage.read(key: "name"),
        position: await storage.read(key: "position"),
        profileUrl: Constants.PHOTO_VIEW_URL + await storage.read(key: "photoId") + "?token="+ await storage.read(key: "aToken"));
  }
}

