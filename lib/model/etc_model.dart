class CartypeResponseModel {
  final String codeName;
  final String codeValue;

  CartypeResponseModel({
    this.codeName,
    this.codeValue,
  });

  factory CartypeResponseModel.fromJson(Map<String, dynamic> json) {
    return CartypeResponseModel(
      codeName: json['CODE_NAME'] != null ? json['CODE_NAME'] as String : "",
      codeValue: json['CODE_VALUE'] != null ? json['CODE_VALUE'] as String : "",
    );
  }
}

class CartypeResultModel {
  List<CartypeResponseModel> carType;

  CartypeResultModel({this.carType});

  factory CartypeResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<CartypeResponseModel> carTypeList =
        list.map((i) => CartypeResponseModel.fromJson(i)).toList();
    return CartypeResultModel(carType: carTypeList);
  }
}

class DeptResponseModel {
  final String organizationCode;
  final String deptCode;
  final String deptName;
  final String deptColor;

  DeptResponseModel({
    this.organizationCode,
    this.deptCode,
    this.deptName,
    this.deptColor,
  });

  factory DeptResponseModel.fromJson(Map<String, dynamic> json) {
    return DeptResponseModel(
      organizationCode: json['ORGANIZATION_CODE'] != null
          ? json['ORGANIZATION_CODE'] as String
          : "",
      deptCode: json['DEPT_CODE'] != null ? json['DEPT_CODE'] as String : "",
      deptName: json['DEPT_NAME'] != null ? json['DEPT_NAME'] as String : "",
      deptColor: json['ATTRIBUTE5'] != null ? json['ATTRIBUTE5'] as String : "",
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
