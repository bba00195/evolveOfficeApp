class DailyResponseModel {
  final String organizationCode;
  final String workDate;
  final String userId;
  final String dayReport;
  final String nextReport;
  final String miscReport;
  final String projectId;
  final String linkMeetingNo;
  final String linkFileNo;

  DailyResponseModel({
    this.organizationCode,
    this.workDate,
    this.userId,
    this.dayReport,
    this.nextReport,
    this.miscReport,
    this.projectId,
    this.linkMeetingNo,
    this.linkFileNo,
  });

  factory DailyResponseModel.fromJson(Map<String, dynamic> json) {
    return DailyResponseModel(
      organizationCode: json['ORGANIZATION_CODE'] != null
          ? json['ORGANIZATION_CODE'] as String
          : "",
      workDate: json['WORK_DATE'] != null ? json['WORK_DATE'] as String : "",
      userId:
          json['EMPLOY_ID_NO'] != null ? json['EMPLOY_ID_NO'] as String : "",
      dayReport: json['DAY_REPORT'] != null ? json['DAY_REPORT'] as String : "",
      nextReport:
          json['NEXT_REPORT'] != null ? json['NEXT_REPORT'] as String : "",
      miscReport:
          json['MISC_REPORT'] != null ? json['MISC_REPORT'] as String : "",
      projectId: json['PROJECT_ID'] != null ? json['PROJECT_ID'] as String : "",
      linkMeetingNo: json['LINK_MEETING_NO'] != null
          ? json['LINK_MEETING_NO'] as String
          : "",
      linkFileNo:
          json['LINK_FILE_NO'] != null ? json['LINK_FILE_NO'] as String : "",
    );
  }
}

class DailyResultModel {
  List<DailyResponseModel> day;

  DailyResultModel({this.day});

  factory DailyResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<DailyResponseModel> dayList =
        list.map((i) => DailyResponseModel.fromJson(i)).toList();
    return DailyResultModel(day: dayList);
  }
}

class InsertResponseModel {
  final String rsCode;
  final String rsMsg;

  InsertResponseModel({
    this.rsCode,
    this.rsMsg,
  });

  factory InsertResponseModel.fromJson(Map<String, dynamic> json) {
    return InsertResponseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class InsertResultModel {
  List<InsertResponseModel> result;

  InsertResultModel({this.result});

  factory InsertResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<InsertResponseModel> resultList =
        list.map((i) => InsertResponseModel.fromJson(i)).toList();
    return InsertResultModel(result: resultList);
  }
}

class DailySelectResponseModel {
  final String workDate;
  final String viewDate;
  final String deptName;
  final String userName;
  final String dayReport;
  final String nextReport;
  final String miscReport;

  DailySelectResponseModel({
    this.workDate,
    this.viewDate,
    this.deptName,
    this.userName,
    this.dayReport,
    this.nextReport,
    this.miscReport,
  });

  factory DailySelectResponseModel.fromJson(Map<String, dynamic> json) {
    return DailySelectResponseModel(
      workDate: json['WORK_DATE'] != null ? json['WORK_DATE'] as String : "",
      viewDate: json['VIEW_DATE'] != null ? json['VIEW_DATE'] as String : "",
      deptName: json['DEPT_NAME'] != null ? json['DEPT_NAME'] as String : "",
      userName: json['USER_NAME'] != null ? json['USER_NAME'] as String : "",
      dayReport: json['DAY_REPORT'] != null ? json['DAY_REPORT'] as String : "",
      nextReport:
          json['NEXT_REPORT'] != null ? json['NEXT_REPORT'] as String : "",
      miscReport:
          json['MISC_REPORT'] != null ? json['MISC_REPORT'] as String : "",
    );
  }
}

class DailySelectResultModel {
  List<DailySelectResponseModel> dailySelect;

  DailySelectResultModel({this.dailySelect});

  factory DailySelectResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<DailySelectResponseModel> dailySelectList =
        list.map((i) => DailySelectResponseModel.fromJson(i)).toList();
    return DailySelectResultModel(dailySelect: dailySelectList);
  }
}
