import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';

import 'daily_page.dart';
import 'login_page.dart';

class MenuPage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;

  MenuPage({
    this.id,
    this.pass,
    this.member,
  });
  @override
  _MenuPage createState() => new _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  static final storage = FlutterSecureStorage();
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String pass;
  String date;
  UserManager mem;

  @override
  void initState() {
    super.initState();
    date = Date().date(null);
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass; //widget.pass LogOutPage에서 전달받은 pass 의미한다.
    mem = widget.member;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    var member = mem;

    _show(String sMessage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(sMessage),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    }

    final profileHead = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(121, 102, 254, 1),
            width: 2.0,
          ),
        ),
      ),
      height: 90,
      child: Center(
        child: Text(
          'Menu',
          style: TextStyle(
            color: Color.fromRGBO(121, 102, 254, 1),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    final profileList = Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: 0,
        ),
        children: <Widget>[
          SizedBox(height: 30),
          // InkWell(
          //   child: Container(
          //     padding: EdgeInsets.only(
          //       left: screenWidth * 0.05,
          //       right: screenWidth * 0.05,
          //     ),
          //     alignment: Alignment.centerLeft,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       border: Border.all(
          //         color: Color.fromRGBO(121, 102, 254, 1),
          //       ),
          //     ),
          //     height: screenHeight * 0.08,
          //     child: Text(
          //       "공지사항",
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontFamily: 'NotoSansKR',
          //       ),
          //     ),
          //   ),
          //   onTap: () {
          //     _show("준비중입니다.");
          //   },
          // ),
          // SizedBox(height: 14),
          InkWell(
            child: Container(
              padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
              ),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromRGBO(121, 102, 254, 1),
                ),
              ),
              height: screenHeight * 0.08,
              child: Text(
                "로그아웃",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ),
            onTap: () {
              storage.deleteAll();
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
          SizedBox(height: 14),
        ],
      ),
    );

    // #region Body
    return Scaffold(
      bottomNavigationBar: KulsNavigationBottomBar(
        id: id,
        pass: pass,
        member: member,
        selectedIndex: 0,
      ),
      body: Center(
        child: ListView(
          children: [
            profileHead,
            profileList,
          ],
        ),
      ),
    );
  }
  // #endregion
}
