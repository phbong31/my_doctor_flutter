import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_doctor/pages/tab_page.dart';
import 'package:my_doctor/signup/input_data.dart';
import 'package:my_doctor/signup/signup_page.dart';

import 'login_page.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => InputData(),

      child: MaterialApp(
        title: 'Authentication Flow',
        theme: ThemeData(
            primaryColor: Colors.green.shade500,
            textSelectionColor: Colors.green.shade500,
            buttonColor: Colors.green.shade500,
            accentColor: Colors.green.shade500,
            bottomAppBarColor: Colors.white),
//      home: LoginPage(),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          TabPage.routeName: (BuildContext context) => TabPage(),
          SignUpPage.routeName: (BuildContext context) => SignUpPage()
        },
      ),
    );
  }
}
