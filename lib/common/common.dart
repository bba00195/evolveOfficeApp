class User {
  String organizationCode; // 사업부 코드
  String userId; // 사용자 ID
  String nameKor; // 한글 이름
  String eMail; // 이메일
  String password; // 비밀번호
  String deptCode; // 부서코드
  String deptName; // 부서명
  String gradeCode; // 직급코드
  String gradeName; // 직급명
  String mobileTel; // 휴대폰번호

  User({
    this.organizationCode,
    this.userId,
    this.nameKor,
    this.eMail,
    this.password,
    this.deptCode,
    this.deptName,
    this.gradeCode,
    this.gradeName,
    this.mobileTel,
  });
}

class UserManager {
  User _user;

  // ignore: unnecessary_getters_setters
  User get user => _user;

  // ignore: unnecessary_getters_setters
  set user(User user) {
    _user = user;
  }
}
