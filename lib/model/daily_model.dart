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
  final String organizationCode;
  final String workDate;
  final String viewDate;
  final String deptName;
  final String userId;
  final String userName;
  final String dayReport;
  final String nextReport;
  final String miscReport;
  final int likeQty;
  final String likeFlag;
  final int replyQty;
  final String likePerson;

  DailySelectResponseModel({
    this.organizationCode,
    this.workDate,
    this.viewDate,
    this.deptName,
    this.userId,
    this.userName,
    this.dayReport,
    this.nextReport,
    this.miscReport,
    this.likeQty,
    this.likeFlag,
    this.replyQty,
    this.likePerson,
  });

  factory DailySelectResponseModel.fromJson(Map<String, dynamic> json) {
    return DailySelectResponseModel(
      organizationCode: json['ORGANIZATION_CODE'] != null
          ? json['ORGANIZATION_CODE'] as String
          : "",
      workDate: json['WORK_DATE'] != null ? json['WORK_DATE'] as String : "",
      viewDate: json['VIEW_DATE'] != null ? json['VIEW_DATE'] as String : "",
      deptName: json['DEPT_NAME'] != null ? json['DEPT_NAME'] as String : "",
      userId:
          json['EMPLOY_ID_NO'] != null ? json['EMPLOY_ID_NO'] as String : "",
      userName: json['USER_NAME'] != null ? json['USER_NAME'] as String : "",
      dayReport: json['DAY_REPORT'] != null ? json['DAY_REPORT'] as String : "",
      nextReport:
          json['NEXT_REPORT'] != null ? json['NEXT_REPORT'] as String : "",
      miscReport:
          json['MISC_REPORT'] != null ? json['MISC_REPORT'] as String : "",
      likeQty: json['LIKE_QTY'] != null ? json['LIKE_QTY'] as int : 0,
      likeFlag: json['LIKE_FLAG'] != null ? json['LIKE_FLAG'] as String : "",
      replyQty: json['REPLY_QTY'] != null ? json['REPLY_QTY'] as int : 0,
      likePerson:
          json['LIKE_PERSON'] != null ? json['LIKE_PERSON'] as String : "",
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

class ReplyResponseModel {
  final String organizationCode;
  final String workDate;
  final String userId;
  final String replyId;
  final String userNameKor;
  final String uploadImgSajin;
  final int replyNo;
  final int groupNo;
  final int depth;
  final String replyContents;
  final int likeQty;
  final String likeFlag;
  final String creationDate;

  ReplyResponseModel(
      {this.organizationCode,
      this.workDate,
      this.userId,
      this.replyId,
      this.userNameKor,
      this.uploadImgSajin,
      this.replyNo,
      this.groupNo,
      this.depth,
      this.replyContents,
      this.likeQty,
      this.likeFlag,
      this.creationDate});

  factory ReplyResponseModel.fromJson(Map<String, dynamic> json) {
    return ReplyResponseModel(
      organizationCode: json['ORGANIZATION_CODE'] != null
          ? json['ORGANIZATION_CODE'] as String
          : "",
      workDate: json['WORK_DATE'] != null ? json['WORK_DATE'] as String : "",
      userId:
          json['EMPLOY_ID_NO'] != null ? json['EMPLOY_ID_NO'] as String : "",
      replyId: json['REPLY_ID'] != null ? json['REPLY_ID'] as String : "",
      userNameKor:
          json['USERNAME_KOR'] != null ? json['USERNAME_KOR'] as String : "",
      uploadImgSajin: json['UPLOAD_IMG_SAJIN'] != null
          ? json['UPLOAD_IMG_SAJIN'] as String
          : "",
      replyNo: json['REPLY_NO'] != null ? json['REPLY_NO'] as int : 0,
      groupNo: json['GROUP_NO'] != null ? json['GROUP_NO'] as int : 0,
      depth: json['DEPTH'] != null ? json['DEPTH'] as int : 0,
      replyContents: json['REPLY_CONTENTS'] != null
          ? json['REPLY_CONTENTS'] as String
          : "",
      likeQty: json['LIKE_QTY'] != null ? json['LIKE_QTY'] as int : 0,
      likeFlag: json['LIKE_FLAG'] != null ? json['LIKE_FLAG'] as String : "",
      creationDate:
          json['CREATION_DATE'] != null ? json['CREATION_DATE'] as String : "",
    );
  }
}

class ReplyResultModel {
  List<ReplyResponseModel> reply;

  ReplyResultModel({this.reply});

  factory ReplyResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<ReplyResponseModel> replyList =
        list.map((i) => ReplyResponseModel.fromJson(i)).toList();
    return ReplyResultModel(reply: replyList);
  }
}

class ApprovalResponseModel {
  final String unDecieded;
  final String returnApr;
  final String receive;
  final String complete;

  ApprovalResponseModel({
    this.unDecieded,
    this.returnApr,
    this.receive,
    this.complete,
  });

  factory ApprovalResponseModel.fromJson(Map<String, dynamic> json) {
    return ApprovalResponseModel(
      unDecieded: json['UNDECIDED'] != null ? json['UNDECIDED'] as String : "",
      returnApr: json['RETURN_APR'] != null ? json['RETURN_APR'] as String : "",
      receive: json['RECEIVE'] != null ? json['RECEIVE'] as String : "",
      complete: json['COMPLETE'] != null ? json['COMPLETE'] as String : "",
    );
  }
}

class ApprovalResultModel {
  List<ApprovalResponseModel> approval;

  ApprovalResultModel({this.approval});

  factory ApprovalResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<ApprovalResponseModel> approvalList =
        list.map((i) => ApprovalResponseModel.fromJson(i)).toList();
    return ApprovalResultModel(approval: approvalList);
  }
}

class InformationResponseModel {
  final String infoText;

  InformationResponseModel({
    this.infoText,
  });

  factory InformationResponseModel.fromJson(Map<String, dynamic> json) {
    return InformationResponseModel(
      infoText: json['INFO_TEXT'] != null ? json['INFO_TEXT'] as String : "",
    );
  }
}

class InformationResultModel {
  List<InformationResponseModel> information;

  InformationResultModel({this.information});

  factory InformationResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<InformationResponseModel> informationList =
        list.map((i) => InformationResponseModel.fromJson(i)).toList();
    return InformationResultModel(information: informationList);
  }
}
