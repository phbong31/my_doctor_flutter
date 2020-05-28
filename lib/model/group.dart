import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';

class Group {
  final int id;
  final int groupType;
  final int parentGroupId;
  final String parentGroupName;
  final String parentGroupIconUrl;
  final String groupName;
  final String groupText;
  final String groupIconUrl;
  final String groupDetailPhotoUrl1;
  final String groupDetailPhotoUrl2;
  final String groupDetailPhotoUrl3;
  final int adminUserId;
  final int presidentUserId;
  final int secret;
  final String createdTime;
  final int defaultUserLevel;
  final int accessLevel;
  final int groupId;
  final int userId;
  final int userLevel;
  final String joinDate;
  final int joinCount;

  Group({this.id, this.groupType, this.parentGroupId, this.parentGroupName, this.parentGroupIconUrl, this.groupName, this.groupText,
      this.groupIconUrl, this.groupDetailPhotoUrl1,this.groupDetailPhotoUrl2,this.groupDetailPhotoUrl3, this.adminUserId,
      this.presidentUserId, this.secret, this.createdTime,
      this.defaultUserLevel, this.accessLevel, this.groupId, this.userId,
      this.userLevel, this.joinDate, this.joinCount});


  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
        id: json['id'],
        groupType: json['groupType'],
        parentGroupId: json['parentGroupId'],
        parentGroupName: json['parentGroupName'],
        parentGroupIconUrl: json['parentGroupIconUrl'],
        groupName: json['groupName'],
        groupText: json['groupText'],
        groupIconUrl: json['groupIconUrl'],
        groupDetailPhotoUrl1: json['groupDetailPhotoUrl1'],
        groupDetailPhotoUrl2: json['groupDetailPhotoUrl2'],
        groupDetailPhotoUrl3: json['groupDetailPhotoUrl3'],
        adminUserId: json['adminUserId'],
        presidentUserId: json['presidentUserId'],
        secret: json['secret'],
        createdTime: json['createdTime'],
        defaultUserLevel: json['defaultUserLevel'],
        accessLevel: json['accessLevel'],
        groupId: json['groupId'],
        userId: json['userId'],
        userLevel: json['userLevel'],
        joinDate: json['joinDate'],
        joinCount: json['joinCount']
    );
  }

  static Resource<List<Group>> get all {

    return Resource(
        url: Constants.GROUP_LIST_URL + "?param=all",

        parse: (response) {
          print(response.body.toString());
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => Group.fromJson(model)).toList();
        }
    );
  }
  static Resource<List<Group>> get my {

    return Resource(
        url: Constants.GROUP_LIST_URL + "?param=my",

        parse: (response) {
          print(response.body.toString());
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => Group.fromJson(model)).toList();
        }
    );
  }

}