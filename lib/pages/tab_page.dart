import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:my_doctor/pages/login_page.dart';
import 'package:my_doctor/pages/login_page_kakao.dart';
import 'package:my_doctor/pages/main_list.dart';
import 'package:my_doctor/pages/photo_page.dart';
import 'package:my_doctor/pages/profile_page.dart';
import 'package:my_doctor/pages/register_page.dart';
import 'package:my_doctor/pages/signup_page.dart';
import 'package:my_doctor/pages/write_page.dart';
import 'package:my_doctor/pages/channel_page.dart';
import 'package:my_doctor/service/user_service.dart';
import 'package:my_doctor/signup/input_data.dart';
import 'package:my_doctor/signup/signup_page.dart';
import 'package:provider/provider.dart';

import '../board_list.dart';
import 'camera_page.dart';
import 'home_page.dart';

class TabPage extends StatefulWidget {
  static final String routeName = 'tab_page';

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;
  List _pages = [HomePage(), ChannelPage(), CameraPage()];

  @override
  Widget build(BuildContext context) {
//    KakaoContext.clientId = "0fe74bc1afa0a00174cf4bda8a7e5fda";

//    final inputData = Provider.of<InputData>(context);
//    inputData.getUserInfo();
//    inputData.updateInfo();
//    print("token_provider(tab_page): " + inputData.token);

    return Scaffold(
        body: SafeArea(child: Center(child: _pages[_selectedIndex])),
        bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.black,
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('홈')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.group), title: Text('내그룹')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), title: Text('내계정')),
            ]),
      );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
