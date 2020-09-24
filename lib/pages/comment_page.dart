import 'package:flutter/material.dart';
import 'package:my_doctor/model/comment.dart';
import 'package:my_doctor/model/providers.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentPage extends StatefulWidget {
  static final String routeName = 'comment_page';
  final String boardId;
  final String boardOwnerId;
  CommentPage({Key key, @required this.boardId, @required this.boardOwnerId}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<Comment> _comment = List<Comment>();

  @override
  void initState() {
    super.initState();
    _populateNewComment();
    print(_comment.toString());
  }

  void _populateNewComment() {
    Webservice().loadComment(Comment.all, widget.boardId).then((comment) => {
      setState(() => {_comment = comment})
    });
  }

  _buildMessageComposer(String writerId, String token) {
    final textController = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              minLines: 2,
              maxLength: 300,
              maxLines: 4,
              controller: textController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: '코멘트 남기...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              print(textController.text);
              print(widget.boardId);
              print(widget.boardOwnerId);
              await postComment(widget.boardId.toString(), textController.text, writerId, widget.boardOwnerId, '0', token).whenComplete(() {
                print('postComment Complete');
               // Scaffold.of(context).showSnackBar(SnackBar(content: Text('코멘트 입력 완료!'),));
                setState(() {
                  _populateNewComment();
                });
              });
            },
          ),
        ],
      ),
    );
  }
  Future<void> postComment(String boardId, text, writerId, boardOwnerId, secret, token) async {
    //_showLoading();

    Map data = {
      'boardId': boardId,
      'text': text.replaceAll("\n", "\\n"),
      'writerId' : writerId,
      'boardOwnerId' : boardOwnerId,
      'secret': secret
    };
    var body = json.encode(data);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "$token"
    };
    print(body);
    var response =
    await http.post(Constants.COMMENT_POST_URL, headers: headers, body: body).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      print('200');
      print(response.body);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse["result"]);
      int result = jsonResponse["result"];

      if (jsonResponse != null && result > 0) {
       // _hideLoading();
        print('comment post completed');

      } else if (result == -1) {
        print('unauthorized');
      } else if (result == -2) {
        print('param error');
      }
    } else {
     // _hideLoading();
      print('write failed');
      print(response.body);
      //실패시
    }
  }

  static const String Subscribe = '공개등급변경';
  static const String Settings = '삭제하기';
  static const String SignOut = '신고하기';

  static const List<String> choices = <String>[
    Subscribe,
    Settings,
    SignOut
  ];


  void choiceAction(String choice, userId, writerId, commentId, token){
    if(choice == Subscribe){
      print('Settings');
    }else if(choice == Settings){
      print('삭제하기 :${commentId}');
//      print(widget.post.creatorId);
//      print(widget.userInfo.id);

      if(writerId == userId) {
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
                    onPressed: () {
                      Navigator.of(context).pop();
                      delComment(token, commentId);
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
    final inputData = Provider.of<ProviderData>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          '답글',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                    itemCount: _comment.length,
                    itemBuilder: (context, position) {
                      return commentItem(context, position, inputData.id.toString());
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(inputData.id.toString(), inputData.token), //writerId, boardId, boardOwnerId, secret, token
          ],
        ),
      ),
    );
  }

  Widget commentItem(BuildContext context, int i, String userId) {
    print('userId:'+userId);
    print('writerId:'+_comment[i].writerId.toString());

    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: _comment[i].writerId.toString() == userId ? Colors.lightBlue[50] : Color(0xFFFFEFEE),
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
                _comment[i].profileUrl),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    _comment[i].writerName,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    " ("+_comment[i].position+")  ",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    _comment[i].createdTime,
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
                _comment[i].text,
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

