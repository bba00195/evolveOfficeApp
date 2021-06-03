class WhereResponseModel {
  final String userName;
  final String startTime;
  final String endTime;
  final String area;
  final String whereIsContents;
  final String carType;
  final String carTypeName;

  WhereResponseModel({
    this.userName,
    this.startTime,
    this.endTime,
    this.area,
    this.whereIsContents,
    this.carType,
    this.carTypeName,
  });

  factory WhereResponseModel.fromJson(Map<String, dynamic> json) {
    return WhereResponseModel(
      userName: json['USER_NAME'] != null ? json['USER_NAME'] as String : "",
      startTime: json['START_TIME'] != null ? json['START_TIME'] as String : "",
      endTime: json['END_TIME'] != null ? json['END_TIME'] as String : "",
      area: json['AREA'] != null ? json['AREA'] as String : "",
      whereIsContents: json['WHEREIS_CONTENTS'] != null
          ? json['WHEREIS_CONTENTS'] as String
          : "",
      carType: json['CAR_TYPE'] != null ? json['CAR_TYPE'] as String : "",
      carTypeName:
          json['CAR_TYPE_NAME'] != null ? json['CAR_TYPE_NAME'] as String : "",
    );
  }
}

class WhereResultModel {
  List<WhereResponseModel> whereIs;

  WhereResultModel({this.whereIs});

  factory WhereResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<WhereResponseModel> whereIsList =
        list.map((i) => WhereResponseModel.fromJson(i)).toList();
    return WhereResultModel(whereIs: whereIsList);
  }
}
