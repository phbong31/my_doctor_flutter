import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {

  static void writeJson(var jsonString) async {
    final storage = FlutterSecureStorage();
    Map<String, dynamic> jsonToMap = jsonString;

    for(final dataKey in jsonToMap.keys) {
      await storage.write(key: dataKey, value: jsonToMap[dataKey].toString());
      print("writeJson :"+ dataKey +":"+ jsonToMap[dataKey].toString());
    }
  }

  static void deleteStorage() async {
    final storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
 // Map<String, String> allValues = await storage.readAll();
}