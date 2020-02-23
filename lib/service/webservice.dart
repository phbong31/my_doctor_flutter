import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_doctor/utils/constants.dart';

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({this.url,this.parse});
}

class Webservice {
  final storage = FlutterSecureStorage();
  String tokenString = "";

  Future<T> load<T>(Resource<T> resource) async {
//    String tokenString = await getToken();
   // bool isEmpty(tokenString) => tokenString == "" || tokenString.isEmpty;
//    print("tokenString:"+tokenString);
//    if(tokenString.isEmpty || tokenString == null) {
//      tokenString = "test";
//    }

    void getAToken() async {
      tokenString = await storage.read(key: "aToken");
   //   print("Webservice.getAToken():"+tokenString);
    }

    getAToken();

    final response = await http.get(resource.url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$tokenString',
    });
    //tokenString = Constants.TOKEN;
   // print("token:"+tokenString);
    print("http:statusCode="+response.statusCode.toString());
    if(response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

}