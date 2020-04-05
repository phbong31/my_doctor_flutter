import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_doctor/pages/root_page.dart';

import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:my_doctor/signup/input_data.dart';
import 'package:provider/provider.dart';

void main() {
  KakaoContext.clientId = "0fe74bc1afa0a00174cf4bda8a7e5fda";
//  KakaoContext.javascriptClientId = "a527841dd8ee52cb4318f6e389f28c9e";

//  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
//    runApp(RootPage());
//  });
  runApp(RootPage());
}
