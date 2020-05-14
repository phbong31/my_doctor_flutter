import 'package:flutter/material.dart';
import 'package:my_doctor/pages/login_page_kakao.dart';
import 'package:my_doctor/pages/register_page.dart';
import 'package:my_doctor/pages/splash_page.dart';
import 'package:my_doctor/pages/tab_page.dart';
import 'package:my_doctor/pages/write_page.dart';
import 'package:my_doctor/signup/input_data.dart';
import 'package:my_doctor/signup/signup_page.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => InputData(),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Authentication Flow',
        theme: ThemeData(
            primaryColor: Colors.blue.shade500,
            textSelectionColor: Colors.blue.shade500,
            buttonColor: Colors.blue.shade500,
            accentColor: Colors.blueAccent,
            bottomAppBarColor: Colors.white),
//      home: LoginPage(),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          TabPage.routeName: (BuildContext context) => TabPage(),
          LoginScreen.routeName: (BuildContext context) => LoginScreen(),
          SignUpPage.routeName: (BuildContext context) => RegisterScreen(),
          WritePage.routeName: (BuildContext context) => WritePage()

        },
      ),
    );
  }
}
