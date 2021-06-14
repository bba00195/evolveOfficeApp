import 'package:evolveofficeapp/model/main_model.dart';
import 'package:evolveofficeapp/model/whereis_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_model.dart';
import '../model/daily_model.dart';

class APIServiceNew {
  var url = Uri.parse('https://www.kuls.co.kr/flutter/DBHelper_secure.php');
  String token = "ba7da079703c28825269ae6d44fc7fa3";

  Future getSelect(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode({
      "TYPE": "SELECT",
      "FUNCNAME": sFunctionName,
      "TOKEN": token,
      "PARAMS": sParam
    });
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "LOGIN_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ResultModel.fromJson(json.decode(response.body));
        break;
      case "REPORT_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = DailyResultModel.fromJson(json.decode(response.body));
        break;
      case "WHEREIS_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = WhereResultModel.fromJson(json.decode(response.body));
        break;
      case "DAILY_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = DailySelectResultModel.fromJson(json.decode(response.body));
        break;
      case "BOARD_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = BoardResultModel.fromJson(json.decode(response.body));
        break;
      case "INFORMATION_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InformationResultModel.fromJson(json.decode(response.body));
        break;
      case "APPROVAL_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ApprovalResultModel.fromJson(json.decode(response.body));
        break;
      case "DAILYREPLY_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ReplyResultModel.fromJson(json.decode(response.body));
        break;
      case "DAILYREPLY_S2":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ReplyResultModel.fromJson(json.decode(response.body));
        break;
      default:
        break;
    }
    return result;
  }

  Future getInsert(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode({
      "TYPE": "INSERT",
      "FUNCNAME": sFunctionName,
      "TOKEN": token,
      "PARAMS": sParam
    });
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "DAYREPORT_I1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "DAYREPORT_I2":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "NEXTREPORT_I1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "WHEREIS_I1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "WHEREIS_I2":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "DAILYREPLY_I1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "DAILYREPLY_I2":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      default:
        break;
    }
    return result;
  }

  Future getUpdate(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode({
      "TYPE": "UPDATE",
      "FUNCNAME": sFunctionName,
      "TOKEN": token,
      "PARAMS": sParam
    });
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "DAYREPORT_U1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "NEXTREPORT_U1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "WHEREIS_U1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "WHEREIS_U2":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "PROFILE_U1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "DAILYLIKE_U1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "REPLYLIKE_U1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "DAILYREPLY_U1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      default:
        break;
    }
    return result;
  }

  Future getDelete(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode({
      "TYPE": "DELETE",
      "FUNCNAME": sFunctionName,
      "TOKEN": token,
      "PARAMS": sParam
    });
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "DAYREPORT_D1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "WHEREIS_D1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      case "DAILYREPLY_D1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = InsertResultModel.fromJson(json.decode(response.body));
        break;
      default:
        break;
    }
    return result;
  }

  Future<DailySelectResultModel> dailySelect(String sStartDate, String sEndDate,
      String sUserId, String sDeptCode, String sOrganizationCode) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "SELECT",
          "PROCEDURE": "Y",
          "QUERY": "PS_GET_DAILYMONTH_V2",
          "TOKEN": token,
          "PARAMS": [
            sStartDate,
            sEndDate,
            "WK_DAILYMONTH",
            sUserId,
            "",
            "",
            sDeptCode,
            "",
            sOrganizationCode
          ]
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return DailySelectResultModel.fromJson(
      json.decode(response.body),
    );
  }
}
