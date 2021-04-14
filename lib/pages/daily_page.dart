import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter/services.dart';

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
  DateTime changeDateTime;

  bool isChanged = false;
  int sDay = 0;
  DateTime nowDateTime = DateTime.now();
  DateTime _selectedTime;
  String date;

  String dayReport = '';
  String nextReport = '';
  String remarkReport = '';

  String dayPrefix = "";
  String nextPrefix = "";

  Future<DailyResultModel> futureAlbum;
  final _dayTextEditController = TextEditingController();
  final _nextTextEditController = TextEditingController();
  final _remarkTextEditController = TextEditingController();
  GlobalKey<FormState> _dayFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _nextFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _remarkFormKey = GlobalKey<FormState>();

  FocusNode dayFocusNode;
  FocusNode nextFocusNode;
  FocusNode remarkFocusNode;

  bool isFocused = false;

  void _report(String selectedDate) async {
    setState(() {
      // APIService apiService = new APIService();
      // futureAlbum = apiService.report(
      //     member.user.organizationCode, member.user.userId, selectedDate);

      APIService apiService = new APIService();
      apiService
          .report(
              member.user.organizationCode, member.user.userId, selectedDate)
          .then((value) {
        if (value.day.isNotEmpty) {
          _dayTextEditController.text = value.day.elementAt(0).dayReport;
          _nextTextEditController.text = value.day.elementAt(0).nextReport;
          _remarkTextEditController.text = value.day.elementAt(0).miscReport;
        } else {
          // _dayTextEditController.text = "";
          // _nextTextEditController.text = "";
          // _remarkTextEditController.text = "";
        }
      });
    });
  }

  @override
  void dispose() {
    _dayTextEditController.dispose();
    _nextTextEditController.dispose();
    _remarkTextEditController.dispose();
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
    remarkFocusNode = FocusNode();

    dayFocusNode.addListener(_onFocusChange);
    nextFocusNode.addListener(_onFocusChange);
    remarkFocusNode.addListener(_onFocusChange);
    _selectedTime = nowDateTime;
  }

  void _onFocusChange() {
    isFocused = true;
    if (dayFocusNode.hasFocus) {
      _nextFocusChange(context, nextFocusNode);
      if (dayReport != "" || nextReport != "") {
        _remarkFocusChange(context, remarkFocusNode);
      }
    }
    if (nextFocusNode.hasFocus) {
      _dayFocusChange(context, dayFocusNode);
      if (dayReport != "" || nextReport != "") {
        _remarkFocusChange(context, remarkFocusNode);
      }
    }
    if (remarkFocusNode.hasFocus) {
      _dayFocusChange(context, dayFocusNode);
      _nextFocusChange(context, nextFocusNode);
      remarkFocusNode.unfocus();
      if (_dayTextEditController.text == "" &&
          _nextTextEditController.text == "") {
        _show("업무 내용 먼저 작성해주세요.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    _report(
      date,
    );

    _dayDecrease() {
      _dayFocusChange(_dayFormKey.currentContext, dayFocusNode);
      _nextFocusChange(_nextFormKey.currentContext, nextFocusNode);
      _remarkFocusChange(_remarkFormKey.currentContext, remarkFocusNode);
      _dayTextEditController.text = "";
      _nextTextEditController.text = "";
      _remarkTextEditController.text = "";
      isChanged = true;
      sDay--;
      changeDate = Date().getDate(sDay);
      date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
      _report(date);
    }

    _dayIncrease() {
      _dayFocusChange(_dayFormKey.currentContext, dayFocusNode);
      _nextFocusChange(_nextFormKey.currentContext, nextFocusNode);
      _remarkFocusChange(_remarkFormKey.currentContext, remarkFocusNode);
      _dayTextEditController.text = "";
      _nextTextEditController.text = "";
      _remarkTextEditController.text = "";
      isChanged = true;
      isFocused = false;
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
          fillColor: Color.fromRGBO(228, 220, 255, 1),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 18,
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
          fontSize: 18,
          fontFamily: 'NotoSansKR',
        ),
        // textInputAction: TextInputAction.next,
        // onFieldSubmitted: (value) {
        //   _nextFocusChange(_nextFormKey.currentContext, nextFocusNode);
        // },
      ),
    );

    Widget remarkForm = Form(
      key: _remarkFormKey,
      child: TextFormField(
        autofocus: false,
        controller: _remarkTextEditController,
        focusNode: remarkFocusNode,
        maxLines: 999,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'NotoSansKR',
        ),
        // textInputAction: TextInputAction.next,
        // onFieldSubmitted: (value) {
        //   _dayFocusChange(_dayFormKey.currentContext, dayFocusNode);
        // },
      ),
    );

    final menuName = AppBar(
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      actions: [
        // new IconButton(
        //   icon: Icon(
        //     Icons.calendar_today_outlined,
        //     color: Color.fromRGBO(121, 101, 254, 1),
        //     size: 30,
        //   ),
        //   onPressed: () {
        //     // Navigator.pop(context, false);
        //   },
        // )
      ],
      backgroundColor: Color.fromRGBO(248, 246, 255, 1),
      centerTitle: true,
      title: Text(
        '일일 업무 보고',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'NotoSansKR',
          fontWeight: FontWeight.w600,
        ),
      ),
      toolbarHeight: 75,
      bottomOpacity: 0.0,
      elevation: 0.0,
    );

    final selectDate = Container(
      color: Color.fromRGBO(248, 246, 255, 1),
      // margin: EdgeInsets.only(
      //   right: screenWidth * 0.05,
      // ),
      padding: EdgeInsets.only(
        left: screenWidth * 0.05,
      ),
      height: 80,
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
            flex: 7,
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
                    _dayFocusChange(_dayFormKey.currentContext, dayFocusNode);
                    _nextFocusChange(
                        _nextFormKey.currentContext, nextFocusNode);
                    _remarkFocusChange(
                        _remarkFormKey.currentContext, remarkFocusNode);
                    _dayTextEditController.text = "";
                    _nextTextEditController.text = "";
                    _remarkTextEditController.text = "";
                    isFocused = false;
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
            child: Container(
              height: 80,
              child: Container(
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
            ),
          ),
          // Expanded(
          // Container(
          //   width: screenWidth * 0.05,
          //   decoration: BoxDecoration(
          //     color: Color.fromRGBO(45, 43, 77, 1),
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(screenWidth * 0.05),
          //     ),
          //   ),
          // ),
          // ),
        ],
      ),
    );

    _writeReport(String sType) {
      return Column(
        // alignment:
        //     AlignmentDirectional.topStart, //alignment:new Alignment(x, y)
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(45, 43, 77, 1),
                  width: 3,
                ),
              ),
            ),
            // color: Color.fromRGBO(121, 101, 254, 1),
            child: Text(
              (sType == "today") ? ' 금일 업무 내용' : ' 익일 업무',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(86, 98, 112, 1),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.22,
            margin: EdgeInsets.only(
              top: 14,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
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
              color: Color.fromRGBO(248, 246, 255, 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 14,
                  child: Container(
                    // height: screenHeight * 0.16,
                    alignment: Alignment.topLeft,
                    child: (sType == "today") ? dayForm : nextForm,
                    // FutureBuilder<DailyResultModel>(
                    //   future: futureAlbum,
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       if (snapshot.data.day.isNotEmpty) {
                    //         if (sType == "today") {
                    //           dayReport =
                    //               snapshot.data.day.elementAt(0).dayReport;
                    //           _dayTextEditController.text = dayReport;
                    //           return dayForm;
                    //         } else {
                    //           nextReport =
                    //               snapshot.data.day.elementAt(0).nextReport;
                    //           _nextTextEditController.text = nextReport;
                    //           return nextForm;
                    //         }
                    //       } else {
                    //         if (sType == "today") {
                    //           dayReport = "";
                    //           // if (!isFocused) {
                    //           _dayTextEditController.text = "";
                    //           // }
                    //         } else {
                    //           nextReport = "";
                    //           // if (!isFocused) {
                    //           _nextTextEditController.text = "";
                    //           // }
                    //         }
                    //       }
                    //     }
                    //     if (sType == "today") {
                    //       // if (dayReport == "" &&
                    //       //     _dayTextEditController.text == "" &&
                    //       //     !isFocused) {
                    //       _dayTextEditController.text = "";
                    //       // }
                    //       return dayForm;
                    //     } else {
                    //       // if (nextReport == "" &&
                    //       //     _nextTextEditController.text == "" &&
                    //       //     !isFocused) {
                    //       _nextTextEditController.text = "";
                    //       // }
                    //       return nextForm;
                    //     }
                    //   },
                    // ),
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: TextButton(
                //     style: ButtonStyle(
                //       alignment: Alignment.center,
                //       backgroundColor: MaterialStateProperty.all<Color>(
                //           Color.fromRGBO(255, 153, 130, 1.0)),
                //     ),
                //     onPressed: () {
                //       APIService apiService = new APIService();
                //       if (sType == "today") {
                //         if (nextReport == "") {
                //           //  익일 업무내용 정보가 DB에 없을 때
                //           apiService
                //               .dayReportDelete(member.user.organizationCode,
                //                   member.user.userId, date)
                //               .then((value) {
                //             if (value.result.isNotEmpty) {
                //             } else {}
                //             _dayTextEditController.text = '';
                //           });
                //         } else {
                //           //  익일 업무내용 정보가 DB에 있을 때
                //           apiService
                //               .dayReportUpdate(member.user.organizationCode,
                //                   member.user.userId, date, "")
                //               .then((value) {
                //             if (value.result.isNotEmpty) {
                //             } else {}
                //             _dayTextEditController.text = '';
                //           });
                //         }
                //       } else {
                //         if (dayReport == "") {
                //           //  일일 업무내용 정보가 DB에 없을 때
                //           apiService
                //               .dayReportDelete(member.user.organizationCode,
                //                   member.user.userId, date)
                //               .then((value) {
                //             if (value.result.isNotEmpty) {
                //             } else {}
                //             _nextTextEditController.text = '';
                //           });
                //         } else {
                //           //  일일 업무내용 정보가 DB에 있을 때
                //           apiService
                //               .nextReportUpdate(member.user.organizationCode,
                //                   member.user.userId, date, "")
                //               .then((value) {
                //             if (value.result.isNotEmpty) {
                //             } else {}
                //             _nextTextEditController.text = '';
                //           });
                //         }
                //       }
                //     },
                //     child: Icon(
                //       Icons.delete,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      );
    }

    _remark() {
      return Column(
        // alignment:
        //     AlignmentDirectional.topStart, //alignment:new Alignment(x, y)
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(45, 43, 77, 1),
                  width: 3,
                ),
              ),
            ),
            // color: Color.fromRGBO(121, 101, 254, 1),
            child: Text(
              '특이사항',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(86, 98, 112, 1),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          // Container(
          //   alignment: Alignment.center,
          //   height: 30,
          //   width: 100,
          //   margin: EdgeInsets.only(
          //     left: screenWidth * 0.1,
          //     right: screenWidth * 0.05,
          //   ),
          //   color: Color.fromRGBO(121, 101, 254, 1),
          //   child: Text(
          //     '특이사항',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.w700,
          //     ),
          //   ),
          // ),
          Container(
            height: screenHeight * 0.14,
            margin: EdgeInsets.only(
              top: 14,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
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
              color: Color.fromRGBO(248, 246, 255, 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 14,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: remarkForm,
                    // FutureBuilder<DailyResultModel>(
                    //   future: futureAlbum,
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       if (snapshot.data.day.isNotEmpty) {
                    //         remarkReport =
                    //             snapshot.data.day.elementAt(0).miscReport;
                    //         _remarkTextEditController.text = remarkReport;
                    //         return remarkForm;
                    //       } else {
                    //         remarkReport = "";
                    //         // if (!isFocused) {
                    //         _remarkTextEditController.text = "";
                    //         // }
                    //       }
                    //     }
                    //     // if (remarkReport == "" &&
                    //     //     _remarkTextEditController.text == "" &&
                    //     //     !isFocused) {
                    //     _remarkTextEditController.text = "";
                    //     // }
                    //     return remarkForm;
                    //   },
                    // ),
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: TextButton(
                //     style: ButtonStyle(
                //       alignment: Alignment.center,
                //       backgroundColor: MaterialStateProperty.all<Color>(
                //           Color.fromRGBO(255, 153, 130, 1.0)),
                //     ),
                //     onPressed: () {
                //       APIService apiService = new APIService();
                //       //  익일 업무내용 정보가 DB에 있을 때
                //       apiService
                //           .remarkReportUpdate(member.user.organizationCode,
                //               member.user.userId, date, "")
                //           .then((value) {
                //         if (value.result.isNotEmpty) {
                //         } else {}
                //         _remarkTextEditController.text = '';
                //       });
                //     },
                //     child: Icon(
                //       Icons.delete,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      );
    }

    // #region Body
    return Scaffold(
      appBar: menuName,
      bottomNavigationBar: KulsNavigationBottomBar(
        id: id,
        pass: pass,
        member: member,
        selectedIndex: 1,
      ),
      body: GestureDetector(
        child: Container(
          color: Color.fromRGBO(248, 246, 255, 1),
          child: ListView(
            children: [
              selectDate,
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.07),
                    topRight: Radius.circular(screenWidth * 0.07),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    _writeReport("today"),
                    SizedBox(height: 30),
                    _writeReport("next"),
                    SizedBox(height: 30),
                    _remark(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _dayFocusChange(_dayFormKey.currentContext, dayFocusNode);
          _nextFocusChange(_nextFormKey.currentContext, nextFocusNode);
          _remarkFocusChange(_remarkFormKey.currentContext, remarkFocusNode);
        },
      ),
    );
  }
  // #endregion

  void _dayFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
    APIService apiService = new APIService();
    if (dayReport != _dayTextEditController.text) {
      if (dayReport == "") {
        //  INSERT
        if (nextReport == "") {
          //  익일 업무내용 정보가 DB에 없을 때
          apiService
              .dayReportInsert(member.user.organizationCode, member.user.userId,
                  date, _dayTextEditController.text)
              .then((value) {
            if (value.result.isNotEmpty) {
              dayReport = _dayTextEditController.text;
            } else {}
          });
        } else {
          //  익일 업무내용 정보가 DB에 있을 때
          apiService
              .dayReportUpdate(member.user.organizationCode, member.user.userId,
                  date, _dayTextEditController.text)
              .then((value) {
            if (value.result.isNotEmpty) {
              dayReport = _dayTextEditController.text;
            } else {}
          });
        }
      } else {
        apiService
            .dayReportUpdate(member.user.organizationCode, member.user.userId,
                date, _dayTextEditController.text)
            .then((value) {
          if (value.result.isNotEmpty) {
            dayReport = _dayTextEditController.text;
          } else {}
        });
      }
    }
    // if (_dayTextEditController.text != "") {
    // }
  }

  void _nextFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
    APIService apiService = new APIService();
    if (nextReport != _nextTextEditController.text) {
      if (nextReport == "") {
        //  INSERT
        if (dayReport == "") {
          //  일일 업무내용 정보가 DB에 없을 때
          apiService
              .nextReportInsert(member.user.organizationCode,
                  member.user.userId, date, _nextTextEditController.text)
              .then((value) {
            if (value.result.isNotEmpty) {
              nextReport = _nextTextEditController.text;
            } else {}
          });
        } else {
          //  일일 업무내용 정보가 DB에 있을 때
          apiService
              .nextReportUpdate(member.user.organizationCode,
                  member.user.userId, date, _nextTextEditController.text)
              .then((value) {
            if (value.result.isNotEmpty) {
              nextReport = _nextTextEditController.text;
            } else {}
          });
        }
      } else {
        //  일일 업무내용 정보가 DB에 있을 때
        apiService
            .nextReportUpdate(member.user.organizationCode, member.user.userId,
                date, _nextTextEditController.text)
            .then((value) {
          if (value.result.isNotEmpty) {
            nextReport = _nextTextEditController.text;
          } else {}
        });
      }
    }
  }

  void _remarkFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
    APIService apiService = new APIService();
    // if (_remarkTextEditController.text != "") {
    apiService
        .remarkReportUpdate(member.user.organizationCode, member.user.userId,
            date, _remarkTextEditController.text)
        .then((value) {
      if (value.result.isNotEmpty) {
      } else {}
    });
    // }
  }

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
}
