import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_model.dart';
import '../model/daily_model.dart';

class APIService {
  String url = "https://www.kuls.co.kr/DBHelper.php";

  Future<ResultModel> login(String sUserId) async {
    final response = await http.post(
      url,
      body: jsonEncode(
        {
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
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    return DailyResultModel.fromJson(
      json.decode(response.body),
    );
  }
}
