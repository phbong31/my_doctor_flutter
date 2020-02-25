import 'package:flutter/material.dart';
import 'package:my_doctor/camera/camera_screen.dart';

const Color barColor = const Color(0x20000000);

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final _cameraKey = GlobalKey<CameraScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: CameraScreen(
        key: _cameraKey,
      ),
    );
  }
}