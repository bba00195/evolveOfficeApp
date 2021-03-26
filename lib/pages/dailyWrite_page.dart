import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';

class DailyWritePage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final bool isDay;
  final String workDate;
  final UserManager member;

  DailyWritePage({
    this.id,
    this.isDay,
    this.workDate,
    this.member,
  });
  @override
  _DailyWritePage createState() => new _DailyWritePage();
}

class _DailyWritePage extends State<DailyWritePage> {
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  bool thisDay;
  String id;
  String workDate;
  String reportType = '';
  UserManager mem;
  int sDay = 0;
  DateTime _selectedTime;
  bool isChanged = false;
  DateTime nowDateTime = DateTime.now().add(Duration(hours: 9));

  @override
  void initState() {
    super.initState();
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    thisDay = widget.isDay;
    workDate = widget.workDate;
    mem = widget.member;
  }

  String _getWorkDate(DateTime datetime) {
    String year = datetime.year.toString();
    String month = datetime.month.toString().padLeft(2, '0');
    String day = datetime.day.toString().padLeft(2, '0');

    return year + month + day;
  }

  String _getDateString(DateTime datetime) {
    String year = datetime.year.toString();
    String month = datetime.month.toString();
    String day = datetime.day.toString();
    String weekday;

    switch (datetime.weekday) {
      case 1:
        weekday = "(월)";
        break;
      case 2:
        weekday = "(화)";
        break;
      case 3:
        weekday = "(수)";
        break;
      case 4:
        weekday = "(목)";
        break;
      case 5:
        weekday = "(금)";
        break;
      case 6:
        weekday = "(토)";
        break;
      case 7:
        weekday = "(일)";
        break;
      default:
        break;
    }

    workDate = _getWorkDate(datetime);
    return year + ". " + month + ". " + day + weekday;
  }

  String _getDate(int day) {
    var _now = nowDateTime.add(Duration(days: sDay));
    _selectedTime = _now;
    return _getDateString(_selectedTime);
  }

  final menuName = Container(
    height: 50,
    color: Color.fromRGBO(101, 209, 182, 1.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 8,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "업무 내용",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'NotoSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  final toolBar = Container(
    padding: EdgeInsets.only(
      left: 28,
      right: 28,
    ),
    height: 50,
    decoration: BoxDecoration(
      // color: Colors.red,
      border: Border(
        bottom: BorderSide(
          color: Color.fromRGBO(101, 209, 182, 1.0),
        ),
      ),
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 7,
          child: Text(
            "2021. 03. 25",
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'NotoSansKR',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.red[300],
            ),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(
              left: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue[400],
            ),
            child: Icon(
              Icons.save,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    // #region Body
    return Scaffold(
      // appBar: KulsWidget().appBar,
      bottomNavigationBar: KulsWidget().bottomNavi,
      body: Center(
        child: ListView(
          children: [
            menuName,
            toolBar,
            Container(
              padding: EdgeInsets.only(
                left: 28,
                right: 28,
              ),
              height: MediaQuery.of(context).size.height * 0.75,
              // color: Colors.amberAccent,
              child: TextField(
                autofocus: false,
                minLines: 20,
                maxLines: 999,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // #endregion
}
