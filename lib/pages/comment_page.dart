import 'package:flutter/material.dart';
import 'package:my_doctor/model/comment.dart';
import 'package:my_doctor/service/webservice.dart';

class CommentPage extends StatefulWidget {
  static final String routeName = 'comment_page';
  final String boardId;
  CommentPage({Key key, @required this.boardId}) : super(key: key);

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

  _buildMessageComposer() {
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
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comment'),),
      body: Center(child: Text("Comment"),),
    );
  }
}

