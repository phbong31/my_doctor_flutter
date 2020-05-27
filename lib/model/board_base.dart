import 'dart:convert';

import 'package:my_doctor/model/providers.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';

class BoardBase {
  final int id;
  final int creatorId;
  final String writerName;
  final int writerUserId;
  final String profileUrl;
  final String kImageUrl;
  final int patientId;
  final int status;
  final String text;
  final int type;
  final int replyCount;
  final int userType;
  final int userLevel;
  final int accessLevel;
  final String position;
  final int groupId;
//  final String groupName;
  final int userId;
  final String photoList;
  final String createdTime;
  final String updatedTime;
  final int boardPatientId;
  final String youtubeLink;

//  final photos = <Photo>[];

  BoardBase({
    this.id,
    this.creatorId,
    this.writerName,
    this.writerUserId,
    this.profileUrl,
    this.kImageUrl,
    this.patientId,
    this.status,
    this.text,
    this.type,
    this.replyCount,
    this.userType,
    this.userLevel,
    this.accessLevel,
    this.position,
    this.groupId,
//    this.groupName,
    this.userId,
    this.photoList,
    this.createdTime,
    this.updatedTime,
    this.boardPatientId,
    this.youtubeLink});



  factory BoardBase.fromJson(Map<String, dynamic> json) {
    return BoardBase(
      id: json['id'],
      creatorId: json['creatorId'],
      writerName: json['writerName'],
      profileUrl: json['profileUrl'],
      kImageUrl: json['kImageUrl'],
      patientId: json['patientId'],
      status: json['status'],
        text: json['text'] != null ? json['text'].replaceAll("\\n", "\n") : "",
        type: json['type'],
        replyCount: json['replyCount'],
        userType: json['userType'],
        userLevel: json['userLevel'],
        accessLevel: json['accessLevel'],
        position: json['position'],
        groupId: json['groupId'],
//        groupName: json['groupName'],
        userId: json['userId'],
        photoList: json['photoList'],
        youtubeLink: json['youtubeLink'],
      createdTime: json['createdTime'],
        updatedTime: json['updatedTIme'],
        boardPatientId: json['boardPatientId']
    );
  }


  static Resource<List<BoardBase>> get all {
    return Resource(
        url: Constants.BOARD_LIST_URL,
        parse: (response) {
          print(response.body);
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => BoardBase.fromJson(model)).toList();
        }
    );
  }
}
