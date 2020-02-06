import 'dart:convert';

import 'package:my_doctor/service/webservice.dart';
import 'package:my_doctor/utils/constants.dart';

class Photo {
  final int id;
  final int patientId;
  final String doctor;
  final String uploader;
  final String classification;
  final String date;
  final String photoUrl;
  final String sync;
  final String caption;
  final String name;
  final String thumbnailFilename;
  final String newFilename;
  final String size;
  final String thumbnailSize;
  final String url;
  final String thumbnailUrl;
  final String contentType;
  final String search;
  final String captureDate;
  final String range;
  final int boardId;
  final int photoId;

  Photo({this.id, this.patientId, this.doctor, this.uploader,
      this.classification, this.date, this.photoUrl, this.sync, this.caption,
      this.name, this.thumbnailFilename, this.newFilename, this.size,
      this.thumbnailSize, this.url, this.thumbnailUrl, this.contentType,
      this.search, this.captureDate, this.range, this.boardId, this.photoId});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        id: json['id'] as int,
        photoId: json['photoId'] as int,
        photoUrl: json['photoUrl'] as String,
        caption: json['caption'] as String,
        boardId: json['boardId'] as int
    );
  }

  static Resource<List<Photo>> get all {
    return Resource(
        url: Constants.PHOTO_LIST_URL,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result[''];
          return list.map((model) => Photo.fromJson(model)).toList();
        }
    );
  }
}