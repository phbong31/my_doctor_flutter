import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_doctor/signup/input_data.dart';
import 'package:provider/provider.dart';

//class ThirdStep extends StatelessWidget {
//  final Function submit;
//  final TextEditingController controller = TextEditingController();
//
//  ThirdStep({this.submit});
//
//  @override
//  Widget build(BuildContext context) {
//    final inputData = Provider.of<InputData>(context);
//
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
////        TextFormField(
////          style: TextStyle(fontSize: 18.0),
////          controller: controller,
////          obscureText: true,
////          decoration: InputDecoration(
////            prefixIcon: Icon(Icons.lock),
////            labelText: 'Password',
////            hintText: 'Enter your password',
////          ),
////          validator: (String val) {
////            if (val == null || val.trim().isEmpty) {
////              return 'Need your password';
////            }
////            if (val.length < 3) {
////              return 'Password too short';
////            }
////            return null;
////          },
////          onSaved: (val) {
////            inputData.password = val;
////          },
////        ),
////        SizedBox(height: 30.0),
////        TextFormField(
////          style: TextStyle(fontSize: 18.0),
////          obscureText: true,
////          decoration: InputDecoration(
////            prefixIcon: Icon(Icons.lock),
////            labelText: 'Confirm password',
////            hintText: 'Re-enter your password',
////          ),
////          validator: (String val) {
////            if (controller.text != val) {
////              return 'Passwords not match';
////            }
////            return null;
////          },
////        ),
//
//        SizedBox(height: 30.0),
//        MaterialButton(
//          padding: EdgeInsets.symmetric(
//            horizontal: 25.0,
//            vertical: 12.0,
//          ),
//          color: Colors.indigo,
//          textColor: Colors.white,
//          child: Text(
//            'SUBMIT',
//            style: TextStyle(fontSize: 18.0),
//          ),
//          onPressed: submit,
//        ),
//
//      ],
//    );
//  }
//}

class ThirdStep extends StatefulWidget {
  final Function submit;
  final TextEditingController controller = TextEditingController();
  ThirdStep({this.submit});


  @override
  _ThirdStepState createState() => _ThirdStepState();
}

class _ThirdStepState extends State<ThirdStep> {
  File _selectedFile;
  bool _inProcess = false;


  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/images/placeholder.jpg",
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }

  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          ));

      this.setState(() {
        _selectedFile = cropped;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputData = Provider.of<InputData>(context);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getImageWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                    color: Colors.green,
                    child: Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      getImage(ImageSource.camera);
                    }),
                MaterialButton(
                    color: Colors.deepOrange,
                    child: Text(
                      "Device",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    })
              ],
            )
          ],
        ),
        (_inProcess)
            ? Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.95,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Center(),
        SizedBox(height: 30.0),
        MaterialButton(
          padding: EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 12.0,
          ),
          color: Colors.indigo,
          textColor: Colors.white,
          child: Text(
            'SUBMIT',
            style: TextStyle(fontSize: 18.0),
          ),
          onPressed: widget.submit,
        ),
      ],
    ));
  }
}
