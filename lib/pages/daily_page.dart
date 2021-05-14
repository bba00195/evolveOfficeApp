import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final storage = FlutterSecureStorage();
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
  bool isSaved = false;

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
          dayReport = value.day.elementAt(0).dayReport;
          nextReport = value.day.elementAt(0).nextReport;
          remarkReport = value.day.elementAt(0).miscReport;
        } else {
          dayReport = "";
          nextReport = "";
          remarkReport = "";
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

    _report(
      date,
    );
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
      if (_dayTextEditController.text == "" &&
          _nextTextEditController.text == "") {
        _show("업무 내용 먼저 작성해주세요.");
        remarkFocusNode.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
      // date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
      date = Date().date(DateTime.now().add(Duration(days: sDay)));
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
      date = Date().date(DateTime.now().add(Duration(days: sDay)));
      _report(date);
    }

    final menuName = Container(
      color: Color.fromRGBO(248, 246, 255, 1),
      child: Center(
        child: Text(
          '일일업무 등록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'NotoSansKR',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    final selectDate = Container(
      color: Color.fromRGBO(248, 246, 255, 1),
      // margin: EdgeInsets.only(
      //   right: screenWidth * 0.05,
      // ),
      padding: EdgeInsets.only(
        left: screenWidth * 0.05,
      ),
      height: 60,
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
                    if (dateTime != null) {
                      isFocused = false;
                      isChanged = true;
                      _selectedTime = dateTime;
                      sDay = dateTime.difference(DateTime.now()).inDays;
                      _report(date);
                    } else {
                      dateTime = _selectedTime;
                    }
                    changeDate = Date().getDateString(_selectedTime);
                    date = Date().date(_selectedTime);
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

    Widget saveButton = Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      ),
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 22),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5),
          ),
          primary: Colors.indigo[900],
        ),
        onPressed: () {
          _doSave();
          if (isSaved) {
            _show("등록이 완료되었습니다.");
          } else {
            _show("내용을 입력하거나 수정해주세요.");
          }
        },
        child: Text(
          '등록',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );

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
          fontSize: 14,
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
          fontSize: 14,
          fontFamily: 'NotoSansKR',
        ),
        // textInputAction: TextInputAction.next,
        // onFieldSubmitted: (value) {
        //   _nextFocusChange(_nextFormKey.currentContext, nextFocusNode);
        // },
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
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

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
          fontSize: 14,
          fontFamily: 'NotoSansKR',
        ),
        // textInputAction: TextInputAction.next,
        // onFieldSubmitted: (value) {
        //   _dayFocusChange(_dayFormKey.currentContext, dayFocusNode);
        // },
      ),
    );

    _remark() {
      return Column(
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
          Container(
            height: screenHeight * 0.14,
            margin: EdgeInsets.only(
              top: 14,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // #region Body
    return Scaffold(
      key: _scaffoldKey,
      appBar: KulsAppBar(
        globalKey: _scaffoldKey,
        id: id,
        pass: pass,
        member: member,
        storage: storage,
      ),
      drawer: KulsDrawer(
        id: id,
        pass: pass,
        member: member,
        storage: storage,
      ),
      // appBar: menuName,
      bottomNavigationBar: KulsNavigationBottomBar(
        globalKey: _scaffoldKey,
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
              SizedBox(height: 10),
              menuName,
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
                    SizedBox(height: 5),
                    saveButton,
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
          dayFocusNode.unfocus();
          nextFocusNode.unfocus();
          remarkFocusNode.unfocus();
          // _dayFocusChange(_dayFormKey.currentContext, dayFocusNode);
          // _nextFocusChange(_nextFormKey.currentContext, nextFocusNode);
          // _remarkFocusChange(_remarkFormKey.currentContext, remarkFocusNode);
        },
      ),
    );
  }
  // #endregion

  void _doSave() {
    isSaved = false;
    dayFocusNode.unfocus();
    nextFocusNode.unfocus();
    remarkFocusNode.unfocus();
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
      isSaved = true;
    }
    if (nextReport != _nextTextEditController.text) {
      if (nextReport == "") {
        //  INSERT
        if (dayReport == "" && _dayTextEditController.text == "") {
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
      isSaved = true;
    }
    if (remarkReport != _remarkTextEditController.text) {
      apiService
          .remarkReportUpdate(member.user.organizationCode, member.user.userId,
              date, _remarkTextEditController.text)
          .then((value) {
        if (value.result.isNotEmpty) {
          remarkReport = _remarkTextEditController.text;
        } else {}
      });
      isSaved = true;
    }
  }

  void _dayFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
  }

  void _nextFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
  }

  void _remarkFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
  }

  _show(String sMessage) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
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
