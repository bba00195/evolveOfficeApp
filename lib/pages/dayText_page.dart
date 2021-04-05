import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';

class DailyTextPage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;

  DailyTextPage({
    this.id,
    this.pass,
    this.member,
  });
  @override
  _DailyTextPage createState() => new _DailyTextPage();
}

class _DailyTextPage extends State<DailyTextPage> {
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String pass;
  UserManager member;
  String changeDate;
  DateTime changeDateTime;

  bool isChanged = false;
  int sDay = 0;
  DateTime nowDateTime = DateTime.now().add(Duration(hours: 9));
  DateTime _selectedTime;
  String date;

  String dayReport = '';
  String nextReport = '';
  Future<DailyResultModel> futureAlbum;
  final _dayTextEditController = TextEditingController();
  final _nextTextEditController = TextEditingController();
  GlobalKey<FormState> _dayFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _nextFormKey = GlobalKey<FormState>();

  FocusNode dayFocusNode;
  FocusNode nextFocusNode;

  void _report(String selectedDate) async {
    setState(() {
      APIService apiService = new APIService();
      futureAlbum = apiService.report(
          member.user.organizationCode, member.user.userId, selectedDate);
    });
  }

  @override
  void dispose() {
    _dayTextEditController.dispose();
    _nextTextEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;

    date = Date().date(null);
    dayFocusNode = FocusNode();
    nextFocusNode = FocusNode();
    _selectedTime = nowDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    _report(
      date,
    );

    _dayDecrease() {
      isChanged = true;
      sDay--;
      changeDate = Date().getDate(sDay);
      date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
      _report(date);
    }

    _dayIncrease() {
      isChanged = true;
      sDay++;
      changeDate = Date().getDate(sDay);
      date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
      _report(date);
    }

    Widget dayForm = Form(
      key: _dayFormKey,
      child: TextFormField(
        autofocus: false,
        controller: _dayTextEditController,
        focusNode: dayFocusNode,
        maxLines: 999,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'NotoSansKR',
        ),
        // textInputAction: TextInputAction.next,
        // onFieldSubmitted: (value) {
        //   _dayFocusChange(_dayFormKey.currentContext, dayFocusNode);
        // },
      ),
    );

    Widget nextForm = Form(
      key: _nextFormKey,
      child: TextFormField(
        autofocus: false,
        controller: _nextTextEditController,
        focusNode: nextFocusNode,
        maxLines: 999,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'NotoSansKR',
        ),
        // textInputAction: TextInputAction.next,
        // onFieldSubmitted: (value) {
        //   _nextFocusChange(_nextFormKey.currentContext, nextFocusNode);
        // },
      ),
    );

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
              style: ButtonStyle(),
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
                    isChanged = true;
                    _selectedTime = dateTime;
                    sDay = dateTime.difference(DateTime.now()).inDays;
                    changeDate = Date().getDateString(_selectedTime);
                    date = Date().date(_selectedTime);
                    _report(
                      date,
                    );
                  });
                });
              },
              child: Text(
                isChanged ? changeDate : Date().getDate(0),
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
        height: screenHeight * 0.3,
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
                      APIService apiService = new APIService();
                      if (sType == "today") {
                        if (nextReport == "") {
                          //  익일 업무내용 정보가 DB에 없을 때
                          apiService
                              .dayReportDelete(member.user.organizationCode,
                                  member.user.userId, date)
                              .then((value) {
                            if (value.result.isNotEmpty) {
                            } else {}
                            _dayTextEditController.text = '';
                          });
                        } else {
                          //  익일 업무내용 정보가 DB에 있을 때
                          apiService
                              .dayReportUpdate(member.user.organizationCode,
                                  member.user.userId, date, "")
                              .then((value) {
                            if (value.result.isNotEmpty) {
                            } else {}
                            _dayTextEditController.text = '';
                          });
                        }
                      } else {
                        if (dayReport == "") {
                          //  일일 업무내용 정보가 DB에 없을 때
                          apiService
                              .dayReportDelete(member.user.organizationCode,
                                  member.user.userId, date)
                              .then((value) {
                            if (value.result.isNotEmpty) {
                            } else {}
                            _nextTextEditController.text = '';
                          });
                        } else {
                          //  일일 업무내용 정보가 DB에 있을 때
                          apiService
                              .nextReportUpdate(member.user.organizationCode,
                                  member.user.userId, date, "")
                              .then((value) {
                            if (value.result.isNotEmpty) {
                            } else {}
                            _nextTextEditController.text = '';
                          });
                        }
                      }
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: screenHeight * 0.17,
              alignment: Alignment.topLeft,
              child: FutureBuilder<DailyResultModel>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.day.isNotEmpty) {
                      dayReport = snapshot.data.day.elementAt(0).dayReport;
                      nextReport = snapshot.data.day.elementAt(0).nextReport;
                      if (sType == "today") {
                        _dayTextEditController.text = dayReport;
                        return dayForm;
                      } else {
                        _nextTextEditController.text = nextReport;
                        return nextForm;
                      }
                    } else {
                      if (sType == "today") {
                        _dayTextEditController.text = '';
                        return dayForm;
                      } else {
                        _nextTextEditController.text = '';
                        return nextForm;
                      }
                    }
                  }
                  if (sType == "today") {
                    _dayTextEditController.text = '';
                    return dayForm;
                  } else {
                    _nextTextEditController.text = '';
                    return nextForm;
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    // #region Body
    return Scaffold(
      appBar: KulsAppBar(
        id: id,
        pass: pass,
        member: member,
      ),
      bottomNavigationBar: KulsBottomBar(),
      body: GestureDetector(
        child: Center(
          child: ListView(
            children: [
              menuName,
              SizedBox(height: 30),
              selectDate,
              SizedBox(height: 20),
              _writeReport("today"),
              SizedBox(height: 30),
              _writeReport("next"),
              SizedBox(height: 30),
            ],
          ),
        ),
        onTap: () {
          _dayFocusChange(_dayFormKey.currentContext, dayFocusNode);
          _nextFocusChange(_nextFormKey.currentContext, nextFocusNode);
        },
      ),
    );
  }
  // #endregion

  void _dayFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
    APIService apiService = new APIService();
    // if (_dayTextEditController.text != "") {
    if (dayReport == "") {
      //  INSERT
      if (nextReport == "") {
        //  익일 업무내용 정보가 DB에 없을 때
        apiService
            .dayReportInsert(member.user.organizationCode, member.user.userId,
                date, _dayTextEditController.text)
            .then((value) {
          if (value.result.isNotEmpty) {
          } else {}
        });
      } else {
        //  익일 업무내용 정보가 DB에 있을 때
        apiService
            .dayReportUpdate(member.user.organizationCode, member.user.userId,
                date, _dayTextEditController.text)
            .then((value) {
          if (value.result.isNotEmpty) {
          } else {}
        });
      }
    } else {
      apiService
          .dayReportUpdate(member.user.organizationCode, member.user.userId,
              date, _dayTextEditController.text)
          .then((value) {
        if (value.result.isNotEmpty) {
        } else {}
      });
    }
    // }
  }

  void _nextFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
    APIService apiService = new APIService();
    if (nextReport == "") {
      //  INSERT
      if (dayReport == "") {
        //  일일 업무내용 정보가 DB에 없을 때
        apiService
            .dayReportInsert(member.user.organizationCode, member.user.userId,
                date, _nextTextEditController.text)
            .then((value) {
          if (value.result.isNotEmpty) {
          } else {}
        });
      } else {
        //  일일 업무내용 정보가 DB에 있을 때
        apiService
            .nextReportUpdate(member.user.organizationCode, member.user.userId,
                date, _nextTextEditController.text)
            .then((value) {
          if (value.result.isNotEmpty) {
          } else {}
        });
      }
    }
  }
}
