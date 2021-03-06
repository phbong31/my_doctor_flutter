import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/pages/channel_page.dart';
import 'package:my_doctor/model/providers.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'avartar_widget.dart';

//Our MyApp. Extends StatelessWidget
class ChannelWrite extends StatefulWidget {
  @override
  _ChannelWriteState createState() => _ChannelWriteState();
}

class Item {
  const Item(this.name, this.icon);

  final String name;
  final Icon icon;
}

class _ChannelWriteState extends State<ChannelWrite> {
//  @override
//  void initState() {
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<ProviderData>(context);
    User user = group.getUserFromProvider();

    Item selectedUser;
    List<Item> users = <Item>[
      const Item(
          '현재 채널 주치의에게 쓰기',
          Icon(
            Icons.person,
            color: const Color(0xFF167F67),
          )),
      const Item(
          '칭찬/불만 쓰기',
          Icon(
            Icons.thumbs_up_down,
            color: const Color(0xFF167F67),
          )),
      const Item(
          '채널 전체 공개',
          Icon(
            Icons.accessibility_new,
            color: const Color(0xFF167F67),
          )),
      const Item(
          '특정인에게 보내기',
          Icon(
            Icons.local_post_office,
            color: const Color(0xFF167F67),
          )),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              AvatarWidget(
                  user: user, isLarge: true, isShowingUsernameLabel: false),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      '${group.name}님!',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    child: DropdownButton<Item>(
                      hint: Text("누구에게 쓰실래요? : $selectedUser"),
                      value: selectedUser,
                      onChanged: (Item Value) {
                        setState(() {
                          selectedUser = Value;
                        });
                      },
                      items: users.map((Item user) {
                        return DropdownMenuItem<Item>(
                          value: user,
                          child: Row(
                            children: <Widget>[
                              user.icon,
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                user.name,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ],
          ),
//          Padding(
//            padding: const EdgeInsets.all(18.0),
//            child: Text('글을 입력하세요'),
//          ),
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
  final TextEditingController _youtubeLinkController = TextEditingController();

  bool _isLoading = false;
  bool _isLink = false;

//  File _image;

  //////////////////////////////////////////////////////////////////////

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

//  setStatus(String message) {
//    setState(() {
//      status = message;
//    });
//  }


  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());

          print(base64Image);
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
  //////////////////////////////////////////////////////////////////////

  Future getImage() async {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 30);
    });
  }

  Future getImageFromGallery() async {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    });
  }

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
                      hintText: '여기에 글을 쓴 뒤 \'작성완료\'를 누르세요',
                      hintStyle: TextStyle(color: Colors.grey)),
//            onChanged: (str) => print('Multi-line text change: $str'),
//            onSubmitted: (str) => print('This will not get called when return is pressed'),
                ),
                SizedBox(height: 10.0),
                //link, photo button
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _isLink
                          ? Container()
                          : IconButton(
                              icon: Icon(Icons.add_a_photo),
                              iconSize: 30,
                              color: Colors.blueAccent,
                              onPressed: () {
                                getImageFromGallery();
                              },
                            ),
                      file == null
                          ? IconButton(
                              icon: Icon(Icons.link),
                              iconSize: 30,
                              color: Colors.blue[700],
                              onPressed: () {
                                setState(() {
                                  if (_isLink) {
                                    _isLink = false;
                                    _youtubeLinkController.text = '';
                                  } else {
                                    _isLink = true;
                                  }
                                });
                              },
                            )
                          : showImage(),
                      _isLink
                          ? Container(
                              width: 260,
                              child: TextField(
                                controller: _youtubeLinkController,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Youtube link를 입력하세요',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
//            onChanged: (str) => print('Multi-line text change: $str'),
//            onSubmitted: (str) => print('This will not get called when return is pressed'),
                              ),
                            )
                          : Container(
                              width: 200,
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  child: Text(
                    "작성완료",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: const Color(0xFF1BC0C5),
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
                              RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  write(
                                      inputData.token,
                                      _multiLineTextFieldcontroller.text,
                                      widget.channelId, _youtubeLinkController.text);
                                  startUpload();
                                },
                                child: Text(
                                  "저장하기",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: const Color(0xFF1BC0C5),
                              )
                            ],
                          );
                        });
                  },
                )
              ],
            ),
          );
  }

  int photoId;

  Future<void> write(String token, text, groupId, youtubeLink) async {
    _showLoading();

    int type = 2;
    if(file!=null) {
      photoId = await startUpload();
      print('write() photoId : $photoId');
      type = 1;
    } else {
      photoId = 0;
    }

    Map data = {
      'text': text.replaceAll("\n", "\\n"),
      'type': type.toString(),
      'groupId': groupId,
      'youtubeLink' : youtubeLink,
      'photoId' : photoId.toString()
    };
    var body = json.encode(data);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "authorization": "$token"
    };
    var response =
        await http.post(Constants.WRITE_URL, headers: headers, body: body).timeout(const Duration(seconds: 2));

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

  Future<int> startUpload() async {
//    setStatus('Uploading Image...');
    if (null == tmpFile) {
//      setStatus(errMessage);
    }
    String fileName = tmpFile.path.split('/').last;

    await http.post(Constants.PHOTO_UPLOAD_URL, body: {
      "image": base64Image,
      "filename": fileName,
      "classification": 'app',
      "uploader": 'app'
    }).timeout(const Duration(seconds: 30)).then((result) {
//      setStatus(result.statusCode == 200 ? result.body : errMessage);

      if (result.statusCode == 200) {
        var jsonResponse = json.decode(result.body);
        photoId = jsonResponse["result"];
//        print('upload() photoId : $photoId');
      } else {
        print(result.statusCode);
        photoId = -1;
      }
    }).catchError((error) {
      photoId=-2;
//      setStatus(error.toString());
    });
    return photoId;
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
