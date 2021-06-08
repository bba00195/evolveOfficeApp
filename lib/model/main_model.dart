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

class BoardResponseModel {
  final String workDate;
  final String type;
  final String title;
  final String contents;
  final String hitCount;
  final String maker;
  final String boardType;

  BoardResponseModel({
    this.workDate,
    this.type,
    this.title,
    this.contents,
    this.hitCount,
    this.maker,
    this.boardType,
  });

  factory BoardResponseModel.fromJson(Map<String, dynamic> json) {
    return BoardResponseModel(
      workDate: json['WORK_DATE'] != null ? json['WORK_DATE'] as String : "",
      type: json['TYPE'] != null ? json['TYPE'] as String : "",
      title: json['TITLE'] != null ? json['TITLE'] as String : "",
      contents: json['CONTENTS'] != null ? json['CONTENTS'] as String : "",
      hitCount: json['HIT_COUNT'] != null ? json['HIT_COUNT'] as String : "",
      maker: json['MAKER'] != null ? json['MAKER'] as String : "",
      boardType: json['BOARD_TYPE'] != null ? json['BOARD_TYPE'] as String : "",
    );
  }
}

class BoardResultModel {
  List<BoardResponseModel> board;

  BoardResultModel({this.board});

  factory BoardResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<BoardResponseModel> boardList =
        list.map((i) => BoardResponseModel.fromJson(i)).toList();
    return BoardResultModel(board: boardList);
  }
}
