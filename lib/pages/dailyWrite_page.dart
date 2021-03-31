import 'dart:async';
import 'dart:ui';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';

class DailyWritePage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final bool isDay;
  final DateTime selectDate;
  final UserManager member;

  DailyWritePage({
    this.id,
    this.isDay,
    this.selectDate,
    this.member,
  });
  @override
  _DailyWritePage createState() => new _DailyWritePage();
}

class _DailyWritePage extends State<DailyWritePage> {
  bool thisDay; //  일일 업무, 익일 업무 여부
  String id;
  String workDate;
  UserManager mem;
  int sDay = 0;
  DateTime _selectedTime;
  DateTime selectDate;
  DateTime nowDateTime = DateTime.now().add(Duration(hours: 9));

  String beforeText = ""; // 입력 하기 전 업무내용
  String otherText = ""; // 익일 업무내용 or 일일 업무내용

  final _dayTextEditController = TextEditingController();

  @override
  void dispose() {
    _dayTextEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    thisDay = widget.isDay;
    _selectedTime = widget.selectDate;
    mem = widget.member;

    workDate = _getWorkDate(_selectedTime);
    APIService apiService = new APIService();
    apiService
        .report(mem.user.organizationCode, mem.user.userId, workDate)
        .then((value) {
      if (value.day.isNotEmpty) {
        if (thisDay) {
          beforeText = value.day.elementAt(0).dayReport;
          otherText = value.day.elementAt(0).nextReport;
        } else {
          beforeText = value.day.elementAt(0).nextReport;
          otherText = value.day.elementAt(0).dayReport;
        }
        _dayTextEditController.text = beforeText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(workDate);

    // String _getDate(int day) {
    //   var _now = nowDateTime.add(Duration(days: sDay));
    //   _selectedTime = _now;
    //   return _getDateString(_selectedTime);
    // }

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
                thisDay ? "업무 내용" : "익일 업무",
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
              _getDateString(_selectedTime),
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'NotoSansKR',
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.red[300],
            ),
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                ),
              ),
              onPressed: () {
                if (_dayTextEditController.text == "") {
                  show("삭제할 내용이 없습니다.");
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("해당 내용을 삭제 하시겠습니까?"),
                        actions: [
                          TextButton(
                            child: Text("취소"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("확인"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              APIService apiService = new APIService();
                              //  DELETE

                              if (thisDay) {
                                if (otherText == "") {
                                  //  익일 업무내용 정보가 DB에 없을 때
                                  apiService
                                      .dayReportDelete(
                                          mem.user.organizationCode,
                                          mem.user.userId,
                                          workDate)
                                      .then((value) {
                                    if (value.result.isNotEmpty) {
                                      show(value.result.elementAt(0).rsMsg);
                                    } else {}
                                  });
                                } else {
                                  //  익일 업무내용 정보가 DB에 있을 때
                                  apiService
                                      .dayReportUpdate(
                                          mem.user.organizationCode,
                                          mem.user.userId,
                                          workDate,
                                          "")
                                      .then((value) {
                                    if (value.result.isNotEmpty) {
                                      show(value.result.elementAt(0).rsMsg);
                                    } else {}
                                  });
                                }
                              } else {
                                if (otherText == "") {
                                  //  일일 업무내용 정보가 DB에 없을 때
                                  apiService
                                      .dayReportDelete(
                                          mem.user.organizationCode,
                                          mem.user.userId,
                                          workDate)
                                      .then((value) {
                                    if (value.result.isNotEmpty) {
                                      show(value.result.elementAt(0).rsMsg);
                                    } else {}
                                  });
                                } else {
                                  //  일일 업무내용 정보가 DB에 있을 때
                                  apiService
                                      .nextReportUpdate(
                                          //  nextReport
                                          mem.user.organizationCode,
                                          mem.user.userId,
                                          workDate,
                                          "")
                                      .then((value) {
                                    if (value.result.isNotEmpty) {
                                      show(value.result.elementAt(0).rsMsg);
                                    } else {}
                                  });
                                }
                              }

                              _dayTextEditController.text = "";
                              beforeText = _dayTextEditController.text;
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(
              left: 10,
            ),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue[400],
            ),
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                ),
              ),
              onPressed: () {
                if (_dayTextEditController.text == "") {
                  show("내용을 입력해 주세요.");
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        // title: Text("AlertDialog"),
                        content: Text("저장 하시겠습니까?"),
                        actions: [
                          TextButton(
                            child: Text("취소"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("확인"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              APIService apiService = new APIService();

                              if (beforeText == "") {
                                //  INSERT
                                if (thisDay) {
                                  if (otherText == "") {
                                    //  익일 업무내용 정보가 DB에 없을 때
                                    apiService
                                        .dayReportInsert(
                                            mem.user.organizationCode,
                                            mem.user.userId,
                                            workDate,
                                            _dayTextEditController.text)
                                        .then((value) {
                                      if (value.result.isNotEmpty) {
                                        show(value.result.elementAt(0).rsMsg);
                                      } else {}
                                    });
                                  } else {
                                    //  익일 업무내용 정보가 DB에 있을 때
                                    apiService
                                        .dayReportUpdate(
                                            mem.user.organizationCode,
                                            mem.user.userId,
                                            workDate,
                                            _dayTextEditController.text)
                                        .then((value) {
                                      if (value.result.isNotEmpty) {
                                        show(value.result.elementAt(0).rsMsg);
                                      } else {}
                                    });
                                  }
                                } else {
                                  if (otherText == "") {
                                    //  일일 업무내용 정보가 DB에 없을 때
                                    apiService
                                        .dayReportInsert(
                                            //  nextReport
                                            mem.user.organizationCode,
                                            mem.user.userId,
                                            workDate,
                                            _dayTextEditController.text)
                                        .then((value) {
                                      if (value.result.isNotEmpty) {
                                        show(value.result.elementAt(0).rsMsg);
                                      } else {}
                                    });
                                  } else {
                                    //  일일 업무내용 정보가 DB에 있을 때
                                    apiService
                                        .nextReportUpdate(
                                            //  nextReport
                                            mem.user.organizationCode,
                                            mem.user.userId,
                                            workDate,
                                            _dayTextEditController.text)
                                        .then((value) {
                                      if (value.result.isNotEmpty) {
                                        show(value.result.elementAt(0).rsMsg);
                                      } else {}
                                    });
                                  }
                                }
                              } else {
                                //  UPDATE
                                if (thisDay) {
                                  apiService
                                      .dayReportUpdate(
                                          mem.user.organizationCode,
                                          mem.user.userId,
                                          workDate,
                                          _dayTextEditController.text)
                                      .then((value) {
                                    if (value.result.isNotEmpty) {
                                      show(value.result.elementAt(0).rsMsg);
                                    } else {}
                                  });
                                } else {
                                  apiService
                                      .nextReportUpdate(
                                          //  nextReport
                                          mem.user.organizationCode,
                                          mem.user.userId,
                                          workDate,
                                          _dayTextEditController.text)
                                      .then((value) {
                                    if (value.result.isNotEmpty) {
                                      show(value.result.elementAt(0).rsMsg);
                                    } else {}
                                  });
                                }
                              }
                              beforeText = _dayTextEditController.text;
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Icon(
                Icons.save,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );

    // #region 종료버튼
    // ignore: missing_return
    Future<bool> _onBackPressed() {
      if (beforeText == "" || beforeText == _dayTextEditController.text) {
        //  입력한 내용이 변경되지 않았을 때
        Navigator.of(context).pop(true);
      } else {
        //  입력한 내용이 변경되었을 때
        return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("입력중인 내용이 저장되지 않았습니다. 나가기 하시겠습니까?"),
                  actions: [
                    TextButton(
                      child: Text("취소"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text("확인"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            ) ??
            false;
      }
    }
    // #endregion

    // #region Body
    return Scaffold(
      // appBar: KulsWidget().appBar,
      bottomNavigationBar: KulsBottomBar(),
      body: WillPopScope(
        child: Center(
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
                  controller: _dayTextEditController,
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
        onWillPop: _onBackPressed,
      ),
    );
  }

  // #endregion
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

  Future show(sMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert(sMessage);
        }); // 비밀번호 불일치
  }

  Widget alert(String sContent) {
    return AlertDialog(
      // title: Text('AlertDialog Title'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(sContent),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('확인'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
