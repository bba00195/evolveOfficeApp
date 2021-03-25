import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_model.dart';

class APIService {
  Future<ResultModel> login(String sUserId) async {
    String url = "https://www.kuls.co.kr/DBHelper.php";

    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "QUERY":
              "SELECT ORGANIZATION_CODE,USERID, USERNAME_KOR, E_MAIL, PASSWORD, DEPT_CODE, DEPT_NAME, GRADE_CODE, GRADE_NAME, MOBILE_TEL FROM tb_admin_user WHERE USERID = '" +
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
}
