import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_doctor/model/board_base.dart';
import 'package:my_doctor/service/webservice.dart';


class BoardListState extends State<BoardList> {

  List<BoardBase> _boardList = List<BoardBase>();

  @override
  void initState() {
    super.initState();
    _populateNewsArticles();
  }

  void _populateNewsArticles() {

    Webservice().load(BoardBase.all).then((newsArticles) => {
      setState(() => {
        _boardList = newsArticles
      })
    });

  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
      title: _boardList[index].urlToImage == null ? Image.asset(Constants.LIST_PLACEHOLDER_IMAGE_ASSET_URL) : Image.network(_newsArticles[index].urlToImage),
      subtitle: Text(_boardList[index].title, style: TextStyle(fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lists'),
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