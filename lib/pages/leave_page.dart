import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolveofficeapp/api/api_service_new.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';

class LeaveManagePage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;
  final bool isUpdate;
  final DateTime updateDate;
  final String startTime;
  final String endTime;
  final String area;
  final String contents;
  final String carType;

  LeaveManagePage({
    this.id,
    this.pass,
    this.member,
    this.isUpdate,
    this.updateDate,
    this.startTime,
    this.endTime,
    this.area,
    this.contents,
    this.carType,
  });
  @override
  _LeaveManagePage createState() => new _LeaveManagePage();
}

class _LeaveManagePage extends State<LeaveManagePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final storage = FlutterSecureStorage();
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String pass;
  UserManager member;
  String changeStartDate;
  String changeEndDate;
  DateTime changeStartDateTime;
  DateTime changeEndDateTime;

  bool isStartChanged = false;
  bool isEndChanged = false;
  int sStartDay = 0;
  int sEndDay = 0;
  DateTime nowDateTime = DateTime.now();
  DateTime _selectedStartTime;
  DateTime _selectedEndTime;
  String startDate;
  String endDate;

  bool isChanged = false;
  DateTime _selectedTime;
  int sDay = 0;
  String changeDate;
  String date;
  String dayPrefix = "";
  String nextPrefix = "";

  Future<DailyResultModel> futureAlbum;
  FocusNode nameFocusNode;

  final _controller =
      TextEditingController(text: '휴가 사유를 입력하세요'); // (var)Focus Text

  CalendarFormat format = CalendarFormat.month; // (var)calendar
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final _organizationList = [
    'CW',
    'SU',
    'SW',
    'CS',
  ];
  var organizationValue = 'CW';

  final _deptList = [
    '',
    '1220',
    '1230',
    '1240',
    '1270',
    '2110',
    '2120',
    '2130',
    '2140',
    '2150',
    '2160',
    '2210',
    '4001',
  ];
  var deptValue = '';

  final _nameTextEditController = TextEditingController();
  List<DailySelectResponseModel> dailySelectValue;
  List<bool> chkBox = [];
  int itemCount = 0;

  void _getDailySelect() async {
    APIServiceNew apiServiceNew = new APIServiceNew();

    List<String> sParam = [
      startDate,
      startDate,
      "WK_DAILYMONTH",
      member.user.userId,
      "",
      "",
      deptValue,
      "",
      member.user.organizationCode
    ];

    apiServiceNew.getSelect("DAILY_S1", sParam).then((value) {
      setState(() {
        itemCount = 0;
        if (value.dailySelect.isNotEmpty) {
          dailySelectValue = value.dailySelect;
          for (var i = 0; i < value.dailySelect.length; i++) {
            itemCount++;
          }
        } else {}
      });
    });
  }

  @override
  void dispose() {
    _nameTextEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;

    startDate = Date().date(null);
    endDate = Date().date(null);
    _selectedStartTime = nowDateTime;
    _selectedEndTime = nowDateTime;
    nameFocusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // #메뉴네임
    final menuName = Container(
      color: Color.fromRGBO(244, 242, 255, 1),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
          child: AutoSizeText('휴가원 관리',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'NotoSansKR',
                fontWeight: FontWeight.w600,
              ))),
    );
    // #직원조회
    final memberSelect = Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ExpansionTile(
          title: Container(
              child: Row(children: <Widget>[
            SizedBox(width: 10),
            Expanded(
                child: Container(
                    child: Text('직원들',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'NotoSansKR',
                          // fontWeight: FontWeight.w600,
                        )))),
            SizedBox(width: 200),
            Expanded(
                // 아이콘 필요 시 = Row, 불필요 시 = Container
                child: Row(children: [
              Text('관리자',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'NotoSansKR'
                      // fontWeight: FontWeight.w600,
                      )),
              // SizedBox(width: 10),
              // Icon(Icons.contacts)
            ]))
          ])),
          children: [
            leaveIsDataTable(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 30),
                      Expanded(
                          flex: 2,
                          child: Container(
                              child: AutoSizeText(
                            '부서',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey[600],
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w600),
                            maxFontSize: 14,
                          ))),
                      Expanded(
                          flex: 8,
                          child: Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple[100],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 6.0,
                                      offset: const Offset(0.0, 3.0),
                                      color: Color.fromRGBO(0, 0, 0, 0.16),
                                    )
                                  ]),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      isExpanded: true,
                                      value: deptValue,
                                      items: _deptList.map((value) {
                                        return DropdownMenuItem(
                                            value: value,
                                            child: AutoSizeText(
                                              department(value),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: 'NotoSansKR',
                                              ),
                                              minFontSize: 10,
                                              maxLines: 1,
                                            ));
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          deptValue = value;
                                          _getDailySelect();
                                        });
                                      }))))
                    ],
                  ),
                  SizedBox(height: 15),
                  contentTable(),
                ],
              ),
            ),
          ]),
    );

    // #휴가유형
    final leaveSelect = Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ExpansionTile(
        title: Container(
            child: Row(
          children: <Widget>[
            Expanded(
                child: Text('휴가 유형',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'NotoSansKR',
                    ))),
            Expanded(
                child: Row(children: [
              Text('[연차] 연차8h (8h, 1일)',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'NotoSansKR'
                      // fontWeight: FontWeight.w600,
                      ))
            ]))
          ],
        )),
        children: [
          leaveIsDataTable(),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.black38),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('휴가 발생 건 추가하기',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.bold)),
                ],
              )),
          SizedBox(width: 10),
          Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.black38),
              )),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('휴가 그룹',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'NotoSansKR')),
                  Text('연차'),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.black38),
              )),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('발행 일수',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'NotoSansKR',
                      )),
                  Text('15 일'),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.black38),
              )),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('발행 시점',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'NotoSansKR',
                      )),
                  Text('2020년 6월 1일, 수요일'),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.black38),
              )),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('만료 시점',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'NotoSansKR',
                      )),
                  Text('2020년 6월 1일, 수요일'),
                ],
              )),
          Container(),
        ],
      ),
    );
    // #휴가사유 입력 창
    final leaveReason = Container(
      padding: EdgeInsets.only(left: 20),
      width: screenWidth - (screenWidth * 0.3),
      decoration: BoxDecoration(color: Colors.white),
      child: TextFormField(
          controller: _controller,
          onTap: () {
            _controller.selection = new TextSelection(
                baseOffset: 0, extentOffset: (_controller.text).length);
          }),
    );
    // #캘린더
    final calendar = Container(
        // child: TableCalendar(
        //     rowHeight: 35,
        //     focusedDay: focusedDay,
        //     firstDay: DateTime(1990),
        //     lastDay: DateTime(2050),
        //     calendarFormat: format,
        //     onFormatChanged: (CalendarFormat _format) {
        //       setState(() {
        //         format = _format;
        //       });
        //     },
        //     startingDayOfWeek: StartingDayOfWeek.sunday,
        //     daysOfWeekVisible: true,

        //     // 날짜 변경
        //     onDaySelected: (DateTime selectDay, DateTime focusDay) {
        //       setState(() {
        //         selectedDay = selectDay;
        //         focusedDay = focusDay;
        //       });
        //       print(focusDay);
        //     },
        //     selectedDayPredicate: (DateTime date) {
        //       return isSameDay(selectedDay, date);
        //     },

        //     // 스타일
        //     calendarStyle: CalendarStyle(
        //         weekendTextStyle: TextStyle().copyWith(color: Colors.red),
        //         holidayTextStyle: TextStyle().copyWith(color: Colors.blue[800]),
        //         isTodayHighlighted: true,
        //         selectedDecoration: BoxDecoration(
        //           color: Colors.blue,
        //           shape: BoxShape.circle,
        //         ),
        //         selectedTextStyle: TextStyle(color: Colors.white),
        //         todayDecoration: BoxDecoration(
        //           color: Colors.purpleAccent,
        //           shape: BoxShape.circle,
        //         )),
        //     headerStyle: HeaderStyle(
        //         formatButtonVisible: true,
        //         titleCentered: true,
        //         formatButtonShowsNext: false,
        //         formatButtonDecoration: BoxDecoration(
        //           color: Colors.blue,
        //         ),
        //         formatButtonTextStyle: TextStyle(
        //           color: Colors.white,
        //         ))),
        );

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
      backgroundColor: Colors.white,
      bottomNavigationBar: KulsNavigationBottomBar(
        globalKey: _scaffoldKey,
        id: id,
        pass: pass,
        member: member,
        selectedIndex: 1,
      ),
      body: GestureDetector(
          // 포커싱 제거
          onTap: () {
            FocusScope.of(context).unfocus();
            new TextEditingController().clear();
          },
          // Body 컨테이너
          child: Container(
              color: Color.fromRGBO(244, 242, 255, 1),
              child: ListView(
                children: [
                  menuName,
                  memberSelect,
                  leaveSelect,
                  leaveReason,
                  calendar,
                  SizedBox(height: 10)
                ],
              ))),
    );
  }
  // #endregion

  // Method
  leaveIsDataTable() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              height: 10,
              // width: screenWidth * 0.9,
              // margin: EdgeInsets.only(
              // left: screenWidth * 0.05,
              // right: screenWidth * 0.05,
              // ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromRGBO(74, 63, 186, 1), width: 1)))),
          Container(
              color: Colors.white,
              // height: screenHeight * 0.55,
              constraints: BoxConstraints(minHeight: 10)
              // margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              )
        ]);
  }

  String organization(String value) {
    String result = '';
    switch (value) {
      case 'CW':
        result = "부산사업본부";
        break;
      case 'SU':
        result = "서울사업본부";
        break;
      case 'SW':
        result = "경남사업본부";
        break;
      case 'CS':
        result = "쿨스종합건설";
        break;
      default:
        break;
    }
    return result;
  }

  String department(String value) {
    String result = '';
    switch (value) {
      case '':
        result = "ALL";
        break;
      case '1220':
        result = "S/W검증팀";
        break;
      case '1230':
        result = "H/W개발팀";
        break;
      case '1240':
        result = "헬스케어사업팀";
        break;
      case '1270':
        result = "모바일솔루션팀";
        break;
      case '2110':
        result = "솔루션컨설팅팀";
        break;
      case '2120':
        result = "기술영업팀";
        break;
      case '2130':
        result = "CE팀";
        break;
      case '2140':
        result = "CE팀";
        break;
      case '2150':
        result = "에너지솔루션팀";
        break;
      case '2160':
        result = "물류솔루션팀";
        break;
      case '2210':
        result = "경영지원팀";
        break;
      case '4001':
        result = "종합건설";
        break;
      default:
        break;
    }
    return result;
  }

  cardTable(String sUserName, String sDeptName) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 6.0,
              offset: const Offset(1.0, 3.0),
              color: Color.fromRGBO(0, 0, 0, 0.2))
        ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    sUserName,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    maxFontSize: 14,
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: AutoSizeText('[' + sDeptName + ']',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 12),
                              maxFontSize: 14)))
                ],
              ),
            )
          ],
        ));
  }

  contentTable() {
    if (itemCount > 0) {
      return SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < itemCount; i++)
            cardTable(
              dailySelectValue.elementAt(i).userName,
              dailySelectValue.elementAt(i).deptName,
            )
        ],
      ));
    } else {
      return Container();
    }
  }

  _show(String sMessage) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: AutoSizeText(sMessage),
          actions: [
            TextButton(
              child: AutoSizeText("확인"),
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
