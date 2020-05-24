import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_doctor/pages/channel_page.dart';
import 'package:my_doctor/model/providers.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

//Our MyApp. Extends StatelessWidget
class ChannelWrite extends StatefulWidget {
  @override
  _ChannelWriteState createState() => _ChannelWriteState();
}

class _ChannelWriteState extends State<ChannelWrite> {
  @override
  Widget build(BuildContext context) {
    final group = Provider.of<ProviderData>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('글을 입력하세요'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MrMultiLineTextFieldAndButton(
              channelId: group.groupId,
            ),
//              child: _isLoading ? _loadingScreen() : MrMultiLineTextFieldAndButton(),
          ),
        ],
      ),
    );
  }
}

/// Multi-line text field widget with a submit button
/// `StatefulWidegt` is a widget that has mutable state.
class MrMultiLineTextFieldAndButton extends StatefulWidget {
//  MrMultiLineTextFieldAndButton({Key key}) : super(key: key);
  final String channelId;

  MrMultiLineTextFieldAndButton({Key key, @required this.channelId})
      : super(key: key);

  @override
  createState() => _TextFieldAndButtonState();
}

// State is information that can be read synchronously when the widget is built and that might change during the lifetime of the widget.
// It is the logic and internal state for a `StatefulWidget`.
class _TextFieldAndButtonState extends State<MrMultiLineTextFieldAndButton> {
  //`TextEditingController` A controller for an editable text field.
  // Whenever the user modifies a text field with an associated `TextEditingController`,
  //the text field updates value and the controller notifies its listeners.
  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();
  bool _isLoading = false;

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  /// Displays text in a snackbar
  _showInSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final inputData = Provider.of<ProviderData>(context, listen: false);
    return _isLoading
        ? _loadingScreen()
        : Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            //color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _multiLineTextFieldcontroller,
                  maxLines: 10,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: '글 입력 후 저장하기를 누르세요',
                  ),
//            onChanged: (str) => print('Multi-line text change: $str'),
//            onSubmitted: (str) => print('This will not get called when return is pressed'),
                ),
                SizedBox(height: 10.0),
                FlatButton(
                  onPressed: () {
                    print('button');
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            title: Text('글을 저장하시겠습니까?'),
//                            content: Text('테스트'),
                            actions: <Widget>[
                              FlatButton(
                                child: new Text("취소"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("저장"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  write(inputData.token,_multiLineTextFieldcontroller.text,widget.channelId);
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: const Text('저장하기'),
                ),
              ],
            ),
          );
  }

  Future<void> write(String token, text, groupId) async {
    _showLoading();

    Map data = {
      'text': text.replaceAll("\n", "\\n"),
      'type': '2',
      'groupId': groupId
    };
    var body = json.encode(data);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "$token"
    };
    var response =
        await http.post(Constants.WRITE_URL, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('200');
      print(response.body);
      var jsonResponse = json.decode(response.body);
      print(jsonResponse["result"]);
      int result = jsonResponse["result"];

      if (jsonResponse != null && result > 0) {
        _hideLoading();
        print('write completed');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChannelPage(
                    channelId: groupId,
                  )),
        );
//        Scaffold.of(context).showSnackBar(SnackBar(content: Text('글이 저장되었습니다.'),));
      } else if (result == -1) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('글 쓰기 권한이 없습니다'),
        ));
      }
    } else {
      _hideLoading();
      print('write failed');
      print(response.body);
      //실패시

    }
  }

  Widget _loadingScreen() {
    return Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(strokeWidth: 4.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                '글을 저장 중입니다..',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16.0),
              ),
            )
          ],
        )));
  }
}
