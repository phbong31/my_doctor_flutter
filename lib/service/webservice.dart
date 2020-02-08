import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_doctor/utils/constants.dart';

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({this.url,this.parse});
}

class Webservice {

  String tokenString = Constants.TOKEN;
  Future<T> load<T>(Resource<T> resource) async {

    final response = await http.get(resource.url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$tokenString',
    });
    print("http:statusCode="+response.statusCode.toString());
    if(response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

}