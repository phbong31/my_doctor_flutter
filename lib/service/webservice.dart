import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({this.url,this.parse});
}

class Webservice {

  static final String token = "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vaHNib25nLnN5bm9sb2d5Lm1lIiwic3ViIjoiUGhvdG9Ub2tlbiIsImV4cCI6MTU3OTQyMjcxMiwianRpIjoiRDAwMDciLCJzY29wZSI6InBob3RvIiwicm9sZSI6MH0.EhHPN-tTc9iPjw8M7qb6r7X1H9iXRRF7_E_fAYeEKmg";


  Future<T> load<T>(Resource<T> resource) async {

    final response = await http.get(resource.url);
    if(response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

}