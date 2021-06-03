import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolveofficeapp/api/api_service_new.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:evolveofficeapp/pages/dailySelect_popup.dart';
import 'package:evolveofficeapp/pages/daily_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  DailySelectPages createState() => new DailySelectPages();
}

class DailySelectPages extends State<DailySelectPage> {
  DailyPageWrite _dailyPageWrite = DailyPageWrite();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final storage = FlutterSecureStorage();
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  APIServiceNew apiServiceNew = new APIServiceNew();

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
  String startDate;
  String endDate;

  bool isOpen = false;
  Widget sIcon;

  bool isChanged = false;
  DateTime _selectedTime;
  int sDay = 0;
  String changeDate;
  String date;

  Future<DailyResultModel> futureAlbum;
  FocusNode nameFocusNode;
  var organizationValue = 'CW';

  final _deptList = [
    '',
    '1220',
    '1230',
    '1240',
    '1270',
    '2110',
    '2120',
    '2140',
    '2150',
    '2160',
    '2210',
    '4001',
  ];
  var deptValue = '';

  List<DailySelectResponseModel> dailySelectValue;
  List<bool> chkBox = [];

  int itemCount = 0;

  void _report(String selectedDate) async {
    setState(() {
      // APIService apiService = new APIService();
      // futureAlbum = apiService.report(
      //     member.user.organizationCode, member.user.userId, selectedDate);
      List<String> sParam = [
        member.user.organizationCode,
        selectedDate,
        member.user.userId
      ];

      APIServiceNew apiServiceNew = new APIServiceNew();
      apiServiceNew.getSelect("REPORT_S1", sParam).then((value) {
        if (value.day.isNotEmpty) {
          _dailyPageWrite.dayTextEditController.text =
              value.day.elementAt(0).dayReport;
          _dailyPageWrite.nextTextEditController.text =
              value.day.elementAt(0).nextReport;
          _dailyPageWrite.dayReport = value.day.elementAt(0).dayReport;
          _dailyPageWrite.nextReport = value.day.elementAt(0).nextReport;
        } else {
          _dailyPageWrite.dayReport = "";
          _dailyPageWrite.nextReport = "";
          _dailyPageWrite.dayTextEditController.text = "";
          _dailyPageWrite.nextTextEditController.text = "";
        }
      });

      // APIService apiService = new APIService();
      // apiService
      //     .report(
      //         member.user.organizationCode, member.user.userId, selectedDate)
      //     .then((value) {
      //   if (value.day.isNotEmpty) {
      //     _dayTextEditController.text = value.day.elementAt(0).dayReport;
      //     _nextTextEditController.text = value.day.elementAt(0).nextReport;
      //     _remarkTextEditController.text = value.day.elementAt(0).miscReport;
      //     dayReport = value.day.elementAt(0).dayReport;
      //     nextReport = value.day.elementAt(0).nextReport;
      //     remarkReport = value.day.elementAt(0).miscReport;
      //   } else {
      //     dayReport = "";
      //     nextReport = "";
      //     remarkReport = "";
      //   }
      // });
    });
  }

  bool isSaved = false;

  void doSave(String organizationCode, String userId) {
    isSaved = false;
    _dailyPageWrite.dayFocusNode.unfocus();
    _dailyPageWrite.nextFocusNode.unfocus();
    // remarkFocusNode.unfocus();
    // APIService apiService = new APIService();
    APIServiceNew apiServiceNew = new APIServiceNew();

    List<String> sParam;

    if (_dailyPageWrite.dayReport !=
        _dailyPageWrite.dayTextEditController.text) {
      sParam = [
        _dailyPageWrite.dayTextEditController.text,
        userId,
        organizationCode,
        date,
        userId
      ];

      if (_dailyPageWrite.dayReport == "") {
        //  INSERT
        if (_dailyPageWrite.nextReport == "") {
          //  익일 업무내용 정보가 DB에 없을 때
          apiServiceNew.getInsert("DAYREPORT_I1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              _dailyPageWrite.dayReport =
                  _dailyPageWrite.dayTextEditController.text;
            } else {}
          });
        } else {
          //  익일 업무내용 정보가 DB에 있을 때
          apiServiceNew.getUpdate("DAYREPORT_U1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              _dailyPageWrite.dayReport =
                  _dailyPageWrite.dayTextEditController.text;
            } else {}
          });
        }
      } else {
        if (_dailyPageWrite.dayTextEditController.text == "" &&
            _dailyPageWrite.nextTextEditController.text == "") {
          sParam = [organizationCode, date, userId];
          apiServiceNew.getDelete("DAYREPORT_D1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              _dailyPageWrite.dayReport =
                  _dailyPageWrite.dayTextEditController.text;
            } else {}
          });
        } else {
          apiServiceNew.getUpdate("DAYREPORT_U1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              _dailyPageWrite.dayReport =
                  _dailyPageWrite.dayTextEditController.text;
            } else {}
          });
        }
      }
      isSaved = true;
    }
    if (_dailyPageWrite.nextReport !=
        _dailyPageWrite.nextTextEditController.text) {
      sParam = [
        _dailyPageWrite.nextTextEditController.text,
        userId,
        organizationCode,
        date,
        userId
      ];
      if (_dailyPageWrite.nextReport == "") {
        //  INSERT
        if (_dailyPageWrite.dayReport == "" &&
            _dailyPageWrite.dayTextEditController.text == "") {
          //  일일 업무내용 정보가 DB에 없을 때
          apiServiceNew.getInsert("NEXTREPORT_I1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              _dailyPageWrite.nextReport =
                  _dailyPageWrite.nextTextEditController.text;
            } else {}
          });
        } else {
          //  일일 업무내용 정보가 DB에 있을 때
          apiServiceNew.getUpdate("NEXTREPORT_U1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              _dailyPageWrite.nextReport =
                  _dailyPageWrite.nextTextEditController.text;
            } else {}
          });
        }
      } else {
        //  일일 업무내용 정보가 DB에 있을 때
        apiServiceNew.getUpdate("NEXTREPORT_U1", sParam).then((value) {
          if (value.result.isNotEmpty) {
            _dailyPageWrite.nextReport =
                _dailyPageWrite.nextTextEditController.text;
          } else {}
        });
      }
      isSaved = true;
    }
  }

  saveButton(double sWindowWidth, double sWindowHeight, String organizationCode,
      String userId) {
    return Container(
      margin: EdgeInsets.only(
        left: sWindowWidth * 0.05,
        right: sWindowWidth * 0.05,
      ),
      width: sWindowWidth * 0.75,
      // alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 22),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5),
          ),
          primary: Colors.indigo[900],
        ),
        onPressed: () {
          doSave(organizationCode, userId);
          if (isSaved) {
            setState(() {
              _show("등록이 완료되었습니다.");
              isOpen = false;
              sIcon = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    '등록',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    minFontSize: 10,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 32,
                  ),
                ],
              );
              _report(date);
              _getDailySelect(date);
            });
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
  }

  void _getDailySelect(String startDate) async {
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
          itemCount = dailySelectValue.length;
        } else {
          itemCount = 0;
          // _show("조회된 데이터가 없습니다.");
        }
      });
    });
  }

  void _dailyLike(String sOrganizationCode, String sUserId, String date) {
    setState(() {
      List<String> sParam = [
        sOrganizationCode,
        member.user.userId,
        sUserId,
        date,
      ];

      apiServiceNew.getUpdate("DAILYLIKE_U1", sParam).then((value) {
        if (value.result.isNotEmpty) {
        } else {}
      });
    });
  }

  @override
  void initState() {
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;

    startDate = Date().date(null);
    endDate = Date().date(null);
    _selectedTime = nowDateTime;

    _dailyPageWrite.dayFocusNode = FocusNode();
    _dailyPageWrite.nextFocusNode = FocusNode();
    _dailyPageWrite.remarkFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    sIcon = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          '등록',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'NotoSansKR',
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          minFontSize: 10,
        ),
        Icon(
          Icons.keyboard_arrow_down_sharp,
          size: 32,
        ),
      ],
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      case 'CE팀':
        result = Colors.green[200];
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

  cardDecoration(int sLikeQty, int sReplyQty) {
    if (sLikeQty > 0 || sReplyQty > 0) {
      return BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey[300],
            width: 1,
          ),
        ),
      );
    } else {
      return BoxDecoration();
    }
  }

  cardLikeQty(int sLikeQty, int sReplyQty, String sLikePerson) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: cardDecoration(sLikeQty, sReplyQty),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (sLikeQty > 0) // 좋아요 1개 이상있을 시 문구가 나타남
            Expanded(
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.pink),
                      // Text('좋아요'),
                      // Icon(Icons.favorite, color: Colors.pink[400]),
                      SizedBox(width: 5),
                      Text(sLikeQty.toString() + '명'),
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ),
          if (sLikeQty == 0) Expanded(child: Container()),
          if (sReplyQty > 0) //  댓글 1개 이상있을 시 문구가 나타남
            Container(
              padding: EdgeInsets.only(right: 5),
              alignment: Alignment.centerRight,
              child: Text('댓글 ' + sReplyQty.toString() + '개'),
            ),
        ],
      ),
    );
  }

  cardLikeNReply(
      String sOrganizationCode,
      String sUserId,
      String sUserName,
      String sDeptName,
      String sDate,
      String sDailyReport,
      String sNextReport,
      int sLikeQty,
      String sLikeFlag,
      int sReplyQty,
      String sLikePerson) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: sLikeFlag == 'Y'
                          ? Icon(Icons.favorite, color: Colors.pink)
                          : Icon(Icons.favorite_border, color: Colors.grey),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        '좋아요',
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                _dailyLike(sOrganizationCode, sUserId, sDate);
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Icon(
                        Icons.message_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text('댓글 달기'),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return PopUpDailyReply(
                        member: member,
                        sOrganizationCode: sOrganizationCode,
                        sUserId: sUserId,
                        sUserName: sUserName,
                        sDeptName: sDeptName,
                        sDate: sDate,
                        sDailyReport: sDailyReport,
                        sNextReport: sNextReport,
                        sLikeQty: sLikeQty,
                        sLikeFlag: sLikeFlag,
                        sReplyQty: sReplyQty,
                        sLikePerson: sLikePerson);
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: Text(''),
            ),
          ),
        ],
      ),
    );
  }

  cardTable(
      String sOrganizationCode,
      String sUserId,
      String sUserName,
      String sDeptName,
      String sWorkDate,
      String sDailyReport,
      String sNextReport,
      String sMiscReport,
      int sLikeQty,
      String sLikeFlag,
      int sReplyQty,
      String sLikePerson) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.all(
        //   Radius.circular(10),
        // ),
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
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(10),
              //   topRight: Radius.circular(10),
              // ),
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
                cardContent(sNextReport),
                // Divider(
                //   color: Colors.grey,
                // ),
                cardLikeQty(sLikeQty, sReplyQty, sLikePerson),
                Divider(
                  color: Colors.grey,
                ),
                cardLikeNReply(
                    sOrganizationCode,
                    sUserId,
                    sUserName,
                    sDeptName,
                    sWorkDate,
                    sDailyReport,
                    sNextReport,
                    sLikeQty,
                    sLikeFlag,
                    sReplyQty,
                    sLikePerson),
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
            for (int i = 0; i < dailySelectValue.length; i++)
              cardTable(
                dailySelectValue.elementAt(i).organizationCode,
                dailySelectValue.elementAt(i).userId,
                dailySelectValue.elementAt(i).userName,
                dailySelectValue.elementAt(i).deptName,
                dailySelectValue.elementAt(i).workDate,
                dailySelectValue.elementAt(i).dayReport,
                dailySelectValue.elementAt(i).nextReport,
                dailySelectValue.elementAt(i).miscReport,
                dailySelectValue.elementAt(i).likeQty,
                dailySelectValue.elementAt(i).likeFlag,
                dailySelectValue.elementAt(i).replyQty,
                dailySelectValue.elementAt(i).likePerson,
              ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    _getDailySelect(Date().date(DateTime.now().add(Duration(days: sDay))));

    _dayDecrease() {
      isChanged = true;
      sDay--;
      changeDate = Date().getDate(sDay);
      // date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
      date = Date().date(DateTime.now().add(Duration(days: sDay)));
      _report(date);
      _getDailySelect(date);
    }

    _dayIncrease() {
      isChanged = true;
      sDay++;
      changeDate = Date().getDate(sDay);
      date = Date().date(DateTime.now().add(Duration(days: sDay)));
      _report(date);
      _getDailySelect(date);
    }

    final menuName = Container(
      color: Color.fromRGBO(248, 246, 255, 1),
      child: Center(
        child: AutoSizeText(
          '일일업무 관리',
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
                );
                selectedDate.then((dateTime) {
                  if (dateTime != null) {
                    isChanged = true;
                    _selectedTime = dateTime;
                    sDay = dateTime.difference(DateTime.now()).inDays;
                    date = Date().date(_selectedTime);
                    _report(date);
                    _getDailySelect(date);
                  } else {
                    dateTime = _selectedTime;
                  }
                  changeDate = Date().getDateString(_selectedTime);
                  date = Date().date(_selectedTime);
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
        ],
      ),
    );

    Widget selectHeader = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[200],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
            ),
            child: Row(
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
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          selectDate,
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            // padding: EdgeInsets.only(top: 3, bottom: 5),
            width: screenWidth - 40,
            child: InkWell(
              onTap: () {
                setState(() {
                  isOpen = !isOpen;
                  if (isOpen == true) {
                    sIcon = Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          '닫기',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                        ),
                        Icon(
                          Icons.keyboard_arrow_up_sharp,
                          size: 32,
                        ),
                      ],
                    );
                  } else {
                    sIcon = Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          '등록',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          size: 32,
                        ),
                      ],
                    );
                  }
                });
              },
              child: sIcon,
            ),
          ),
          Visibility(
            visible: isOpen,
            child: Column(
              children: [
                SizedBox(height: 5),
                _dailyPageWrite.writeReport("today", screenWidth, screenHeight),
                SizedBox(height: 15),
                _dailyPageWrite.writeReport("next", screenWidth, screenHeight),
                SizedBox(height: 10),
                saveButton(screenWidth, screenHeight,
                    member.user.organizationCode, member.user.userId),
                SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
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
      // appBar: menuName,
      bottomNavigationBar: KulsNavigationBottomBar(
        globalKey: _scaffoldKey,
        id: id,
        pass: pass,
        member: member,
        selectedIndex: 1,
      ),
      body: GestureDetector(
        onTap: () {
          _dailyPageWrite.dayFocusNode.unfocus();
          _dailyPageWrite.nextFocusNode.unfocus();
          _dailyPageWrite.remarkFocusNode.unfocus();
        },
        child: Container(
          color: Color.fromRGBO(248, 246, 255, 1),
          child: SingleChildScrollView(
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
