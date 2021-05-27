import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolveofficeapp/api/api_service_new.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

class DailySelectPage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;

  DailySelectPage({
    this.id,
    this.pass,
    this.member,
  });
  @override
  _DailySelectPage createState() => new _DailySelectPage();
}

class _DailySelectPage extends State<DailySelectPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final storage = FlutterSecureStorage();
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  bool _showBackToTopButton = false;
  final ScrollController _scrollController = ScrollController();

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

  Future<DailyResultModel> futureAlbum;
  FocusNode nameFocusNode;

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

  void _getDailySelect(String startDate) async {
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
        } else {
          // _show("조회된 데이터가 없습니다.");
        }
      });
    });
    // APIService apiService = new APIService();
    // apiService
    //     .dailySelect(startDate, startDate, member.user.userId, deptValue,
    //         member.user.organizationCode)
    //     .then((value) {
    //   setState(() {
    //     if (value.dailySelect.isNotEmpty) {
    //       dailySelectValue = value.dailySelect;
    //       itemCount = 0;
    //       for (var i = 0; i < value.dailySelect.length; i++) {
    //         itemCount++;
    //       }
    //     } else {
    //       _show("조회된 데이터가 없습니다.");
    //     }
    //   });
    // });
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

    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset >= 400) {
          _showBackToTopButton = true; // show the back-to-top button
        } else {
          _showBackToTopButton = false; // hide the back-to-top button
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameTextEditController.dispose();
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(seconds: 1),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    _dayDecrease() {
      isChanged = true;
      sDay--;
      changeDate = Date().getDate(sDay);
      // date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
      date = Date().date(DateTime.now().add(Duration(days: sDay)));
      _getDailySelect(date);
    }

    _dayIncrease() {
      isChanged = true;
      sDay++;
      changeDate = Date().getDate(sDay);
      date = Date().date(DateTime.now().add(Duration(days: sDay)));
      _getDailySelect(date);
    }

    final menuName = Container(
      color: Color.fromRGBO(248, 246, 255, 1),
      child: Center(
        child: AutoSizeText(
          '일일업무 조회',
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
      // color: Color.fromRGBO(248, 246, 255, 1),
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
                    if (dateTime != null) {
                      isChanged = true;
                      _selectedTime = dateTime;
                      sDay = dateTime.difference(DateTime.now()).inDays;
                      _getDailySelect(date);
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

    Widget selectHeader = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: AutoSizeText(
                    '부서',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey[600],
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                    maxFontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: const Offset(0.0, 3.0),
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      )
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: deptValue,
                      items: _deptList.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: AutoSizeText(
                              department(value),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w600,
                              ),
                              minFontSize: 10,
                              maxLines: 1,
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          deptValue = value;
                          _getDailySelect(date);
                        });
                      },
                    ),
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 10),
              //   child: AutoSizeText(
              //     '일자',
              //     style: TextStyle(
              //       color: Colors.blueGrey[600],
              //       fontFamily: 'NotoSansKR',
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              // Expanded(
              //   flex: 4,
              //   child: Container(
              //     height: 40,
              //     margin: EdgeInsets.only(left: 5, right: 10),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //       boxShadow: [
              //         BoxShadow(
              //           blurRadius: 6.0,
              //           offset: const Offset(0.0, 3.0),
              //           color: Color.fromRGBO(0, 0, 0, 0.16),
              //         )
              //       ],
              //     ),
              //     child: DropdownButtonHideUnderline(
              //       child: TextButton(
              //         onPressed: () {
              //           Future<DateTime> selectStartDate = showDatePicker(
              //             context: context,
              //             initialDate: _selectedStartTime, // 초깃값
              //             firstDate: DateTime(2018), // 시작일
              //             lastDate: DateTime(2030), // 마지막일
              //             builder: (BuildContext context, Widget child) {
              //               return Theme(
              //                 data: ThemeData.light(),
              //                 child: child,
              //               );
              //             },
              //           );
              //           selectStartDate.then((dateTime) {
              //             setState(() {
              //               if (dateTime != null) {
              //                 isStartChanged = true;
              //                 _selectedStartTime = dateTime;
              //                 sStartDay =
              //                     dateTime.difference(DateTime.now()).inDays;
              //               } else {
              //                 dateTime = _selectedStartTime;
              //               }
              //               changeStartDate = DateFormat('yyyy-MM-dd')
              //                   .format(_selectedStartTime);
              //               startDate = Date().date(_selectedStartTime);
              //             });
              //           });
              //         },
              //         child: AutoSizeText(
              //           isStartChanged
              //               ? changeStartDate
              //               : DateFormat('yyyy-MM-dd')
              //                   .format(new DateTime.now()),
              //           textAlign: TextAlign.left,
              //           style: TextStyle(
              //             fontSize: 14,
              //             fontFamily: 'NotoSansKR',
              //             color: Colors.black,
              //             // fontWeight: FontWeight.w600,
              //           ),
              //           maxFontSize: 16,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 15),
          selectDate,
          // InkWell(
          //   child: Container(
          //     margin: EdgeInsets.only(
          //       left: 45,
          //       right: 10,
          //     ),
          //     height: 40,
          //     decoration: BoxDecoration(
          //       color: Colors.indigo[900],
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: [
          //         BoxShadow(
          //           blurRadius: 6.0,
          //           offset: const Offset(0.0, 3.0),
          //           color: Color.fromRGBO(0, 0, 0, 0.16),
          //         )
          //       ],
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         // Icon(
          //         //   Icons.search,
          //         //   color: Colors.white,
          //         // ),
          //         // SizedBox(width: 5),
          //         AutoSizeText(
          //           '조회',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 20,
          //             fontFamily: 'NotoSansKR',
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          //   onTap: () {
          //     _getDailySelect(startDate);
          //   },
          // ),
        ],
      ),
    );

    cardContentHeader(String sMenu) {
      return Container(
        height: 20,
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: AutoSizeText(
          sMenu,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Color.fromRGBO(3, 65, 136, 1),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      );
    }

    cardContent(String sContent) {
      return Container(
        padding: EdgeInsets.all(3),
        child: AutoSizeText(
          sContent,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      );
    }

    Color cardColor(String sDeptName) {
      Color result;
      switch (sDeptName) {
        case 'S/W검증팀':
          result = Colors.cyan[100];
          break;
        case 'H/W개발팀':
          result = Colors.teal[100];
          break;
        case '헬스케어사업팀':
          result = Colors.lime[100];
          break;
        case '모바일솔루션팀':
          result = Colors.brown[100];
          break;
        case '솔루션컨설팅팀':
          result = Colors.blue[100];
          // .fromRGBO(232, 228, 255, 1);
          break;
        case '기술영업':
          result = Colors.purple[100];
          break;
        case '에너지솔루션팀':
          result = Colors.green[200];
          break;
        case '물류솔루션팀':
          result = Colors.amber[100];
          break;
        case '경영지원팀':
          result = Colors.red[100];
          break;
        case '종합건설':
          result = Colors.lightGreen[100];
          break;
        default:
          result = Colors.white;
          break;
      }
      return result;
    }

    cardTable(String sUserName, String sDeptName, String sWorkDate,
        String sDailyReport, String sNextReport, String sMiscReport) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 6.0,
              offset: const Offset(1.0, 3.0),
              color: Color.fromRGBO(0, 0, 0, 0.2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cardColor(sDeptName),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
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
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: AutoSizeText(
                        '[' + sDeptName + ']',
                        style: TextStyle(
                          color: Colors.black87,
                          // fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxFontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      DateFormat('yyyy. MM. dd')
                          .format(DateTime.parse(sWorkDate)),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                      maxFontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cardContentHeader("금일업무 내용"),
                  cardContent(sDailyReport),
                  cardContentHeader("익일업무 내용"),
                  cardContent(sNextReport)
                ],
              ),
            ),
          ],
        ),
      );
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
                    dailySelectValue.elementAt(i).workDate,
                    dailySelectValue.elementAt(i).dayReport,
                    dailySelectValue.elementAt(i).nextReport,
                    dailySelectValue.elementAt(i).miscReport),
            ],
          ),
        );
      } else {
        return Container();
      }
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
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: 10),
                menuName,
                SizedBox(height: 20),
                Container(
                  constraints: BoxConstraints(
                    minHeight: 500,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.07),
                      topRight: Radius.circular(screenWidth * 0.07),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      selectHeader,
                      SizedBox(height: 20),
                      // dailyDataTable(),
                      contentTable(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          nameFocusNode.unfocus();
        },
      ),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.arrow_upward),
            ),
    );
  }
  // #endregion
  //
  //
  //

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
