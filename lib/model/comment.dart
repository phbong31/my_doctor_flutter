import 'dart:convert';

import 'package:my_doctor/model/providers.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';

class Comment {
  final int id;
  final int boardId;
  final String text;
  final int photoId;
  final int status;
  final String createdTime;
  final String updatedTime;
  final int boardOwnerId;
  final int secret;
  final int writerId;
  final String writerName;
  final String profileUrl;
  final String position;

  Comment({
    this.id,
    this.boardId,
    this.text,
    this.photoId,
    this.status,
    this.createdTime,
    this.updatedTime,
    this.writerId,
    this.boardOwnerId,
    this.secret,
    this.writerName,
    this.profileUrl,
    this.position
});


  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        boardId: json['boardId'],
        text: json['text'] != null ? json['text'].replaceAll("\\n", "\n") : "",
        photoId: json['photoId'],
        status: json['status'],
        createdTime: json['createdTime'],
        updatedTime: json['updatedTIme'],
        writerId: json['writerId'], //comment writer
        boardOwnerId: json['boardOwnerId'],
        secret: json['secret'],
        writerName: json['writerName'],
        profileUrl: json['profileUrl'],
        position: json['position']

    );
  }

  static Resource<List<Comment>> get all {
    return Resource(
        url: Constants.COMMENT_LIST_URL,
        parse: (response) {
          print(response.body);
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => Comment.fromJson(model)).toList();
        }
    );
  }
}
