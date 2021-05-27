import 'package:evolveofficeapp/model/whereis_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_model.dart';
import '../model/daily_model.dart';

class APIService {
  var url = Uri.parse('https://www.kuls.co.kr/flutter/DBHelper.php');
  String token = "ba7da079703c28825269ae6d44fc7fa3";

  Future<ResultModel> login(String sUserId) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "SELECT",
          "PROCEDURE": "N",
          "QUERY": "SELECT ORGANIZATION_CODE, " +
              "USERID, " +
              "USERNAME_KOR, " +
              "E_MAIL, " +
              "PASSWORD, " +
              "DEPT_CODE, " +
              "(SELECT DEPT_NAME FROM TB_ADMIN_DEPTCODE WHERE DEPT_CODE = A.DEPT_CODE) AS DEPT_NAME, " +
              "GRADE_CODE, " +
              "GRADE_NAME, " +
              "MOBILE_TEL, " +
              "UPLOAD_IMG_SAJIN " +
              "FROM tb_admin_user A " +
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
          "PROCEDURE": "N",
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

  Future<WhereResultModel> whereIsManage(
      String sOrganizationCode,
      String sUserId,
      String sWorkDate,
      String sOrganValue,
      String sDeptValue) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "SELECT",
          "PROCEDURE": "N",
          "QUERY": "SELECT DBO.F_GET_DEPTNAME(A.DEPT_CODE) AS DEPT_NAME, " +
              "A.USERNAME_KOR AS USER_NAME, " +
              "B.START_TIME, " +
              "B.END_TIME, " +
              "B.AREA, " +
              "B.WHEREIS_CONTENTS, " +
              "dbo.fn_get_codemaster('WHEREIS_CAR_TYPE',B.car_type) AS CAR_TYPE_NAME,	   " +
              "B.CAR_TYPE, " +
              "B.ORGANIZATION_CODE " +
              "FROM TB_ADMIN_USER  A  " +
              "LEFT OUTER JOIN TB_WORK_WHEREIS  B  " +
              "ON WHEREIS_DATE = '" +
              sWorkDate +
              "' " +
              "AND B.ORGANIZATION_CODE = '" +
              sOrganizationCode +
              "' " +
              "AND A.USERID = B.EMPLOY_ID_NO , " +
              "TB_ADMIN_DEPTCODE  C " +
              "WHERE A.ORGANIZATION_CODE 	= C.ORGANIZATION_CODE " +
              "  AND A.ORGANIZATION_CODE 	LIKE  '%" +
              sOrganValue +
              "%' " +
              "  AND A.DEPT_CODE         		= C.DEPT_CODE " +
              "  AND C.DEPT_CODE		     	LIKE '%" +
              sDeptValue +
              "%' "
                  "  AND A.USE_FLAG              	= 'Y' " +
              "ORDER BY a.dept_code, A.SORT_SEQ",
          "TOKEN": token,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return WhereResultModel.fromJson(
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
          "PROCEDURE": "N",
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
          "PROCEDURE": "N",
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

  Future<InsertResultModel> remarkReportUpdate(String sOrganizationCode,
      String sUserId, String sWorkDate, String sRemarkReport) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "UPDATE",
          "PROCEDURE": "N",
          "QUERY":
              "UPDATE TB_WORK_DAILYREPORT SET MISC_REPORT = (?), LAST_UPDATED_BY = (?), LAST_UPDATE_DATE = GETDATE() " +
                  "WHERE ORGANIZATION_CODE = (?) AND WORK_DATE =(?) AND EMPLOY_ID_NO = (?)",
          "TOKEN": token,
          "PARAMS": [
            sRemarkReport,
            sUserId,
            sOrganizationCode,
            sWorkDate,
            sUserId
          ]
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
          "PROCEDURE": "N",
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
          "PROCEDURE": "N",
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
          "PROCEDURE": "N",
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

  Future<InsertResultModel> whereIsInsert(
      String sOrganizationCode,
      String sUserId,
      // String sArea,
      String sDate,
      String sStart,
      String sEnd,
      String sLocate,
      String sCarType) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "INSERT",
          "PROCEDURE": "N",
          "QUERY":
              "INSERT INTO TB_WORK_WHEREIS (ORGANIZATION_CODE, WHEREIS_DATE,  EMPLOY_ID_NO, START_TIME, END_TIME, " +
                  "WHEREIS_CONTENTS, CAR_TYPE, CREATED_BY, CREATION_DATE)" +
                  "VALUES (?, ?,  ?,  ?,  ?, ?, ?, ?, GETDATE())",
          "TOKEN": token,
          "PARAMS": [
            sOrganizationCode,
            sDate,
            sUserId,
            sStart,
            sEnd,
            // sArea,
            sLocate,
            sCarType,
            sUserId
          ]
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return InsertResultModel.fromJson(
      json.decode(response.body),
    );
  }

  Future<InsertResultModel> whereIsUpdate(
      String sOrganizationCode,
      String sUserId,
      // String sArea,
      String sDate,
      String sStart,
      String sStartOrg,
      String sEnd,
      String sEndOrg,
      String sLocate,
      String sCarType) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "UPDATE",
          "PROCEDURE": "N",
          "QUERY": "UPDATE TB_WORK_WHEREIS SET START_TIME = (?), END_TIME = (?), CAR_TYPE = (?)" +
              ", WHEREIS_CONTENTS = (?), LAST_UPDATED_BY=(?), LAST_UPDATE_DATE = GETDATE()" +
              " WHERE ORGANIZATION_CODE = (?) AND WHEREIS_DATE = (?) AND EMPLOY_ID_NO = (?) AND START_TIME = (?) AND END_TIME = (?)",
          "TOKEN": token,
          "PARAMS": [
            sStart,
            sEnd,
            // sArea,
            sCarType,
            sLocate,
            sUserId,
            sOrganizationCode,
            sDate,
            sUserId,
            sStartOrg,
            sEndOrg
          ]
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return InsertResultModel.fromJson(
      json.decode(response.body),
    );
  }

  Future<InsertResultModel> whereIsDelete(String sOrganizationCode,
      String sUserId, String sDate, String sStart, String sEnd) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "TYPE": "DELETE",
          "PROCEDURE": "N",
          "QUERY":
              "DELETE TB_WORK_WHEREIS WHERE ORGANIZATION_CODE = (?) AND WHEREIS_DATE = (?) AND EMPLOY_ID_NO = (?) AND START_TIME = (?) AND END_TIME = (?) ",
          "TOKEN": token,
          "PARAMS": [sOrganizationCode, sDate, sUserId, sStart, sEnd]
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return InsertResultModel.fromJson(
      json.decode(response.body),
    );
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
