class User {
  int id;
  String name;
  int birth;
  String phone;
  String password;
  String email;
  String uniqueId;
  int department_id;
  String department;
  String signupDate;
  String mDate;
  int userLevel;
  int role;
  String profileUrl;
  String kImageUrl;
  String position;
  String token;

//  User(this.id, this.name, this.position, this.profileUrl);

  User({this.id, this.name, this.birth, this.phone, this.password, this.email,
      this.uniqueId, this.department_id, this.department, this.signupDate,
      this.mDate, this.userLevel, this.role, this.profileUrl, this.kImageUrl,
      this.position, this.token});

}