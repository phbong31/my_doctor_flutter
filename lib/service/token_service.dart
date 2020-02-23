import 'package:flutter_secure_storage/flutter_secure_storage.dart';

 class Token {
  String sampleToken = "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vaHNib25nLnN5bm9sb2d5Lm1lIiwic3ViIjoiUGhvdG9Ub2tlbiIsImV4cCI6MTU4MjI4OTM3NCwianRpIjoiRDAwMDciLCJzY29wZSI6InBob3RvIiwicm9sZSI6MH0.TQbDkSdxeSDUtgJHYwy2XMH6NORw8fRSwyuhS6URORI";

  static void writeToken(String token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: "aToken", value: token);
    print("Write Token to Secure Storage");
  }

  static Future<String> getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: "aToken");
  }

}