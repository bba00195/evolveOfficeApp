import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';

class WhereIsPage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;

  WhereIsPage({
    this.id,
    this.pass,
    this.member,
  });
  @override
  _WhereIsPage createState() => new _WhereIsPage();
}

class _WhereIsPage extends State<WhereIsPage> {
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

  Future<DailyResultModel> futureAlbum;
  final _areaTextEditController = TextEditingController();
  final _locateTextEditController = TextEditingController();
  GlobalKey<FormState> _areaFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _locateFormKey = GlobalKey<FormState>();

  FocusNode areaFocusNode;
  FocusNode locateFocusNode;
  String _selectedStart = "";
  String _selectedEnd = "";
  String sStartTime = '';
  String sEndTime = '';

  final _valueList = [
    'MYCAR',
    'MEMBER_CAR',
    'BUS',
    'TRAIN',
    'AIRPLANE',
    'COMPANY_CAR'
  ];
  var selectedValue = 'MYCAR';

  @override
  void dispose() {
    _areaTextEditController.dispose();
    _locateTextEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;

    date = Date().date(null);
    areaFocusNode = FocusNode();
    locateFocusNode = FocusNode();
    _selectedTime = nowDateTime;
    _selectedStart = "08:30";
    sStartTime = "0830";
    _selectedEnd = "18:00";
    sEndTime = "1800";
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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

    void _whereInsert(String sArea, String sDate, String sStart, String sEnd,
        String sLocate, String sCarType) async {
      areaFocusNode.unfocus();
      locateFocusNode.unfocus();
      if (sArea == '') {
        _show("지역을 입력해주세요.");
        return;
      }
      if (sDate == '') {
        _show("날짜를 선택해주세요.");
        return;
      }
      if (sStart == '') {
        _show("시작시간을 선택해주세요.");
        return;
      }
      if (sEnd == '') {
        _show("종료시간을 선택해주세요.");
        return;
      }
      if (sLocate == '') {
        _show("행선지를 입력해주세요.");
        return;
      }

      setState(() {
        APIService apiService = new APIService();
        apiService
            .whereIs(member.user.organizationCode, member.user.userId, sArea,
                sDate, sStart, sEnd, sLocate, sCarType)
            .then((value) {
          if (value.result.isNotEmpty) {
            if (value.result.elementAt(0).rsCode == "E") {
              if (value.result.elementAt(0).rsMsg.indexOf("중복") > 0) {
                _show("이미 등록된 내용입니다.");
                return;
              }
              _show(value.result.elementAt(0).rsMsg);
            }
          } else {
            _show("등록에 실패하였습니다.");
          }
        });
        _areaTextEditController.text = "";
        _locateTextEditController.text = "";
      });
    }

    final menuName = AppBar(
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      actions: [],
      backgroundColor: Color.fromRGBO(248, 246, 255, 1),
      centerTitle: true,
      title: Text(
        '행선지 등록',
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

    final area = Container(
      height: 50,
      margin: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            offset: const Offset(0.0, 3.0),
            color: Color.fromRGBO(0, 0, 0, 0.16),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.location_on_sharp,
              color: Colors.red,
              size: 32,
            ),
          ),
          Expanded(
            child: Form(
              key: _areaFormKey,
              child: TextField(
                controller: _areaTextEditController,
                focusNode: areaFocusNode,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '지역',
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NotoSansKR',
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final selectDate = Container(
      height: 50,
      margin: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            offset: const Offset(0.0, 3.0),
            color: Color.fromRGBO(0, 0, 0, 0.16),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.calendar_today_outlined,
              color: Colors.yellow[600],
              size: 32,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
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
                        data: ThemeData.light(),
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
                    });
                  });
                },
                child: Text(
                  isChanged ? changeDate : Date().getDate(0),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'NotoSansKR',
                    // fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final locate = Container(
      height: 50,
      margin: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            offset: const Offset(0.0, 3.0),
            color: Color.fromRGBO(0, 0, 0, 0.16),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.gps_fixed_sharp,
              color: Colors.blue[700],
              size: 32,
            ),
          ),
          Expanded(
            child: Form(
              key: _locateFormKey,
              child: TextField(
                controller: _locateTextEditController,
                focusNode: locateFocusNode,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '행선지',
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NotoSansKR',
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final startTime = Container(
      height: screenWidth * 0.35,
      width: screenWidth * 0.35,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            offset: const Offset(0.0, 3.0),
            color: Color.fromRGBO(0, 0, 0, 0.16),
          )
        ],
      ),
      child: Column(
        children: [
          Text("시작시간"),
          Expanded(
            child: TextButton(
              onPressed: () {
                Future<TimeOfDay> selectedTime = showTimePicker(
                  initialTime: TimeOfDay(hour: 8, minute: 30),
                  context: context,
                );
                selectedTime.then((timeOfDay) {
                  setState(() {
                    if (timeOfDay != null) {
                      _selectedStart = '${timeOfDay.hour}'.padLeft(2, '0') +
                          ':' +
                          '${timeOfDay.minute}'.padLeft(2, '0');
                      sStartTime = '${timeOfDay.hour}'.padLeft(2, '0') +
                          '${timeOfDay.minute}'.padLeft(2, '0');
                    }
                  });
                });
              },
              child: Text(
                _selectedStart,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final endTime = Container(
      height: screenWidth * 0.35,
      width: screenWidth * 0.35,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            offset: const Offset(0.0, 3.0),
            color: Color.fromRGBO(0, 0, 0, 0.16),
          )
        ],
      ),
      child: Column(
        children: [
          Text("종료시간"),
          Expanded(
            child: TextButton(
              onPressed: () {
                Future<TimeOfDay> selectedTime = showTimePicker(
                  initialTime: TimeOfDay(hour: 18, minute: 0),
                  context: context,
                );
                selectedTime.then((timeOfDay) {
                  setState(() {
                    if (timeOfDay != null) {
                      _selectedEnd = '${timeOfDay.hour}'.padLeft(2, '0') +
                          ':' +
                          '${timeOfDay.minute}'.padLeft(2, '0');
                      sEndTime = '${timeOfDay.hour}'.padLeft(2, '0') +
                          '${timeOfDay.minute}'.padLeft(2, '0');
                    }
                  });
                });
              },
              child: Text(
                _selectedEnd,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final selectTimeRow = Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          startTime,
          endTime,
        ],
      ),
    );

    String vehicle(String value) {
      String result = '';
      switch (value) {
        case 'MYCAR':
          result = "자기차량";
          break;
        case 'MEMBER_CAR':
          result = "동행인차량";
          break;
        case 'BUS':
          result = "버스";
          break;
        case 'TRAIN':
          result = "철도";
          break;
        case 'AIRPLANE':
          result = "항공";
          break;
        case 'COMPANY_CAR':
          result = "회사차량";
          break;
        default:
          break;
      }
      return result;
    }

    final carType = Container(
      height: 50,
      margin: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            offset: const Offset(0.0, 3.0),
            color: Color.fromRGBO(0, 0, 0, 0.16),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              // padding: EdgeInsets.only(
              //   left: 10,
              // ),
              child: Icon(
                Icons.directions_car_rounded,
                color: Colors.green,
                size: 32,
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                value: selectedValue,
                items: _valueList.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(vehicle(value)),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(
                right: 10,
              ),
            ),
          ),
        ],
      ),
    );

    final saveButton = Container(
      height: 50,
      padding: EdgeInsets.only(left: 35.0, right: 35.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10),
          ),
          primary: Color.fromRGBO(45, 43, 77, 1),
        ),
        onPressed: () {
          _whereInsert(_areaTextEditController.text, date, sStartTime, sEndTime,
              _locateTextEditController.text, selectedValue);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'SAVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontFamily: 'NotoSansKR',
              ),
            ),
            Icon(
              Icons.save_sharp,
              size: 26,
            )
          ],
        ),
      ),
    );

    // #region Body
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: menuName,
      bottomNavigationBar: KulsNavigationBottomBar(
        id: id,
        pass: pass,
        member: member,
        selectedIndex: 1,
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            alignment:
                AlignmentDirectional.topCenter, //alignment:new Alignment(x, y)
            children: [
              Container(
                color: Color.fromRGBO(248, 246, 255, 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: const Offset(0.0, 3.0),
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  // padding: EdgeInsets.only(
                  //   top: 70,
                  // ),
                  child: ListView(
                    children: [
                      SizedBox(height: 70),
                      area,
                      SizedBox(height: 20),
                      selectDate,
                      SizedBox(height: 30),
                      selectTimeRow,
                      SizedBox(height: 30),
                      locate,
                      SizedBox(height: 30),
                      carType,
                      SizedBox(height: 30),
                      saveButton,
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              Container(
                // margin: EdgeInsets.only(
                //   top: 40,
                // ),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: const Offset(0.0, 3.0),
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.directions_car_sharp,
                    size: 40,
                    color: Color.fromRGBO(121, 102, 254, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          areaFocusNode.unfocus();
          locateFocusNode.unfocus();
        },
      ),
    );
  }
}
