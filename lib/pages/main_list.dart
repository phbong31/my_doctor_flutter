import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_doctor/model/photo.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';


class BoardListState extends State<BoardList> {
  bool typing = false;
  List<Photo> _boardList = List<Photo>();

  @override
  void initState() {
    super.initState();
    _populateNewsArticles();
  }

  void _populateNewsArticles() {

    Webservice().load(Photo.all).then((newsArticles) => {
      setState(() => {
        _boardList = newsArticles
      })
    });

  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
      title: Image.network(Constants.PHOTO_VIEW_URL + _boardList[index].id.toString() + "?token="+Constants.TOKEN),
      subtitle: Text(_boardList[index].patientId.toString(), style: TextStyle(fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: typing ? TextBox() : Text("Title"),
          leading: IconButton(
            icon: Icon(typing ? Icons.done : Icons.search),
            onPressed: () {
              setState(() {
                typing = !typing;

              });
            },
          ),
        ),
        body: ListView.builder(

          itemCount: _boardList.length,
          itemBuilder: _buildItemsForListView,
        )
    );
  }
}

class BoardList extends StatefulWidget {

  @override
  createState() => BoardListState();
}

class TextBox extends StatelessWidget {
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
        controller: _textController,
        onSubmitted: _handleSubmitted,
        decoration:
        InputDecoration(border: InputBorder.none, hintText: 'Search'),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    print(text);
  }
}