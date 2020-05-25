import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_doctor/model/board_base.dart';
import 'package:my_doctor/model/photo.dart';
import 'package:my_doctor/model/user.dart';
import 'package:my_doctor/utils/constants.dart';
import 'package:my_doctor/utils/ui_utils.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'avartar_widget.dart';

class YoutubeWidget extends StatefulWidget {

  final String videoLink;

  YoutubeWidget(this.videoLink);

  @override
  _YoutubeWidgetState createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<YoutubeWidget> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
       _controller = YoutubePlayerController(
      initialVideoId: widget.videoLink,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        captionLanguage: 'kr',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,

      onReady: () {
        print('Player is ready.');
      },
    );
  }
}

