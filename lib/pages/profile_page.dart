import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_doctor/model/providers.dart';
import 'package:my_doctor/utils/network_utils.dart';
import 'package:my_doctor/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static final String routeName = 'profile_page';
//  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ProfilePageState extends State<ProfilePage> {
  AppState state;
  File imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (imageFile != null) {
      await _cropImage();
//      setState(() {
//        state = AppState.picked;
//      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      await _pickImageSelect(context, croppedFile);

    }
  }

  Future _pickImageSelect(BuildContext context, File image) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width *0.8,
              height: 500,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 210,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      image: DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      imageFile = image;
                      setState(() {
                        state = AppState.cropped;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "이 사진을 저장하기",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: const Color(0xFF1BC0C5),
                  ),
                  Row(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          _clearImage();
                          Navigator.of(context).pop();
                          _pickImage();
                        },
                        child: Text(
                          "다른 사진으로",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                      SizedBox(width: 20,),
                      RaisedButton(
                        onPressed: () {
                          _clearImage();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "취소",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputData = Provider.of<ProviderData>(context);

    return Scaffold(
      appBar: AppBar(title: Text('계정 정보')),
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      '당신의 프로필입니다.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      '앨범이나 카메라를 통해 당신의 사진을 올려주세요.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 210,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    image: DecorationImage(
                        image: imageFile != null ? FileImage(imageFile) : NetworkImage('${inputData.profileUrl}'),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
//                      if (state == AppState.free)
                        _pickImage();
//                      else if (state == AppState.picked)
//                        _cropImage();
//                      else if (state == AppState.cropped) _clearImage();
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    inputData.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Text(
                    inputData.position,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: RaisedButton(
                    child: Text('로그아웃'),
                    onPressed: () {
                      NetworkUtils.logoutUser(context);
                    } ,
                  ),
                ),
//          Container(
//            margin: EdgeInsets.symmetric(horizontal: 16),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Column(
//                  children: <Widget>[
//                    Text(
//                      profile.totalPost,
//                      style: TextStyle(fontWeight: FontWeight.w600),
//                    ),
//                    Text('Post')
//                  ],
//                ),
//                Column(
//                  children: <Widget>[
//                    Text(
//                      profile.totalFollowers,
//                      style: TextStyle(fontWeight: FontWeight.w600),
//                    ),
//                    Text('Followers')
//                  ],
//                ),
//                Column(
//                  children: <Widget>[
//                    Text(
//                      profile.totalFollowing,
//                      style: TextStyle(fontWeight: FontWeight.w600),
//                    ),
//                    Text('Following')
//                  ],
//                )
//              ],
//            ),
//          )
              ],
            ),
          ),
        ],
      ),
    );


  }
}
