import 'package:evolveofficeapp/common/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';

class DailyPage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final UserManager member;

  DailyPage({
    this.id,
    this.member,
  });
  @override
  _DailyPage createState() => new _DailyPage();
}

class _DailyPage extends State<DailyPage> {
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String changeDate;
  UserManager mem;
  bool isChanged = false;
  int sDay = 0;
  DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    mem = widget.member;
  }

  @override
  Widget build(BuildContext context) {
    var manager = mem;

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

      return year + ". " + month + ". " + day + weekday;
    }

    String _getDate(int day) {
      var _now = DateTime.now().add(Duration(days: sDay));
      _selectedTime = _now;
      return _getDateString(_selectedTime);
    }

    _dayDecrease() {
      isChanged = true;
      sDay--;
      print(sDay);
      changeDate = _getDate(sDay);
      print(changeDate);
    }

    _dayIncrease() {
      isChanged = true;
      sDay++;
      print(sDay);
      changeDate = _getDate(sDay);
      print(changeDate);
    }

    final menuName = Container(
      height: 50,
      color: Color.fromRGBO(101, 209, 182, 1.0),
      child: Row(
        children: [
          // Expanded(
          //   flex: 1,
          //   child: TextButton(
          //     child: Icon(Icons.arrow_back_ios),
          //     onPressed: () => Navigator.pop(context),
          //   ),
          // ),
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
      height: 40,
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
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: TextButton(
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
                  });
                });
              },
              child: Text(
                isChanged ? changeDate : _getDate(0),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.w600,
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
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );

    final todayReport = Container(
      height: 235,
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
                  '업무 내용',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );

    // #region Body
    return Scaffold(
      appBar: KulsWidget().appBar,
      bottomNavigationBar: KulsWidget().bottomNavi,
      body: Center(
        child: ListView(
          children: [
            menuName,
            SizedBox(height: 30),
            selectDate,
            SizedBox(height: 20),
            todayReport,
          ],
        ),
      ),
    );
  }
  // #endregion
}
