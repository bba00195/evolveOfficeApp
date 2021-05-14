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
    APIService apiService = new APIService();
    apiService
        .dailySelect(startDate, startDate, member.user.userId, deptValue,
            member.user.organizationCode)
        .then((value) {
      setState(() {
        if (value.dailySelect.isNotEmpty) {
          dailySelectValue = value.dailySelect;
          itemCount = 0;
          for (var i = 0; i < value.dailySelect.length; i++) {
            itemCount++;
          }
        } else {
          _show("조회된 데이터가 없습니다.");
        }
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
    super.initState();

    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;

    startDate = Date().date(null);
    endDate = Date().date(null);
    _selectedStartTime = nowDateTime;
    _selectedEndTime = nowDateTime;
    nameFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final menuName = Container(
      color: Color.fromRGBO(248, 246, 255, 1),
      child: Center(
        child: Text(
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

    Widget selectHeader = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Expanded(
              //   flex: 1,
              //   child: Text(
              //     '사업부',
              //     style: TextStyle(
              //       color: Colors.blueGrey[600],
              //       fontFamily: 'NotoSansKR',
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              // Expanded(
              //   flex: 3,
              //   child: Container(
              //     height: 40,
              //     padding: EdgeInsets.only(left: 10),
              //     margin: EdgeInsets.only(right: 10),
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
              //       child: DropdownButton(
              //         isExpanded: true,
              //         value: organizationValue,
              //         items: _organizationList.map(
              //           (value) {
              //             return DropdownMenuItem(
              //               value: value,
              //               child: Text(
              //                 organization(value),
              //                 style: TextStyle(
              //                   fontSize: 14,
              //                   fontFamily: 'NotoSansKR',
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //             );
              //           },
              //         ).toList(),
              //         onChanged: (value) {
              //           setState(() {
              //             organizationValue = value;
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Text(
                  '부서명',
                  style: TextStyle(
                    color: Colors.blueGrey[600],
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
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
                            child: Text(
                              department(value),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          deptValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    '일자',
                    style: TextStyle(
                      color: Colors.blueGrey[600],
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 5, right: 10),
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
                    child: TextButton(
                      onPressed: () {
                        Future<DateTime> selectStartDate = showDatePicker(
                          context: context,
                          initialDate: _selectedStartTime, // 초깃값
                          firstDate: DateTime(2018), // 시작일
                          lastDate: DateTime(2030), // 마지막일
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light(),
                              child: child,
                            );
                          },
                        );
                        selectStartDate.then((dateTime) {
                          setState(() {
                            if (dateTime != null) {
                              isStartChanged = true;
                              _selectedStartTime = dateTime;
                              sStartDay =
                                  dateTime.difference(DateTime.now()).inDays;
                            } else {
                              dateTime = _selectedStartTime;
                            }
                            changeStartDate = DateFormat('yyyy-MM-dd')
                                .format(_selectedStartTime);
                            startDate = Date().date(_selectedStartTime);
                          });
                        });
                      },
                      child: Text(
                        isStartChanged
                            ? changeStartDate
                            : DateFormat('yyyy-MM-dd')
                                .format(new DateTime.now()),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NotoSansKR',
                          color: Colors.black,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(
                left: 45,
                right: 10,
              ),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.indigo[900],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6.0,
                    offset: const Offset(0.0, 3.0),
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  //   Icons.search,
                  //   color: Colors.white,
                  // ),
                  // SizedBox(width: 5),
                  Text(
                    '조회',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              _getDailySelect(startDate);
            },
          ),
        ],
      ),
    );

    Widget dataTableHeader(String sColumn, double sWidth) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.white38,
              width: 1,
            ),
            right: BorderSide(
              color: Colors.white38,
              width: 1,
            ),
          ),
          color: Colors.grey[100],
        ),
        child: Text(
          sColumn,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        width: sWidth,
        height: 50,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    }

    Widget _generateFirstColumnRow(BuildContext context, int index) {
      return Container(
        child: Text(dailySelectValue.elementAt(index).userName),
        width: 80,
        height: 50,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    }

    Widget rightColumnRowContent(
        String sText, Alignment sAlign, double sWidth) {
      return Container(
        child: Text(sText, overflow: TextOverflow.ellipsis),
        width: sWidth,
        height: 50,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: sAlign,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.grey[100],
              width: 1,
            ),
            right: BorderSide(
              color: Colors.grey[100],
              width: 1,
            ),
          ),
        ),
      );
    }

    Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
      return InkWell(
        onDoubleTap: () {
          _showReport(
            dailySelectValue.elementAt(index).userName,
            dailySelectValue.elementAt(index).viewDate,
            dailySelectValue.elementAt(index).deptName,
            dailySelectValue.elementAt(index).dayReport,
            dailySelectValue.elementAt(index).nextReport,
            dailySelectValue.elementAt(index).miscReport,
          );
        },
        child: Row(
          children: <Widget>[
            rightColumnRowContent(dailySelectValue.elementAt(index).viewDate,
                Alignment.center, 80),
            rightColumnRowContent(dailySelectValue.elementAt(index).deptName,
                Alignment.center, 100),
            rightColumnRowContent(dailySelectValue.elementAt(index).dayReport,
                Alignment.centerLeft, 100),
            rightColumnRowContent(dailySelectValue.elementAt(index).nextReport,
                Alignment.centerLeft, 100),
            rightColumnRowContent(dailySelectValue.elementAt(index).miscReport,
                Alignment.centerLeft, 80),
          ],
        ),
      );
    }

    dailyDataTable() {
      return Column(
        // alignment:
        //     AlignmentDirectional.topStart, //alignment:new Alignment(x, y)
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 30,
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(74, 63, 186, 1),
                  width: 3,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: screenHeight * 0.7,
            margin: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 80,
              rightHandSideColumnWidth: 460,
              isFixedHeader: true,
              headerWidgets: [
                dataTableHeader('작성자', 80),
                dataTableHeader('일자', 80),
                dataTableHeader('부서명', 100),
                // dataTableHeader('지역'),
                dataTableHeader('일일업무내용', 100),
                dataTableHeader('익일업무내용', 100),
                dataTableHeader('특이사항', 80),
              ],
              leftSideItemBuilder: _generateFirstColumnRow,
              rightSideItemBuilder: _generateRightHandSideColumnRow,
              itemCount: itemCount,
              rowSeparatorWidget: const Divider(
                color: Colors.black54,
                height: 1.0,
                thickness: 0.0,
              ),
              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
              onRefresh: () {},
            ),
          ),
        ],
      );
    }

    cardContentHeader(String sMenu) {
      return Container(
        height: 20,
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
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
        child: Text(
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
                  Expanded(
                    flex: 2,
                    child: Text(
                      sUserName,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        '[' + sDeptName + ']',
                        style: TextStyle(
                          color: Colors.black87,
                          // fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      DateFormat('yyyy년 MM월 dd일')
                          .format(DateTime.parse(sWorkDate)),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
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
                  cardContent(sNextReport),
                  if (sMiscReport != "") cardContentHeader("특이사항"),
                  cardContent(sMiscReport),
                ],
              ),
            ),
          ],
        ),
      );
    }

    contentTable() {
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
        onTap: () {
          nameFocusNode.unfocus();
        },
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

  _showReport(String sUserName, String sViewDate, String sDeptName,
      String sDayReport, String sNextReport, String sMiscReport) {
    showDialog(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width - 70,
            padding: EdgeInsets.all(25),
            margin: EdgeInsets.only(
              left: 35,
              right: 35,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6.0,
                  offset: const Offset(1.0, 3.0),
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                )
              ],
            ),
            child: ListView(
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      sUserName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      sViewDate,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  // height: 20,
                  width: MediaQuery.of(context).size.width - 125,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(228, 220, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '일일 업무 내용',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 125,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(
                    minHeight: 100,
                    minWidth: double.infinity,
                    // maxHeight: 400,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: const Offset(1.0, 3.0),
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      )
                    ],
                  ),
                  child: Text(
                    sDayReport,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width - 125,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(228, 220, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '익일 업무 내용',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 125,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(
                    minHeight: 100,
                    minWidth: double.infinity,
                    // maxHeight: 400,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: const Offset(1.0, 3.0),
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      )
                    ],
                  ),
                  child: Text(
                    sNextReport,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width - 125,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(228, 220, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '특이사항',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width - 125,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(
                    minHeight: 40,
                    // minWidth: double.infinity,
                    // maxHeight: 400,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: const Offset(1.0, 3.0),
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      )
                    ],
                  ),
                  child: Text(
                    // sMiscReport,
                    sMiscReport,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
