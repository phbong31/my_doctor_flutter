import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_doctor/model/group.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/signup/input_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//import 'package:kakao_flutter_sdk/all.dart';
import 'package:my_doctor/model/board_base.dart';
import 'package:my_doctor/model/photo.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/signup/input_data.dart';
import 'package:my_doctor/utils/network_utils.dart';
import 'package:my_doctor/widgets/post_widget.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:my_doctor/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BoardBase> _boardBase = List<BoardBase>();
  List<Group> _group = List<Group>();

  @override
  void initState() {
    super.initState();
    _populateNewBoard();

  }

  void _populateNewBoard() {
    Webservice().load(Group.all).then((group) => {
      setState(() => {_group = group})
    });
    Webservice().load(BoardBase.all).then((boardBase) => {
      setState(() => {_boardBase = boardBase})
    });
  }

  //photoList(json) parse to List
  List<Photo> parsePhotos(String responseBody) {
    if (responseBody != null && responseBody.length > 0) {
      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

      return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
    } else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    final inputData = Provider.of<InputData>(context);
//    inputData.updateInfo();
    return Scaffold(
        body: Row(
          children: <Widget>[

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  SliverAppBar(
                    title: Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                    floating: true,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('${inputData.name} 님!'),
                              SizedBox(width: 10.0),
                              GestureDetector(
                                onTap: () {
                                  NetworkUtils.logoutUser(context);
                                },
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundImage: NetworkImage('${inputData.profileUrl}'),

                                ),
                              ),
                              SizedBox(width: 20.0)
//                      FlatButton(
//                        onPressed: () {
//                          NetworkUtils.logoutUser(context);
////                    Navigator.pushNamed(context, "YourRoute");
//                        },
//                        child: Text("로그아웃"),
//                      ),
                            ],
                          )),
                    ),
                    expandedHeight: 100,
                  ),
                ],
              ),
            ),

            //group view
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: <Widget>[
                  //group List
                  SliverList(
                    delegate:
                    SliverChildBuilderDelegate((BuildContext context, int idx) {
                      return Container(
                          margin: EdgeInsets.only(bottom: 24.0),
                          child: MainPost(idx, inputData.token));

                    }, childCount: _boardBase.length),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  // divider
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                      height: 2.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey[300], Colors.white],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )),
                    ),
                  ),
                  SliverList(
                    delegate:
                    SliverChildBuilderDelegate((BuildContext context, int idx) {
                        return Container(
                            margin: EdgeInsets.only(bottom: 24.0),
                            child: MainPost(idx, inputData.token));

                    }, childCount: _boardBase.length),
                  ),
                ],
              ),
            ),
          ],
        ));
  }


  Widget MainPost(int i, String token) {
    User user = User(_boardBase[i - 1].creatorId, _boardBase[i - 1].writerName,
        _boardBase[i - 1].position, _boardBase[i - 1].profileUrl);
    user.position = _boardBase[i - 1].position;
    user.profileUrl = _boardBase[i - 1].profileUrl;
    print(_boardBase[i - 1].photoList);
    return _boardBase[i - 1].photoList == null
        ? PostWidget(_boardBase[i - 1], user, null, token)
        : PostWidget(_boardBase[i - 1], user,
        parsePhotos(_boardBase[i - 1].photoList), token);
  }

//  Widget ListViewWidget() {
//    final inputData = Provider.of<InputData>(context);
//    return Container(
//        child: ListView.separated(
//      separatorBuilder: (context, index) => Divider(
//        color: Colors.brown[50],
//        height: 24.0,
//        thickness: 12.0,
////            indent: 4.0,
////            endIndent: 4.0,
//      ),
//      itemBuilder: (ctx, i) {
//        if (i == 0) {
//          return YoutubePlayer(
//            controller: _controller,
//            showVideoProgressIndicator: true,
//            progressIndicatorColor: Colors.amber,
////                progressColors: ProgressColors(
////                  playedColor: Colors.amber,
////                  handleColor: Colors.amberAccent,
////                ),
//            onReady: () {
//              print('Player is ready.');
//            },
//          );
//        }
////            return _buildItemsForListView(context, i - 1);
//        User user = User(
//            _boardBase[i - 1].creatorId,
//            _boardBase[i - 1].writerName,
//            _boardBase[i - 1].position,
//            _boardBase[i - 1].profileUrl);
//        user.position = _boardBase[i - 1].position;
//        user.profileUrl = _boardBase[i - 1].profileUrl;
//        print(_boardBase[i - 1].photoList);
//        return _boardBase[i - 1].photoList == null
//            ? PostWidget(_boardBase[i - 1], user, null, inputData.token)
//            : PostWidget(_boardBase[i - 1], user,
//                parsePhotos(_boardBase[i - 1].photoList), inputData.token);
//      },
//
//      itemCount: _boardBase.length,
////          itemBuilder: _buildItemsForListView,
//    ));
//  }
}
