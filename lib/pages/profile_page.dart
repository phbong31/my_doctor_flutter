import 'package:flutter/material.dart';
import 'package:my_doctor/model/providers.dart';
import 'package:my_doctor/utils/network_utils.dart';
import 'package:my_doctor/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static final String routeName = 'profile_page';
//  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inputData = Provider.of<ProviderData>(context);

    return Scaffold(
      appBar: AppBar(title: Text('계정 정보')),
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      '당신의 프로필입니다.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      '프로필 사진을 앨범이나 카메라를 통해 올려주세요.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 210,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    image: DecorationImage(
                        image: NetworkImage('${inputData.profileUrl}'),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
                      print('camera');
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    inputData.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Text(
                    inputData.position,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: RaisedButton(
                    child: Text('로그아웃'),
                    onPressed: () {
                      NetworkUtils.logoutUser(context);
                    } ,
                  ),
                ),
//          Container(
//            margin: EdgeInsets.symmetric(horizontal: 16),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Column(
//                  children: <Widget>[
//                    Text(
//                      profile.totalPost,
//                      style: TextStyle(fontWeight: FontWeight.w600),
//                    ),
//                    Text('Post')
//                  ],
//                ),
//                Column(
//                  children: <Widget>[
//                    Text(
//                      profile.totalFollowers,
//                      style: TextStyle(fontWeight: FontWeight.w600),
//                    ),
//                    Text('Followers')
//                  ],
//                ),
//                Column(
//                  children: <Widget>[
//                    Text(
//                      profile.totalFollowing,
//                      style: TextStyle(fontWeight: FontWeight.w600),
//                    ),
//                    Text('Following')
//                  ],
//                )
//              ],
//            ),
//          )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
