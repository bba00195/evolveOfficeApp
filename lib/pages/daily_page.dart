import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:evolveofficeapp/pages/dailyWrite_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';

class DailyPage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;

  DailyPage({
    this.id,
    this.pass,
    this.member,
  });
  @override
  _DailyPage createState() => new _DailyPage();
}

class _DailyPage extends State<DailyPage> {
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String pass;
  UserManager member;
  String changeDate;
  bool isChanged = false;
  int sDay = 0;
  DateTime _selectedTime;
  DateTime nowDateTime = DateTime.now().add(Duration(hours: 9));
  String workDate;

  String dayReport = '';
  String dayReportTemp = '';
  String nextReport = '';
  Future<DailyResultModel> futureAlbum;

  void _report(String selectedDate) async {
    setState(() {
      APIService apiService = new APIService();
      futureAlbum = apiService.report(
          member.user.organizationCode, member.user.userId, selectedDate);
    });
  }

  @override
  void initState() {
    super.initState();
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;
    String year = nowDateTime.year.toString();
    String month = nowDateTime.month.toString().padLeft(2, '0');
    String day = nowDateTime.day.toString().padLeft(2, '0');

    workDate = year + month + day;
  }

  @override
  Widget build(BuildContext context) {
    _report(
      workDate,
    );
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

    _dayDecrease() {
      isChanged = true;
      sDay--;
      changeDate = _getDate(sDay);
      _report(workDate);
    }

    _dayIncrease() {
      isChanged = true;
      sDay++;
      changeDate = _getDate(sDay);
      _report(workDate);
    }

    // main(workDate);

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
                '일일 업무 보고',
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

    final selectDate = Container(
      margin: EdgeInsets.only(
        left: 40,
        right: 40,
      ),
      height: 50,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _dayDecrease();
                });
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 28.0,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: TextButton(
              style: ButtonStyle(
                  // alignment: AlignmentGeometry.lerp(1, 1, 1),
                  // backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
              onPressed: () {
                Future<DateTime> selectedDate = showDatePicker(
                  context: context,
                  initialDate: _selectedTime, // 초깃값
                  firstDate: DateTime(2018), // 시작일
                  lastDate: DateTime(2030), // 마지막일
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.dark(), // 다크테마
                      child: child,
                    );
                  },
                );

                selectedDate.then((dateTime) {
                  setState(() {
                    _selectedTime = dateTime;
                    sDay = dateTime.difference(DateTime.now()).inDays;
                    changeDate = _getDateString(_selectedTime);
                    _report(
                      workDate,
                    );
                  });
                });
              },
              child: Text(
                isChanged ? changeDate : _getDate(0),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _dayIncrease();
                });
              },
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );

    _writeReport(String sType) {
      return Container(
        height: 215,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 6.0,
              offset: const Offset(0.0, 3.0),
              color: Color.fromRGBO(0, 0, 0, 0.16),
            )
          ],
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    (sType == "today") ? '업무 내용' : '익일 업무',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(255, 153, 130, 1.0)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => (sType == "today")
                              ? DailyWritePage(
                                  id: id,
                                  isDay: true,
                                  selectDate: _selectedTime,
                                  member: member,
                                )
                              : DailyWritePage(
                                  id: id,
                                  isDay: false,
                                  selectDate: _selectedTime,
                                  member: member,
                                ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.create,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 120,
              alignment: Alignment.topLeft,
              child: FutureBuilder<DailyResultModel>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.day.isNotEmpty) {
                      dayReport = snapshot.data.day.elementAt(0).dayReport;
                      nextReport = snapshot.data.day.elementAt(0).nextReport;
                      return Text(
                        (sType == "today") ? dayReport : nextReport,
                      );
                    } else {}
                  }
                  return Text('');
                },
              ),
              // Text(
              // (sType == "today") ? dayReport : nextReport,
              // ),
            ),
          ],
        ),
      );
    }

    // #region Body

    // APIService apiService = new APIService();
    // apiService
    //     .report(mem.user.organizationCode, mem.user.userId, workDate)
    //     .then((value) async {
    //   print('apiService');
    // });
    return Scaffold(
      appBar: KulsAppBar(
        id: id,
        pass: pass,
        member: member,
      ),
      bottomNavigationBar: KulsBottomBar(),
      body: Center(
        child: ListView(
          children: [
            menuName,
            SizedBox(height: 30),
            selectDate,
            SizedBox(height: 20),
            _writeReport("today"),
            SizedBox(height: 30),
            _writeReport("next"),
          ],
        ),
      ),
    );
  }
  // #endregion
}
