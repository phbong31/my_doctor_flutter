import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({this.url,this.parse});
}

class Webservice {

  static final String TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vaHNib25nLnN5bm9sb2d5Lm1lIiwic3ViIjoiUGhvdG9Ub2tlbiIsImV4cCI6MTU4MTA3OTc2NSwianRpIjoiRDAwMDciLCJzY29wZSI6InBob3RvIiwicm9sZSI6MH0.cu8bNNhyNnf78TZNkRJtM2ewSkDc5YeL9V5ztY3Av7k";


  Future<T> load<T>(Resource<T> resource) async {

    final response = await http.get(resource.url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$TOKEN',
    });
    print("http:statusCode="+response.statusCode.toString());
    if(response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }

}