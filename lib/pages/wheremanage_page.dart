import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolveofficeapp/api/api_service_new.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/whereis_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import 'package:intl/intl.dart';

//행선지 관리 수정 삭제

class WhereManagePage extends StatefulWidget {
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
  final String attribute;

  WhereManagePage({
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
    this.attribute,
  });
  @override
  _WhereManagePage createState() => new _WhereManagePage();
}

class _WhereManagePage extends State<WhereManagePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final storage = FlutterSecureStorage();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수

  void _showPicker(BuildContext ctx, bool startType) {
    DateTime selectTime =
        DateTime.now().add(Duration(minutes: 0 - DateTime.now().minute % 10));
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: Text(
                    '닫기',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoButton(
                  child: Text('등록'),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      if (startType == true) {
                        // 시작시간일 경우
                        _selectedStart = '${selectTime.hour}'.padLeft(2, '0') +
                            ':' +
                            '${selectTime.minute}'.padLeft(2, '0');
                        sStartTime = '${selectTime.hour}'.padLeft(2, '0') +
                            '${selectTime.minute}'.padLeft(2, '0');
                      } else {
                        _selectedEnd = '${selectTime.hour}'.padLeft(2, '0') +
                            ':' +
                            '${selectTime.minute}'.padLeft(2, '0');
                        sEndTime = '${selectTime.hour}'.padLeft(2, '0') +
                            '${selectTime.minute}'.padLeft(2, '0');
                      }
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                minuteInterval: 10,
                initialDateTime: (startType == true)
                    ? DateTime.parse(date + " " + _selectedStart)
                    : (_selectedEnd == "")
                        ? DateTime.parse(date + " 18:00")
                        : DateTime.parse(date + " " + _selectedEnd),
                onDateTimeChanged: (valueTime) {
                  setState(() {
                    selectTime = valueTime;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String id;
  String pass;
  UserManager member;
  String changeDate;
  DateTime changeDateTime;

  bool isOpen = false;
  Widget sIcon;
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
  DateTime selectedStartTime;
  String startDate;
  String sStartTime = '';
  String sStartTimeOrg = '';
  String sEndTime = '';
  String sEndTimeOrg = '';
  final _locateTextEditController = TextEditingController();
  final _attributeTextEditController = TextEditingController();
  GlobalKey<FormState> _locateFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _attributeFormKey = GlobalKey<FormState>();
  FocusNode locateFocusNode;
  FocusNode attributeFocusNode;
  bool isUpdate = false;
  DateTime updateDate;
  String area;
  String contents;
  String carType;

  List<String> carTypeCodeList = [];
  List<String> carTypeNameList = [];
  var carTypeValue = 'MYCAR';

  List<String> deptCodeList = [];
  List<String> deptNameList = [];
  var deptValue = '';

  String _selectedStart = "";
  String _selectedEnd = "";

  bool isDay;
  bool isMorning;
  bool isAfter;

  void _getWhereIs(String selectedDate, {String sOrganizationcode = ""}) {
    List<String> sParam = [
      selectedDate,
      member.user.organizationCode,
      sOrganizationcode,
      deptValue,
    ];

    APIServiceNew apiServiceNew = new APIServiceNew();
    apiServiceNew.getSelect("WHEREIS_S1", sParam).then((value) {
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

  void whereIsInit() {
    _getWhereIs(date);
    isUpdate = false;
    isOpen = false;
    isDay = false;
    isMorning = false;
    isAfter = false;
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
    latitude = "";
    longitude = "";
    sEndTime = "";
    _selectedEnd = "";
    _locateTextEditController.text = "";
    _attributeTextEditController.text = "";
  }

  void whereInsert(
      String sDate,
      String sStart,
      String sEnd,
      String sLocate,
      String sCarType,
      bool isUpdate,
      String latitude,
      String longitude,
      String attribute) {
    locateFocusNode.unfocus();
    attributeFocusNode.unfocus();
    if (sDate == '') {
      _show("날짜를 선택해주세요.");
      return;
    }
    if (sStart == '') {
      _show("시작시간을 선택해주세요.");
      return;
    }
    if (sLocate == '') {
      _show("행선지를 입력해주세요.");
      return;
    }

    APIServiceNew apiServiceNew = new APIServiceNew();

    List<String> sParam = [
      member.user.organizationCode,
      sDate,
      member.user.userId,
      sStart,
      sEnd,
      sLocate,
      sCarType,
      member.user.userId,
      latitude,
      longitude,
      attribute
    ];
    apiServiceNew.getInsert("WHEREIS_I2", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          if (value.result.elementAt(0).rsCode == "E") {
            if (value.result.elementAt(0).rsMsg.indexOf("중복") > 0) {
              _show("이미 등록된 내용입니다.");
              return;
            }
            _show(value.result.elementAt(0).rsMsg);
          } else {
            _show("행선지 등록이 완료되었습니다.");
          }
        } else {
          _show("등록에 실패하였습니다.");
        }
        whereIsInit();
      });
    });
  }

  void whereUpdate(
      String sDate,
      String sStart,
      String sEnd,
      String sLocate,
      String sCarType,
      bool isUpdate,
      String latitude,
      String longitude,
      String attribute) {
    locateFocusNode.unfocus();
    attributeFocusNode.unfocus();
    if (sDate == '') {
      _show("날짜를 선택해주세요.");
      return;
    }
    if (sStart == '') {
      _show("시작시간을 선택해주세요.");
      return;
    }
    if (sLocate == '') {
      _show("행선지를 입력해주세요.");
      return;
    }

    APIServiceNew apiServiceNew = new APIServiceNew();

    List<String> sParam = [
      sStart,
      sEnd,
      sCarType,
      sLocate,
      sDate,
      latitude,
      longitude,
      attribute,
      member.user.organizationCode,
      sDate,
      member.user.userId,
      sStartTimeOrg,
      sEndTimeOrg,
    ];
    apiServiceNew.getUpdate("WHEREIS_U2", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          if (value.result.elementAt(0).rsCode == "E") {
            if (value.result.elementAt(0).rsMsg.indexOf("중복") > 0) {
              _show("이미 등록된 내용입니다.");
              return;
            }
            _show(value.result.elementAt(0).rsMsg);
          } else {
            _show("행선지 등록이 완료되었습니다.");
          }
        } else {
          _show("등록에 실패하였습니다.");
        }
        whereIsInit();
      });
    });
  }

  void carTypeList() {
    List<String> sParam = ['CW'];

    APIServiceNew apiServiceNew = new APIServiceNew();
    apiServiceNew.getSelect("CARTYPE_S1", sParam).then((value) {
      setState(() {
        if (value.carType.isNotEmpty) {
          carTypeCodeList.add('');
          carTypeNameList.add('');
          for (int i = 0; i < value.carType.length; i++) {
            carTypeCodeList.add(value.carType.elementAt(i).codeName);
            carTypeNameList.add(value.carType.elementAt(i).codeValue);
          }
        } else {
          _show("조회된 데이터가 없습니다.");
        }
      });
    });
  }

  void deptList() {
    List<String> sParam = [];

    APIServiceNew apiServiceNew = new APIServiceNew();
    apiServiceNew.getSelect("DEPT_S1", sParam).then((value) {
      setState(() {
        if (value.dept.isNotEmpty) {
          deptCodeList.add('');
          deptNameList.add('ALL');
          for (int i = 0; i < value.dept.length; i++) {
            deptCodeList.add(value.dept.elementAt(i).deptCode);
            deptNameList.add(value.dept.elementAt(i).deptName);
          }
        } else {
          _show("조회된 데이터가 없습니다.");
        }
      });
    });
  }

  vehicle(String value) {
    for (int i = 0; i < carTypeNameList.length; i++) {
      if (carTypeCodeList[i] == value) {
        return carTypeNameList[i];
      }
    }
  }

  department(String value) {
    for (int i = 0; i < deptNameList.length; i++) {
      if (deptCodeList[i] == value) {
        return deptNameList[i];
      }
    }
  }

  String latitude = "";
  String longitude = "";

  Future<void> getPosition() async {
    var currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = currentPosition.latitude.toString();
    longitude = currentPosition.longitude.toString();
  }

  @override
  void dispose() {
    _locateTextEditController.dispose();
    _attributeTextEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getPosition();
    carTypeList();
    deptList();
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;
    date = Date().date(null);
    _selectedTime = nowDateTime;
    startDate = Date().date(null);
    selectedStartTime = nowDateTime;
    deptValue = member.user.deptCode;

    isDay = false;
    isMorning = false;
    isAfter = false;

    _getWhereIs(date, sOrganizationcode: member.user.organizationCode);

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

    if (isUpdate) {
      _selectedTime = widget.updateDate;
      date = Date().date(_selectedTime);
      changeDate = Date().getDateString(_selectedTime);
      sStartTime = widget.startTime;
      sStartTimeOrg = widget.startTime;
      sEndTime = widget.endTime;
      sEndTimeOrg = widget.endTime;
      _selectedStart =
          sStartTime.substring(0, 2) + ":" + sStartTime.substring(2, 4);
      _selectedEnd = sEndTime.substring(0, 2) + ":" + sEndTime.substring(2, 4);
      // _areaTextEditController.text = widget.area;
      _locateTextEditController.text = widget.contents;
      _attributeTextEditController.text = widget.attribute;
      carType = widget.carType;
    } else {
      date = Date().date(null);
      _selectedTime = nowDateTime;
      sStartTime = DateFormat('HHmm').format(DateTime.now()
          .add(Duration(minutes: 0 - DateTime.now().minute % 10)));
      sEndTime = "";
      _selectedStart = DateFormat('HH:mm').format(DateTime.now()
          .add(Duration(minutes: 0 - DateTime.now().minute % 10)));
      _selectedEnd = "";
    }
    locateFocusNode = FocusNode();
    attributeFocusNode = FocusNode();

    super.initState();
  }

  void _whereDelete(String sDate, String sStart, String sEnd) {
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
            _getWhereIs(date);
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

    _dayDecrease() {
      isChanged = true;
      sDay--;
      changeDate = Date().getDate(sDay);
      // date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
      date = Date().date(DateTime.now().add(Duration(days: sDay)));
      _getWhereIs(date);
    }

    _dayIncrease() {
      isChanged = true;
      sDay++;
      changeDate = Date().getDate(sDay);
      date = Date().date(DateTime.now().add(Duration(days: sDay)));
      _getWhereIs(date);
    }

    final menuName = Container(
      color: Color.fromRGBO(244, 242, 255, 1),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Center(
        child: AutoSizeText(
          '너 어디니',
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
                      _getWhereIs(date);
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
              // mainAxisAlignment: MainAxisAlignment.start,
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
                  flex: 6,
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
                        items: deptCodeList.map(
                          (value) {
                            return DropdownMenuItem(
                              value: value,
                              child: AutoSizeText(
                                department(value),
                                style: TextStyle(
                                  fontSize: 14,
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
                            _getWhereIs(date);
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
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: AutoSizeText(
                            '시작시간',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey[600],
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            minFontSize: 10,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              elevation: MaterialStateProperty.all(
                                  6), //Defines Elevation
                              shadowColor: MaterialStateProperty.all(
                                Color.fromRGBO(0, 0, 0, 0.6),
                              ),
                            ),
                            onPressed: () {
                              _showPicker(context, true);
                            },
                            child: AutoSizeText(
                              _selectedStart,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              maxLines: 1,
                              minFontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: AutoSizeText(
                            '종료시간',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey[600],
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            minFontSize: 10,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              elevation: MaterialStateProperty.all(
                                  6), //Defines Elevation
                              shadowColor: MaterialStateProperty.all(
                                Color.fromRGBO(0, 0, 0, 0.6),
                              ),
                            ),
                            onPressed: () {
                              _showPicker(context, false);
                            },
                            child: AutoSizeText(
                              _selectedEnd,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              maxLines: 1,
                              minFontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
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
                              value: carTypeValue,
                              items: carTypeCodeList.map(
                                (value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: AutoSizeText(
                                      vehicle(value),
                                      style: TextStyle(
                                        fontSize: 14,
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
                                  carTypeValue = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          padding: EdgeInsets.only(left: 10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6.0,
                                offset: const Offset(0.0, 3.0),
                                color: Color.fromRGBO(0, 0, 0, 0.16),
                              )
                            ],
                          ),
                          child: Form(
                            key: _locateFormKey,
                            child: TextField(
                              controller: _locateTextEditController,
                              focusNode: locateFocusNode,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 5),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '행선지',
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    padding: EdgeInsets.only(left: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.0,
                          offset: const Offset(0.0, 3.0),
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                        )
                      ],
                    ),
                    child: Form(
                      key: _attributeFormKey,
                      child: TextField(
                        controller: _attributeTextEditController,
                        focusNode: attributeFocusNode,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '목적',
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Checkbox(
                          value: isDay,
                          onChanged: (value) {
                            setState(() {
                              isUpdate = false;
                              isDay = true;
                              isMorning = false;
                              isAfter = false;
                              _selectedStart = '08:30';
                              sStartTime = '0830';
                              _selectedEnd = '18:00';
                              sEndTime = '1800';
                              _locateTextEditController.text = "사무실";
                              _attributeTextEditController.text = "내근";
                            });
                          }),
                      AutoSizeText(
                        "종일 내근",
                        style: TextStyle(fontSize: 12),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                      Checkbox(
                          value: isMorning,
                          onChanged: (value) {
                            setState(() {
                              isUpdate = false;
                              isDay = false;
                              isMorning = true;
                              isAfter = false;
                              _selectedStart = '08:30';
                              sStartTime = '0830';
                              _selectedEnd = '13:00';
                              sEndTime = '1300';
                              _locateTextEditController.text = "사무실";
                              _attributeTextEditController.text = "내근";
                            });
                          }),
                      AutoSizeText(
                        "오전 내근",
                        style: TextStyle(fontSize: 12),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                      Checkbox(
                          value: isAfter,
                          onChanged: (value) {
                            setState(() {
                              isUpdate = false;
                              isDay = false;
                              isMorning = false;
                              isAfter = true;
                              _selectedStart = '13:00';
                              sStartTime = '1300';
                              _selectedEnd = '18:00';
                              sEndTime = '1800';
                              _locateTextEditController.text = "사무실";
                              _attributeTextEditController.text = "내근";
                            });
                          }),
                      AutoSizeText(
                        "오후 내근",
                        style: TextStyle(fontSize: 12),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ],
                  ),
                  Container(
                    width: screenWidth * 0.75,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 22),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5),
                        ),
                        primary: Colors.indigo[900],
                      ),
                      child: Text(
                        '등록',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        if (isUpdate) {
                          whereUpdate(
                              date,
                              sStartTime,
                              sEndTime,
                              _locateTextEditController.text,
                              carTypeValue,
                              isUpdate,
                              latitude,
                              longitude,
                              _attributeTextEditController.text);
                        } else {
                          whereInsert(
                              date,
                              sStartTime,
                              sEndTime,
                              _locateTextEditController.text,
                              carTypeValue,
                              isUpdate,
                              latitude,
                              longitude,
                              _attributeTextEditController.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
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
        child: AutoSizeText(
          sColumn,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          minFontSize: 10,
          maxLines: 1,
        ),
        width: sWidth,
        height: 50,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    }

    Widget _generateFirstColumnRow(BuildContext context, int index) {
      return Container(
        child: AutoSizeText(
          whereIsValue.elementAt(index).userName,
          style: TextStyle(
            fontSize: 14,
          ),
          minFontSize: 10,
          maxLines: 1,
        ),
        width: tableWidth,
        height: 50,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    }

    Widget rightColumnRowContent(
        String sText, Alignment sAlign, double sWidth) {
      return Container(
        child: AutoSizeText(
          sText,
          style: TextStyle(
            fontSize: 14,
          ),
          minFontSize: 8,
          maxLines: 2,
        ),
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
            rightColumnRowContent(whereIsValue.elementAt(index).whereIsContents,
                Alignment.center, tableWidth),
            rightColumnRowContent(
                vehicle(whereIsValue.elementAt(index).carType),
                Alignment.center,
                tableWidth),
          ],
        ),
      );
    }

    whereIsDataTable() {
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
                  color: Color.fromRGBO(74, 63, 186, 1),
                  width: 3,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: screenHeight * 0.5,
            constraints: BoxConstraints(
              minHeight: 100,
            ),
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
        pageName: "",
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: () {
          _getWhereIs(date, sOrganizationcode: member.user.organizationCode);
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
        },
        child: GestureDetector(
          child: Container(
            color: Color.fromRGBO(244, 242, 255, 1),
            child: SingleChildScrollView(
              child: Column(
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
          ),
          onTap: () {
            locateFocusNode.unfocus();
            attributeFocusNode.unfocus();
          },
        ),
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

  _showMessage(String _message, String _startTime, String _endTime,
      String _area, String _whereIsContents, String _carType) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(_message),
          actions: [
            TextButton(
              child: Text("삭제"),
              onPressed: () {
                _whereDelete(date, _startTime, _endTime);
                Navigator.of(context).pop(true);
                _getWhereIs(date);
              },
            ),
            TextButton(
              child: Text("수정"),
              onPressed: () {
                setState(() {
                  isOpen = true;
                  isUpdate = true;
                  _selectedStart = _startTime.substring(0, 2) +
                      ":" +
                      _startTime.substring(2, 4);
                  sStartTime = _startTime;
                  sStartTimeOrg = _startTime;
                  if (_endTime != '') {
                    _selectedEnd = _endTime.substring(0, 2) +
                        ":" +
                        _endTime.substring(2, 4);
                  }
                  sEndTime = _endTime;
                  sEndTimeOrg = _endTime;
                  _locateTextEditController.text = _whereIsContents;
                  carTypeValue = _carType;
                });
                Navigator.of(context).pop(true);
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
