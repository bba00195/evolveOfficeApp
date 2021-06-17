class DeptResponseModel {
  final String organizationCode;
  final String deptCode;
  final String deptName;

  DeptResponseModel({
    this.organizationCode,
    this.deptCode,
    this.deptName,
  });

  factory DeptResponseModel.fromJson(Map<String, dynamic> json) {
    return DeptResponseModel(
      organizationCode: json['ORGANIZATION_CODE'] != null
          ? json['ORGANIZATION_CODE'] as String
          : "",
      deptCode: json['DEPT_CODE'] != null ? json['DEPT_CODE'] as String : "",
      deptName: json['DEPT_NAME'] != null ? json['DEPT_NAME'] as String : "",
    );
  }
}

class DeptResultModel {
  List<DeptResponseModel> dept;

  DeptResultModel({this.dept});

  factory DeptResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<DeptResponseModel> deptList =
        list.map((i) => DeptResponseModel.fromJson(i)).toList();
    return DeptResultModel(dept: deptList);
  }
}
