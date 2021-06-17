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
  String imgSajin; // 휴대폰번호
  String token; //토큰

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
    this.imgSajin,
    this.token,
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

class Date {
  DateTime dateTime; //  대한민국 시간 기준
  String year; //년
  String month; //월
  String day; //일
  String weekday; //요일

  String result; //날짜

  String getDate(int day) {
    // dateTime = DateTime.now().add(Duration(hours: 9, days: day));
    dateTime = DateTime.now().add(Duration(days: day));
    return getDateString(dateTime);
  }

  String getDateString(DateTime datetime) {
    year = datetime.year.toString();
    month = datetime.month.toString();
    day = datetime.day.toString();

    switch (datetime.weekday) {
      case 1:
        weekday = "(월)";
        break;
      case 2:
        weekday = "(화)";
        break;
      case 3:
        weekday = "(수)";
        break;
      case 4:
        weekday = "(목)";
        break;
      case 5:
        weekday = "(금)";
        break;
      case 6:
        weekday = "(토)";
        break;
      case 7:
        weekday = "(일)";
        break;
      default:
        break;
    }
    return year + ". " + month + ". " + day + weekday;
  }

  String date(DateTime date) {
    // ex) 20210401
    if (date == null) {
      // dateTime = DateTime.now().add(Duration(hours: 9));
      dateTime = DateTime.now();
    } else {
      dateTime = date;
    }
    year = dateTime.year.toString();
    month = dateTime.month.toString().padLeft(2, '0');
    day = dateTime.day.toString().padLeft(2, '0');
    result = year + month + day;

    return result;
  }

  String dateWeek(DateTime date) {
    //  ex) 2021년 4월 1일 목요일
    if (date == null) {
      dateTime = DateTime.now();
    } else {
      dateTime = date;
    }
    switch (dateTime.weekday) {
      case 1:
        weekday = "월요일";
        break;
      case 2:
        weekday = "화요일";
        break;
      case 3:
        weekday = "수요일";
        break;
      case 4:
        weekday = "목요일";
        break;
      case 5:
        weekday = "금요일";
        break;
      case 6:
        weekday = "토요일";
        break;
      case 7:
        weekday = "일요일";
        break;
      default:
        break;
    }
    year = dateTime.year.toString();
    month = dateTime.month.toString();
    day = dateTime.day.toString();
    result = year + "년 " + month + "월 " + day + "일 " + weekday;

    return result;
  }
}
