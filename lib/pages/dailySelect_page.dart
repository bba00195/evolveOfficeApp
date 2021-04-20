import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter/services.dart';

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

  Future<DailyResultModel> futureAlbum;

  final _organizationList = [
    'CW',
    'SU',
    'SW',
    'CS',
  ];
  var organizationValue = 'CW';

  final _deptList = [
    'CW',
    'SU',
    'SW',
    'CS',
  ];
  var deptValue = 'CW';

  void _report(String selectedDate) async {
    setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    _report(
      date,
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
        '일일업무보고 조회',
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

    Widget selectHeader = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 120,
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text('사업부'),
              ),
              Expanded(
                flex: 3,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: organizationValue,
                    items: _organizationList.map(
                      (value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(organization(value)),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        organizationValue = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('부서명'),
              ),
              Expanded(
                flex: 3,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: deptValue,
                    items: _deptList.map(
                      (value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(department(value)),
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
            ],
          ),
          Row(),
        ],
      ),
    );

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
                    selectHeader,
                    SizedBox(height: 100),
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
      case '':
        result = "쿨스종합건설";
        break;
      default:
        break;
    }
    return result;
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
