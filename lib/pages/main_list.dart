import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_doctor/model/board_base.dart';
import 'package:my_doctor/model/photo.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/widgets/post_widget.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:my_doctor/utils/ui_utils.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<BoardBase> _boardBase = List<BoardBase>();

  @override
  void initState() {
    super.initState();
    _populateNewBoard();
  }

  void _populateNewBoard() {
    Webservice().load(BoardBase.all).then((boardBase) => {
          setState(() => {_boardBase = boardBase})
        });
  }
  List<Photo> parsePhotos(String responseBody) {
    if(responseBody != null && responseBody.length > 0) {
      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

      return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
      isThreeLine: true,
      title: Row(
        children: <Widget>[
          Text(_boardBase[index].writerName, style: TextStyle(fontSize: 16)),
          Text("(" + _boardBase[index].position + ")",
              style: TextStyle(fontSize: 14)),
        ],
      ),
      subtitle: Column(
        children: <Widget>[
          Text(_boardBase[index].createdTime),
          Text(
            _boardBase[index].text,
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
          ),
          _boardBase[index].photoList != null
              ? Text(_boardBase[index].photoList)
              : Container(),
          Text("답글 " + _boardBase[index].replyCount.toString() + "개"),
        ],
      ),
//      trailing: Icon(Icons.home),
//      leading: Icon(Icons.alarm),
      contentPadding: EdgeInsets.all(36.0),
      onTap: () {
        showSnackbar(context, "index:" + index.toString());
        print("On tap : " + index.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('어디아포?'),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return Center(child: Container(child: Text('1st tile')));
            }
//            return _buildItemsForListView(context, i - 1);
            User user = User(_boardBase[i-1].creatorId, _boardBase[i-1].writerName, _boardBase[i-1].position, _boardBase[i-1].profileUrl);
            user.position = _boardBase[i-1].position;
            user.profileUrl = _boardBase[i-1].profileUrl;
            print(_boardBase[i-1].photoList);
            return _boardBase[i-1].photoList == null ? PostWidget(_boardBase[i-1],user,null) : PostWidget(_boardBase[i-1],user,parsePhotos(_boardBase[i-1].photoList));
          },

          itemCount: _boardBase.length,
//          itemBuilder: _buildItemsForListView,
        ));
  }



}
