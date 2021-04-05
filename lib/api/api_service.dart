import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_model.dart';
import '../model/daily_model.dart';

class APIService {
  String url = "https://www.kuls.co.kr/DBHelper.php";
  String token = "ba7da079703c28825269ae6d44fc7fa3";

  Future<ResultModel> login(String sUserId) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "SELECT",
          "QUERY": "SELECT ORGANIZATION_CODE, " +
              "USERID, " +
              "USERNAME_KOR, " +
              "E_MAIL, " +
              "PASSWORD, " +
              "DEPT_CODE, " +
              "DEPT_NAME, " +
              "GRADE_CODE, " +
              "GRADE_NAME, " +
              "MOBILE_TEL " +
              "FROM tb_admin_user " +
              "WHERE USERID = '" +
              sUserId +
              "'",
          "TOKEN": token,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return ResultModel.fromJson(
      json.decode(response.body),
    );
  }

  Future<DailyResultModel> report(
      String sOrganizationCode, String sUserId, String sWorkDate) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "SELECT",
          "QUERY": "SELECT ORGANIZATION_CODE, " +
              "WORK_DATE, " +
              "EMPLOY_ID_NO, " +
              "DAY_REPORT, " +
              "NEXT_REPORT, " +
              "MISC_REPORT, " +
              "PROJECT_ID, " +
              "LINK_MEETING_NO, " +
              "LINK_FILE_NO  " +
              "FROM TB_WORK_DAILYREPORT " +
              "WHERE ORGANIZATION_CODE = '" +
              sOrganizationCode +
              "'" +
              " AND WORK_DATE = '" +
              sWorkDate +
              "'" +
              "  AND EMPLOY_ID_NO =  '" +
              sUserId +
              "'",
          "TOKEN": token,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return DailyResultModel.fromJson(
      json.decode(response.body),
    );
  }

  Future<InsertResultModel> dayReportInsert(String sOrganizationCode,
      String sUserId, String sWorkDate, String sDayReport) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "INSERT",
          "QUERY":
              "INSERT INTO TB_WORK_DAILYREPORT (ORGANIZATION_CODE, WORK_DATE,  EMPLOY_ID_NO, DAY_REPORT, CREATED_BY, CREATION_DATE)" +
                  "VALUES (?, ?,  ?,  ?,  ?,  GETDATE())",
          "TOKEN": token,
          "PARAMS": [sOrganizationCode, sWorkDate, sUserId, sDayReport, sUserId]
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return InsertResultModel.fromJson(
      json.decode(response.body),
    );
  }

  Future<InsertResultModel> dayReportUpdate(String sOrganizationCode,
      String sUserId, String sWorkDate, String sDayReport) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "UPDATE",
          "QUERY":
              "UPDATE TB_WORK_DAILYREPORT SET DAY_REPORT = (?), LAST_UPDATED_BY = (?), LAST_UPDATE_DATE = GETDATE() " +
                  "WHERE ORGANIZATION_CODE = (?) AND WORK_DATE =(?) AND EMPLOY_ID_NO = (?)",
          "TOKEN": token,
          "PARAMS": [sDayReport, sUserId, sOrganizationCode, sWorkDate, sUserId]
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return InsertResultModel.fromJson(
      json.decode(response.body),
    );
  }

  Future<InsertResultModel> dayReportDelete(
      String sOrganizationCode, String sUserId, String sWorkDate) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "DELETE",
          "QUERY":
              "DELETE TB_WORK_DAILYREPORT WHERE ORGANIZATION_CODE = (?) AND WORK_DATE =(?) AND EMPLOY_ID_NO = (?)",
          "TOKEN": token,
          "PARAMS": [sOrganizationCode, sWorkDate, sUserId]
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return InsertResultModel.fromJson(
      json.decode(response.body),
    );
  }

  Future<InsertResultModel> nextReportInsert(String sOrganizationCode,
      String sUserId, String sWorkDate, String sDayReport) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "INSERT",
          "QUERY":
              "INSERT INTO TB_WORK_DAILYREPORT (ORGANIZATION_CODE, WORK_DATE,  EMPLOY_ID_NO, NEXT_REPORT, CREATED_BY, CREATION_DATE)" +
                  "VALUES (?, ?,  ?,  ?,  ?,  GETDATE())",
          "TOKEN": token,
          "PARAMS": [sOrganizationCode, sWorkDate, sUserId, sDayReport, sUserId]
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return InsertResultModel.fromJson(
      json.decode(response.body),
    );
  }

  Future<InsertResultModel> nextReportUpdate(String sOrganizationCode,
      String sUserId, String sWorkDate, String sDayReport) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "UPDATE",
          "QUERY":
              "UPDATE TB_WORK_DAILYREPORT SET NEXT_REPORT = (?), LAST_UPDATED_BY = (?), LAST_UPDATE_DATE = GETDATE() " +
                  "WHERE ORGANIZATION_CODE = (?) AND WORK_DATE =(?) AND EMPLOY_ID_NO = (?)",
          "TOKEN": token,
          "PARAMS": [sDayReport, sUserId, sOrganizationCode, sWorkDate, sUserId]
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return InsertResultModel.fromJson(
      json.decode(response.body),
    );
  }
}
