import 'package:flutter/material.dart';
import 'package:my_doctor/pages/tab_page.dart';

import 'login_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Authentication Flow',
      theme: new ThemeData(
          primaryColor: Colors.green.shade500,
          textSelectionColor: Colors.green.shade500,
          buttonColor: Colors.green.shade500,
          accentColor: Colors.green.shade500,
          bottomAppBarColor: Colors.white
      ),
//      home: LoginPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        TabPage.routeName: (BuildContext context) => TabPage()
      },
    );
  }
}