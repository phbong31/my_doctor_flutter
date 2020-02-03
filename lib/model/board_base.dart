import 'dart:convert';

import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';

class BoardBase {
  final int id;
  final int creatorId;
  final String writerName;
  final String writerUserId;
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
  final int userId;

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
    this.userId});

  factory BoardBase.fromJson(Map<String, dynamic> json) {
    return BoardBase(
      id: json['id'],
      creatorId: json['creatorId'],
      writerName: json['writerName'],
      text: json['text']
    );
  }

  static Resource<List<BoardBase>> get all {
    return Resource(
        url: Constants.BOARD_LIST_URL,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result['list'];
          return list.map((model) => BoardBase.fromJson(model)).toList();
        }
    );
  }
}
