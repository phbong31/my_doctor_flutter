import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_doctor/model/comment.dart';
import 'package:my_doctor/model/providers.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/pages/comment_page.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:my_doctor/utils/ui_utils.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final String userId;
  final String token;
  final String boardId;

  CommentWidget(this.comment, this.userId, this.boardId, this.token);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {


  static const String Subscribe = '공개등급변경';
  static const String Settings = '삭제하기';
  static const String SignOut = '신고하기';

  static const List<String> choices = <String>[
    Subscribe,
    Settings,
    SignOut
  ];


  void choiceAction(String choice){
    if(choice == Subscribe){
      print('Settings');
    }else if(choice == Settings){
      print('삭제하기 :${widget.comment.id}');
//      print(widget.post.creatorId);
//      print(widget.userInfo.id);

      if(widget.comment.writerId == widget.userId) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                title: Text('글을 삭제하시겠습니까?'),
//                            content: Text('테스트'),
                actions: <Widget>[
                  FlatButton(
                    child: new Text("취소"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await delComment(widget.token, widget.comment.id);

                      //delBoard.jsp
                    },
                    child: Text(
                      "삭제하기",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: const Color(0xFF1BC0C5),
                  )
                ],
              );
            });
      }

    }else if(choice == SignOut){
      print('SignOut');
    }
  }

  Future<void> delComment(String token, commentId) async {
//  _showLoading();
    //print(token);
    print(commentId);
    Map<String, String> headers = {
//      "Content-type": "application/json",
      "authorization": "$token"
    };
    var response = await http.post(
        Constants.DELETE_COMMENT_URL, headers: headers, body: {
      "commentId": commentId.toString()
    }).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      print('200');
      print(response.body);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse["result"]);
      int result = jsonResponse["result"];

      if (jsonResponse != null && result > 0) {
//      _hideLoading();
        print('delete completed');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CommentPage(
                    boardId: widget.boardId.toString(),
                  )),
        );
//        Scaffold.of(context).showSnackBar(SnackBar(content: Text('글이 저장되었습니다.'),));
      } else if (result == -1) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('삭제 권한이 없습니다'),
        ));
      }
    } else {
//    _hideLoading();
      print('삭제 실패 - 토큰 권한 및 파라미터 확인 요함');
      print(response.body);
      //실패시
    }
  }
  @override
  Widget build(BuildContext context) {

    //글 올린 시간 계산
    var today = DateTime.now();
    var createdDate = DateTime.parse(widget.comment.createdTime);
    final mins = today.difference(createdDate).inMinutes;
    final hours = today.difference(createdDate).inHours;
    final days = today.difference(createdDate).inDays;
    String difference = '';

    if (mins < 1) {
      difference = '방금';
    } else if (mins < 60) {
      difference = '$mins분';
    } else if (mins >= 60 && hours < 24) {
      difference = '$hours시간';
    } else if (hours >= 24 && hours < 1440) {
      difference = '$days일';
    } else if (days >= 60) {
      double diff = days/30;
      difference = '${diff.round()}개월';
    }

    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: widget.comment.writerId.toString() == widget.userId ? Colors.lightBlue[50] : Color(0xFFFFEFEE),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 22.0,
            backgroundImage: NetworkImage(
                widget.comment.profileUrl),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    widget.comment.writerName,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    " ("+widget.comment.position+")  ",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    widget.comment.createdTime,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: choiceAction,
                    itemBuilder: (BuildContext context) {
                      return choices.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  )
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                widget.comment.text,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
