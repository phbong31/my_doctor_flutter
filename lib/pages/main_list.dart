import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//import 'package:kakao_flutter_sdk/all.dart';
import 'package:my_doctor/model/board_base.dart';
import 'package:my_doctor/model/photo.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/model/providers.dart';

import 'package:my_doctor/utils/network_utils.dart';
import 'package:my_doctor/widgets/post_widget.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:my_doctor/utils/ui_utils.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<BoardBase> _boardBase = List<BoardBase>();
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _populateNewBoard();

    _controller = YoutubePlayerController(
      initialVideoId: 'CSa6Ocyog4U',
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        captionLanguage: 'kr',
      ),
    );
  }

  void _populateNewBoard() {
    Webservice().loadBoard(BoardBase.all, "").then((boardBase) => {
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

//  ListTile _buildItemsForListView(BuildContext context, int index) {
//    return ListTile(
//      isThreeLine: true,
//      title: Row(
//        children: <Widget>[
//          Text(_boardBase[index].writerName, style: TextStyle(fontSize: 16)),
//          Text("(" + _boardBase[index].position + ")",
//              style: TextStyle(fontSize: 14)),
//        ],
//      ),
//      subtitle: Column(
//        children: <Widget>[
//          Text(_boardBase[index].createdTime),
//          Text(
//            _boardBase[index].text,
//            overflow: TextOverflow.ellipsis,
//            maxLines: 5,
//          ),
//          _boardBase[index].photoList != null
//              ? Text(_boardBase[index].photoList)
//              : Container(),
//          Text("답글 " + _boardBase[index].replyCount.toString() + "개"),
//        ],
//      ),
////      trailing: Icon(Icons.home),
////      leading: Icon(Icons.alarm),
//      contentPadding: EdgeInsets.all(36.0),
//      onTap: () {
//        showSnackbar(context, "index:" + index.toString());
//        print("On tap : " + index.toString());
//      },
//    );
//  }

  @override
  Widget build(BuildContext context) {
    final inputData = Provider.of<ProviderData>(context);
//    inputData.updateInfo();
    return Scaffold(

        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(

            floating: true,
            expandedHeight: 170,
            pinned: true,
            backgroundColor: Colors.lightBlue,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(30, 2, 2, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('봉황세',
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.white)),
                        SizedBox(width: 8.0),
                        Text('(전주 수병원 정형외과 전문의)',
                            style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.blue[100])),
                      ],
                    ),

                  ],
                ),
              ),
//              child: Container(
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.vertical(
//                          top: Radius.circular(0),
//                          bottom: Radius.circular(25.0)),
//                      gradient: LinearGradient(
//                        colors: [
//                          Colors.blueAccent,
//                          Colors.purple,
//                        ],
//                      )),
//                  alignment: Alignment.bottomLeft,
//
//                  ///// flexibleSpace
//                  child: ,
//              ),
            ),

          ),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 4, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('진료안내',
                          style:
                          TextStyle(fontSize: 16.0, color: Colors.yellow)),
                      Text('예약',
                          style:
                          TextStyle(fontSize: 16.0, color: Colors.yellow)),
                      Text('글쓰기',
                          style:
                          TextStyle(fontSize: 16.0, color: Colors.yellow)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('${inputData.name} 님!',
                                style:
                                TextStyle(fontSize: 13.0, color: Colors.white)),
                            SizedBox(width: 7.0),
                            GestureDetector(
                              onTap: () {
                                NetworkUtils.logoutUser(context);
                              },
                              child: CircleAvatar(
                                radius: 18.0,
                                backgroundImage:
                                NetworkImage('${inputData.profileUrl}'),
                              ),
                            ),
                            SizedBox(width: 5.0)
//                      FlatButton(
//                        onPressed: () {
//                          NetworkUtils.logoutUser(context);
////                    Navigator.pushNamed(context, "YourRoute");
//                        },
//                        child: Text("로그아웃"),
//                      ),
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ),
          ),

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
              if (idx == 0) {
                return Container(
                    margin: EdgeInsets.only(bottom: 24.0),
                    child: YouTubePost());
              } else {
                return Container(
                    margin: EdgeInsets.only(bottom: 24.0),
                    child: MainPost(idx, inputData.token));
              }
            }, childCount: _boardBase.length),
          ),
        ],
      ),
    ));
  }

  Widget YouTubePost() {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
//                progressColors: ProgressColors(
//                  playedColor: Colors.amber,
//                  handleColor: Colors.amberAccent,
//                ),
      onReady: () {
        print('Player is ready.');
      },
    );
  }

  Widget MainPost(int i, String token) {
    User user = User(_boardBase[i - 1].creatorId, _boardBase[i - 1].writerName,
        _boardBase[i - 1].position, _boardBase[i - 1].profileUrl);
    user.position = _boardBase[i - 1].position;
    user.profileUrl = _boardBase[i - 1].profileUrl;
    print(_boardBase[i - 1].photoList);
    return _boardBase[i - 1].photoList == null
        ? PostWidget(_boardBase[i - 1], user, null, token, null)
        : PostWidget(_boardBase[i - 1], user,
            parsePhotos(_boardBase[i - 1].photoList), token, null);
  }

}
