import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/whereis_model.dart';
import 'package:evolveofficeapp/pages/whereis_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

//행선지 관리 수정 삭제

class WhereManagePage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;

  WhereManagePage({
    this.id,
    this.pass,
    this.member,
  });
  @override
  _WhereManagePage createState() => new _WhereManagePage();
}

class _WhereManagePage extends State<WhereManagePage> {
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

  List<WhereResponseModel> whereIsValue;
  List<bool> chkBox = [];

  int itemCount = 0;
  String changeStartDate;
  DateTime changeStartDateTime;

  bool isStartChanged = false;
  int sStartDay = 0;
  DateTime _selectedStartTime;
  String startDate;

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

  void _getWhereIs(String selectedDate, {String sOrganizationcode = ""}) async {
    APIService apiService = new APIService();
    apiService
        .whereIsManage(member.user.organizationCode, member.user.userId,
            selectedDate, sOrganizationcode, deptValue)
        .then((value) {
      setState(() {
        if (value.whereIs.isNotEmpty) {
          whereIsValue = value.whereIs;
          itemCount = 0;
          for (var i = 0; i < value.whereIs.length; i++) {
            itemCount++;
          }
        } else {
          _show("조회된 데이터가 없습니다.");
        }
      });
    });
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
      case '2150':
        result = "에너지솔루션팀";
        break;
      case '2160':
        result = "물류영업팀";
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;
    date = Date().date(null);
    _selectedTime = nowDateTime;
    startDate = Date().date(null);
    _selectedStartTime = nowDateTime;
    deptValue = member.user.deptCode;

    _getWhereIs(date, sOrganizationcode: member.user.organizationCode);
  }

  void _whereDelete(String sDate, String sStart, String sEnd) async {
    setState(() {
      APIService apiService = new APIService();

      apiService
          .whereIsDelete(member.user.organizationCode, member.user.userId,
              sDate, sStart, sEnd)
          .then((value) {
        if (value.result.isNotEmpty) {
          if (value.result.elementAt(0).rsCode == "E") {
            _show(value.result.elementAt(0).rsMsg);
          } else {
            _show("행선지가 삭제되었습니다.");
          }
        } else {
          _show("삭제에 실패하였습니다.");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double tableWidth = (screenWidth * 0.9) / 5;

    final menuName = Container(
      color: Color.fromRGBO(244, 242, 255, 1),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Center(
        child: Text(
          '행선지 현황',
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
              _getWhereIs(startDate);
              // _getDailySelect(startDate, endDate);
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
        child: Text(whereIsValue.elementAt(index).userName),
        width: tableWidth,
        height: 50,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    }

    Widget rightColumnRowContent(
        String sText, Alignment sAlign, double sWidth) {
      return Container(
        child: Text(sText),
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
        onLongPress: () {
          if (whereIsValue.elementAt(index).startTime != '') {
            if (member.user.nameKor == whereIsValue.elementAt(index).userName) {
              _showMessage(
                "수정 또는 삭제를 선택해주세요.",
                whereIsValue.elementAt(index).startTime,
                whereIsValue.elementAt(index).endTime,
                whereIsValue.elementAt(index).area,
                whereIsValue.elementAt(index).whereIsContents,
                whereIsValue.elementAt(index).carType,
              );
            }
          }
        },
        child: Row(
          children: <Widget>[
            rightColumnRowContent(
                whereIsValue.elementAt(index).startTime == ''
                    ? ''
                    : whereIsValue.elementAt(index).startTime.substring(0, 2) +
                        ":" +
                        whereIsValue.elementAt(index).startTime.substring(2, 4),
                Alignment.center,
                tableWidth),
            rightColumnRowContent(
                whereIsValue.elementAt(index).endTime == ''
                    ? ''
                    : whereIsValue.elementAt(index).endTime.substring(0, 2) +
                        ":" +
                        whereIsValue.elementAt(index).endTime.substring(2, 4),
                Alignment.center,
                tableWidth),
            // rightColumnRowContent(
            //     whereIsValue.elementAt(index).area, Alignment.centerLeft),
            rightColumnRowContent(whereIsValue.elementAt(index).whereIsContents,
                Alignment.center, tableWidth),
            rightColumnRowContent(whereIsValue.elementAt(index).carType,
                Alignment.center, tableWidth),
          ],
        ),
      );
    }

    whereIsDataTable() {
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
                  color: Color.fromRGBO(74, 63, 186, 1),
                  width: 3,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: screenHeight * 0.6,
            margin: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            child: HorizontalDataTable(
              leftHandSideColumnWidth: tableWidth,
              rightHandSideColumnWidth: tableWidth * 4,
              isFixedHeader: true,
              headerWidgets: [
                dataTableHeader('이름', tableWidth),
                dataTableHeader('시작시간', tableWidth),
                dataTableHeader('종료시간', tableWidth),
                dataTableHeader('행선지', tableWidth),
                dataTableHeader('교통편', tableWidth),
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
        child: Container(
          color: Color.fromRGBO(244, 242, 255, 1),
          child: ListView(
            children: [
              menuName,
              // selectDate,selectHeader
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
                    SizedBox(height: 10),
                    selectHeader,
                    whereIsDataTable(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }

  // #endregion
  //
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

  _showMessage(String sMessage, String sStartTime, String sEndTime,
      String sArea, String sWhereIsContents, String sCarType) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // title: Text("AlertDialog"),
          content: Text(sMessage),
          actions: [
            TextButton(
              child: Text("삭제"),
              onPressed: () {
                _whereDelete(date, sStartTime, sEndTime);
                Navigator.of(context).pop(true);
                setState(() {
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) => super.widget,
                      //     WhereManagePage(
                      //   id: id,
                      //   pass: pass,
                      //   member: member,
                      // ),
                    ),
                  );
                });
              },
            ),
            TextButton(
              child: Text("수정"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => WhereIsPage(
                      id: id,
                      pass: pass,
                      member: member,
                      isUpdate: true,
                      updateDate: DateTime.parse(date),
                      startTime: sStartTime,
                      endTime: sEndTime,
                      area: sArea,
                      contents: sWhereIsContents,
                      carType: sCarType,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: Text("취소"),
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
