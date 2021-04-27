import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/whereis_model.dart';
import 'package:evolveofficeapp/pages/whereis_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

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

  bool isFocused = true;
  List<WhereResponseModel> whereIsValue;
  List<bool> chkBox = [];

  int itemCount = 0;

  void _getWhereIs(String selectedDate) async {
    APIService apiService = new APIService();
    apiService
        .whereIsManage(
            member.user.organizationCode, member.user.userId, selectedDate)
        .then((value) {
      setState(() {
        if (value.whereIs.isNotEmpty) {
          if (isFocused == true) {
            whereIsValue = value.whereIs;
            itemCount = 0;
            for (var i = 0; i < value.whereIs.length; i++) {
              itemCount++;
              // chkBox[i] = false;
              //   List<DataCell> cells = [];
              //   List<DataCell> userNameCells = [];
              //   userNameCells
              //       .add(DataCell(Text(value.whereIs.elementAt(i).userName)));
              //   cells.add(DataCell(Text(value.whereIs.elementAt(i).startTime)));
              //   cells.add(DataCell(Text(value.whereIs.elementAt(i).endTime)));
              //   cells.add(DataCell(Text(value.whereIs.elementAt(i).area)));
              //   cells.add(
              //       DataCell(Text(value.whereIs.elementAt(i).whereIsContents)));
              //   cells.add(
              //       DataCell(Text(vehicle(value.whereIs.elementAt(i).carType))));
            }
            isFocused = false;
          }
        } else {}
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isFocused = true;
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;
    date = Date().date(null);
    _selectedTime = nowDateTime;

    _getWhereIs(
      date,
    );
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

    _dayDecrease() {
      isChanged = true;
      isFocused = true;
      sDay--;
      changeDate = Date().getDate(sDay);
      date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
      _getWhereIs(date);
    }

    _dayIncrease() {
      isChanged = true;
      isFocused = true;
      sDay++;
      changeDate = Date().getDate(sDay);
      date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
      _getWhereIs(date);
    }

    final menuName = Container(
      color: Color.fromRGBO(244, 242, 255, 1),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Center(
        child: Text(
          '행선지 관리',
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
      color: Color.fromRGBO(244, 242, 255, 1),
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
                    isChanged = true;
                    isFocused = true;
                    _selectedTime = dateTime;
                    sDay = dateTime.difference(DateTime.now()).inDays;
                    changeDate = Date().getDateString(_selectedTime);
                    date = Date().date(_selectedTime);
                    _getWhereIs(
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

    Widget dataTableHeader(String sColumn) {
      return Container(
        child: Text(
          sColumn,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        width: 100,
        height: 50,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    }

    Widget _generateFirstColumnRow(BuildContext context, int index) {
      return Container(
        child: Text(whereIsValue.elementAt(index).userName),
        width: 100,
        height: 50,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    }

    Widget rightColumnRowContent(String sText, Alignment sAlign) {
      return Container(
        child: Text(sText),
        width: 100,
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
                Alignment.center),
            rightColumnRowContent(
                whereIsValue.elementAt(index).endTime == ''
                    ? ''
                    : whereIsValue.elementAt(index).endTime.substring(0, 2) +
                        ":" +
                        whereIsValue.elementAt(index).endTime.substring(2, 4),
                Alignment.center),
            // rightColumnRowContent(
            //     whereIsValue.elementAt(index).area, Alignment.centerLeft),
            rightColumnRowContent(whereIsValue.elementAt(index).whereIsContents,
                Alignment.center),
            rightColumnRowContent(
                whereIsValue.elementAt(index).carType, Alignment.center),
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
            // child: Text(
            //   '확인',
            //   textAlign: TextAlign.left,
            //   style: TextStyle(
            //     color: Color.fromRGBO(86, 98, 112, 1),
            //     fontWeight: FontWeight.w700,
            //     fontSize: 16,
            //   ),
            // ),
          ),
          Container(
            color: Colors.white,
            height: screenHeight * 0.6,
            margin: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 100,
              rightHandSideColumnWidth: 400,
              isFixedHeader: true,
              headerWidgets: [
                dataTableHeader('이름'),
                dataTableHeader('시작시간'),
                dataTableHeader('종료시간'),
                // dataTableHeader('지역'),
                dataTableHeader('행선지'),
                dataTableHeader('교통편'),
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

  _showMessage(String sMessage, String sStartTime, String sEndTime,
      String sArea, String sWhereIsContents, String sCarType) {
    showDialog(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            height: 200,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    'Evolve Office',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(),
                  child: Text(
                    sMessage,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SizedBox(),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      margin: EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6.0,
                            offset: const Offset(1.0, 3.0),
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                          )
                        ],
                      ),
                      height: 40,
                      child: TextButton(
                        child: Text(
                          "삭제",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          _whereDelete(date, sStartTime, sEndTime);
                          Navigator.of(context).pop(true);
                          setState(() {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
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
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      margin: EdgeInsets.only(
                        left: 5,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6.0,
                            offset: const Offset(1.0, 3.0),
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                          )
                        ],
                      ),
                      height: 40,
                      child: TextButton(
                          child: Text(
                            "수정",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
