import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:my_doctor/model/group.dart';
import 'package:my_doctor/pages/channel_page.dart';
import 'package:my_doctor/pages/profile_page.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/model/providers.dart';
import 'package:provider/provider.dart';
import 'package:my_doctor/model/board_base.dart';
import 'package:my_doctor/model/photo.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/utils/network_utils.dart';
import 'package:my_doctor/widgets/post_widget.dart';
import 'package:my_doctor/widgets/channel_dialog.dart';

class PatientPage extends StatefulWidget {
  static final String routeName = 'patient_page';

  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
//  List<BoardBase> _boardBase = List<BoardBase>();
  List<Group> _group = List<Group>();

  @override
  void initState() {
    super.initState();
    _populateNewBoard();
  }

  Future<void> _getData() async {
    setState(() {
      _populateNewBoard();
    });
  }

  //API 연결
  void _populateNewBoard() {
    Webservice().loadGroup(Group.my).then((group) => {
          setState(() => {_group = group})
        });
//    Webservice().loadBoardAll(BoardBase.all).then((boardBase) => {
//      setState(() => {_boardBase = boardBase})
//    });
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
    final inputData = Provider.of<ProviderData>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: _group.length != 0
            ? RefreshIndicator(
                onRefresh: _getData,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      title: Image(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                      floating: true,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: Container(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(0),
                                    bottom: Radius.circular(20.0)),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.blueAccent,
                                  ],
                                )),
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text('${inputData.name} 님!'),
                                    SizedBox(width: 10.0),
                                    CircleAvatar(
                                      radius: 14.0,
                                      backgroundImage: NetworkImage(
                                          '${inputData.profileUrl}'),
                                    ),
                                    SizedBox(width: 20.0)
                                  ],
                                ),
                              ),
                            )),
                      ),
                      expandedHeight: 100,
                    ),

                    SliverToBoxAdapter(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 5),
                      child: Text('내 그룹 목록  (총 ${_group.length}개)'),
                    )),

                    //그룹 카드 리스트
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 350,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _group.length,
                            itemBuilder: (context, index) {
                              return groupPost(context, index);
                            },
                          ),
                        ),
                      ),
                    ),

//              SliverToBoxAdapter(
//                  child: Padding(
//                    padding: EdgeInsets.fromLTRB(10, 30, 0, 5),
//                    child: Text('최신 글'),
//                  )),

                    //게시글
//              SliverPadding(
//                padding: EdgeInsets.all(3.0),
//                sliver: SliverList(
//                  delegate: SliverChildBuilderDelegate(
//                          (BuildContext context, int idx) {
//                        return Container(
//                            margin: EdgeInsets.only(bottom: 1.0),
//                            child: Card(
//                                elevation: 2,
//                                child: mainPost(idx, inputData.token)));
//                      }, childCount: _boardBase.length),
//                ),
//              ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget groupPost(BuildContext context, int i) {
    return GestureDetector(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            width: 150.0,
            child: myGroupCard(i)),

        // 그룹 선택 이벤트
        onTap: () {
          print('groupId: ${_group[i].id.toString()}');
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => ChannelPage(channelId: _group[i].id.toString())),
//          );
          ChannelDialog.channelNotice(context, _group[i].id);
        });
  }

  Widget myGroupCard(int i) {
    return Card(
      elevation: 5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _group[i].groupIconUrl != null
              ? Container(
                  width: 100,
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl: _group[i].groupIconUrl == null
                        ? 'http://hsbong.synology.me:8080/profile/logo.png'
                        : _group[i].groupIconUrl,
                    fit: BoxFit.fill,
                    height: 110,
//              width: BoxFit.contain,
//              width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : AssetImage('assets/images/placeholder.jpg'),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_group[i].groupName, style: TextStyle(fontSize: 15)),
                SizedBox(
                  height: 3,
                ),
                Text(_group[i].groupText, style: TextStyle(fontSize: 10)),
                SizedBox(
                  height: 5,
                ),
                _group[i].joinDate != null
                    ? Text(_group[i].joinDate, style: TextStyle(fontSize: 10))
                    : Container(),
                SizedBox(
                  height: 5,
                ),
                Text(_group[i].joinCount.toString(),
                    style: TextStyle(fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget groupCardIcon(int i) {
    return Card(
      elevation: 5,
      child: Column(
        children: <Widget>[
          _group[i].joinCount == 0
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('가입하기'),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('가입중'),
                ),
          CachedNetworkImage(
            imageUrl: _group[i].groupIconUrl == null
                ? 'http://hsbong.synology.me:8080/profile/logo.png'
                : _group[i].groupIconUrl,
            fit: BoxFit.fill,
            height: 110,
//              width: BoxFit.contain,
//              width: MediaQuery.of(context).size.width,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(_group[i].groupName)),
        ],
      ),
    );
  }

  Widget groupCardNoIcon(int i) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _group[i].joinCount == 0
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('가입하기'),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text('가입중'),
                ),
          Center(child: Text(_group[i].groupName)),
        ],
      ),
    );
  }

//  Widget mainPost(int i, String token) {
//    User user = User(_boardBase[i].creatorId, _boardBase[i].writerName,
//        _boardBase[i].position, _boardBase[i].profileUrl);
//    user.position = _boardBase[i].position;
//    user.profileUrl = _boardBase[i].profileUrl;
////    print(_boardBase[i].photoList);
//    return _boardBase[i].photoList == null
//        ? PostWidget(_boardBase[i], user, null, token)
//        : PostWidget(
//        _boardBase[i], user, parsePhotos(_boardBase[i].photoList), token);
//  }
}
