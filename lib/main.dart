import 'package:flutter/material.dart';
import 'package:my_doctor/pages/root_page.dart';

import 'insta_clone.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/common.dart';
void main() {
  KakaoContext.clientId = "0fe74bc1afa0a00174cf4bda8a7e5fda";
  KakaoContext.javascriptClientId = "a527841dd8ee52cb4318f6e389f28c9e";

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        accentColor: Colors.black,
      ),
      home: RootPage(),
    );
  }
}
