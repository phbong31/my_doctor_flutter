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

  BoardBase(
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
      this.userId);


}
