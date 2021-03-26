class UserResponseModel {
  final String organizationCode;
  final String userId;
  final String nameKor;
  final String email;
  final String password;
  final String deptCode;
  final String deptName;
  final String gradeCode;
  final String gradeName;
  final String mobileTel;

  UserResponseModel({
    this.organizationCode,
    this.userId,
    this.nameKor,
    this.email,
    this.password,
    this.deptCode,
    this.deptName,
    this.gradeCode,
    this.gradeName,
    this.mobileTel,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      organizationCode: json['ORGANIZATION_CODE'] != null
          ? json['ORGANIZATION_CODE'] as String
          : "",
      userId: json['USERID'] != null ? json['USERID'] as String : "",
      nameKor:
          json['USERNAME_KOR'] != null ? json['USERNAME_KOR'] as String : "",
      email: json['E_MAIL'] != null ? json['E_MAIL'] as String : "",
      password: json['PASSWORD'] != null ? json['PASSWORD'] as String : "",
      deptCode: json['DEPT_CODE'] != null ? json['DEPT_CODE'] as String : "",
      deptName: json['DEPT_NAME'] != null ? json['DEPT_NAME'] as String : "",
      gradeCode: json['GRADE_CODE'] != null ? json['GRADE_CODE'] as String : "",
      gradeName: json['GRADE_NAME'] != null ? json['GRADE_NAME'] as String : "",
      mobileTel: json['MOBILE_TEL'] != null ? json['MOBILE_TEL'] as String : "",
    );
  }
}

class ResultModel {
  List<UserResponseModel> user;

  ResultModel({this.user});

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<UserResponseModel> userList =
        list.map((i) => UserResponseModel.fromJson(i)).toList();
    return ResultModel(user: userList);
  }
}
