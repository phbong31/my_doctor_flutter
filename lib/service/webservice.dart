
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_doctor/utils/constants.dart';

class Resource<T> {
  final String url;
  final String token;
  T Function(Response response) parse;

  Resource({this.url,this.token,this.parse});
}

class Webservice {
  final storage = FlutterSecureStorage();
  String tokenString = "";

  Future<String> getAToken() async {
    return tokenString = await storage.read(key: "aToken");
    //   print("Webservice.getAToken():"+tokenString);
  }


  getToken() {
    getAToken().then((token) {
      print("!@#!@#!@#!@#!"+token);
    });
  }



  Future<T> load<T>(Resource<T> resource) async {

    await getAToken();
    final response = await http.get(resource.url+'?token='+tokenString, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });
    //tokenString = Constants.TOKEN;
   // print("token:"+tokenString);
    print(resource.url+'?token='+tokenString);
    print("http:statusCode="+response.statusCode.toString());
    if(response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

}