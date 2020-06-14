import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_doctor/model/board_base.dart';
import 'package:my_doctor/model/photo.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/pages/write_page.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:my_doctor/utils/network_utils.dart';
import 'package:my_doctor/widgets/post_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';
import 'package:my_doctor/model/providers.dart';

class ChannelMain extends StatefulWidget {
  final String channelId;
  const ChannelMain({Key key, this.channelId}) : super(key: key);

  @override
  _ChannelMainState createState() => _ChannelMainState();
}

class _ChannelMainState extends State<ChannelMain> {

  List<BoardBase> _boardBase = List<BoardBase>();
  YoutubePlayerController _controller;
  String _groupIdProvided ='';

  @override
  void initState() {
    super.initState();
    final inputData = Provider.of<ProviderData>(context, listen: false);
    _populateNewBoard(inputData.groupId);
    _groupIdProvided = inputData.groupId;

    _controller = YoutubePlayerController(
      initialVideoId: 'CSa6Ocyog4U',
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        captionLanguage: 'kr',
      ),
    );
  }

  Future<void> _getData() async {
    setState(() {
      _populateNewBoard(_groupIdProvided);
    });
  }

  void _populateNewBoard(String id) {
    print('channelId:$id');
    Webservice().loadBoard(BoardBase.all, id).then((boardBase) => {
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
    final inputData = Provider.of<ProviderData>(context, listen: false);

    return _boardBase.length != 0
    ? RefreshIndicator(
      onRefresh: _getData,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 5),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('${inputData.name} 님 반갑습니다!',
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.black38)),

//                      FlatButton(
//                        onPressed: () {
//                          NetworkUtils.logoutUser(context);
////                    Navigator.pushNamed(context, "YourRoute");
//                        },
//                        child: Text("로그아웃"),
//                      ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text('주치의와 소통하는 ${inputData.name} 님의 전용 공간입니다',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black54)),
                          SizedBox(height: 5),
                          Text('이 곳에서 쓴 글은 주치의에게만 보입니다.',
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.red[700])),
                        ],
                      ),
                    ))),

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

//          SliverList(
//            delegate:
//            SliverChildBuilderDelegate((BuildContext context, int idx) {
//              if (idx == 0) {
//                return Container(
//                    margin: EdgeInsets.only(bottom: 24.0),
//                    child: YouTubePost());
//              } else {
//                return Container(
//                    margin: EdgeInsets.only(bottom: 24.0),
//                    child: MainPost(idx, inputData.token));
//              }
//            }, childCount: _boardBase.length),
//          ),

            //게시글
            SliverPadding(
              padding: EdgeInsets.all(3.0),
              sliver: SliverList(
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, int idx) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 1.0),
                      child: Card(
                          elevation: 2, child: MainPost(idx, inputData.token)));
                }, childCount: _boardBase.length),
              ),
            ),
          ],
        ),
      ),
    )
        : Center(child: CircularProgressIndicator());
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
    User user = User(id:_boardBase[i].creatorId, name:_boardBase[i].writerName,
        position:_boardBase[i].position, profileUrl:_boardBase[i].profilePhotoId!=0?Constants.PHOTO_VIEW_URL+_boardBase[i].profilePhotoId.toString()+'?token='+token:null);
//    user.position = _boardBase[i].position;
//    user.profileUrl = _boardBase[i].profileUrl;
//    print(_boardBase[i].photoList);
    return _boardBase[i].photoList == null
        ? PostWidget(_boardBase[i], user, null, token)
        : PostWidget(
            _boardBase[i], user, parsePhotos(_boardBase[i].photoList), token);
  }
}
