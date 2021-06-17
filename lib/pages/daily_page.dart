import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:evolveofficeapp/api/api_service_new.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';
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
  DailyPageWrite createState() => new DailyPageWrite();
}

class DailyPageWrite extends State<DailyPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  static final storage = FlutterSecureStorage();
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수

  double windowHeight;
  double windowWidth;

  String id;
  String pass;
  UserManager member;
  String changeDate;
  DateTime changeDateTime;

  bool isChanged = false;
  int sDay = 0;
  DateTime nowDateTime = DateTime.now();
  DateTime selectedTime;
  String date;

  String dayReport = '';
  String nextReport;
  String remarkReport = '';

  String dayPrefix = "";
  String nextPrefix = "";

  Future<DailyResultModel> futureAlbum;
  final dayTextEditController = TextEditingController();
  final nextTextEditController = TextEditingController();
  final remarkTextEditController = TextEditingController();
  GlobalKey<FormState> dayFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> nextFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> remarkFormKey = GlobalKey<FormState>();

  FocusNode dayFocusNode;
  FocusNode nextFocusNode;
  FocusNode remarkFocusNode;

  bool isFocused = false;
  bool isSaved = false;

  void report(String selectedDate) async {
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
          dayTextEditController.text = value.day.elementAt(0).dayReport;
          nextTextEditController.text = value.day.elementAt(0).nextReport;
          remarkTextEditController.text = value.day.elementAt(0).miscReport;
          dayReport = value.day.elementAt(0).dayReport;
          nextReport = value.day.elementAt(0).nextReport;
          remarkReport = value.day.elementAt(0).miscReport;
        } else {
          dayReport = "";
          nextReport = "";
          remarkReport = "";
        }
      });

      // APIService apiService = new APIService();
      // apiService
      //     .report(
      //         member.user.organizationCode, member.user.userId, selectedDate)
      //     .then((value) {
      //   if (value.day.isNotEmpty) {
      //     dayTextEditController.text = value.day.elementAt(0).dayReport;
      //     nextTextEditController.text = value.day.elementAt(0).nextReport;
      //     remarkTextEditController.text = value.day.elementAt(0).miscReport;
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

  @override
  void dispose() {
    dayTextEditController.dispose();
    nextTextEditController.dispose();
    remarkTextEditController.dispose();
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

    dayFocusNode.addListener(onFocusChange);
    nextFocusNode.addListener(onFocusChange);
    remarkFocusNode.addListener(onFocusChange);
    selectedTime = nowDateTime;

    report(
      date,
    );
  }

  void onFocusChange() {
    isFocused = true;
    if (dayFocusNode.hasFocus) {
      nextFocusChange(context, nextFocusNode);
      if (dayReport != "" || nextReport != "") {
        remarkFocusChange(context, remarkFocusNode);
      }
    }
    if (nextFocusNode.hasFocus) {
      dayFocusChange(context, dayFocusNode);
      if (dayReport != "" || nextReport != "") {
        remarkFocusChange(context, remarkFocusNode);
      }
    }
    if (remarkFocusNode.hasFocus) {
      dayFocusChange(context, dayFocusNode);
      nextFocusChange(context, nextFocusNode);
      if (dayTextEditController.text == "" &&
          nextTextEditController.text == "") {
        show("업무 내용 먼저 작성해주세요.");
        remarkFocusNode.unfocus();
      }
    }
  }

  dayDecrease() {
    dayFocusChange(dayFormKey.currentContext, dayFocusNode);
    nextFocusChange(nextFormKey.currentContext, nextFocusNode);
    remarkFocusChange(remarkFormKey.currentContext, remarkFocusNode);
    dayTextEditController.text = "";
    nextTextEditController.text = "";
    remarkTextEditController.text = "";
    isChanged = true;
    sDay--;
    changeDate = Date().getDate(sDay);
    // date = Date().date(DateTime.now().add(Duration(hours: 9, days: sDay)));
    date = Date().date(DateTime.now().add(Duration(days: sDay)));
    report(date);
  }

  dayIncrease() {
    dayFocusChange(dayFormKey.currentContext, dayFocusNode);
    nextFocusChange(nextFormKey.currentContext, nextFocusNode);
    remarkFocusChange(remarkFormKey.currentContext, remarkFocusNode);
    dayTextEditController.text = "";
    nextTextEditController.text = "";
    remarkTextEditController.text = "";
    isChanged = true;
    isFocused = false;
    sDay++;
    changeDate = Date().getDate(sDay);
    date = Date().date(DateTime.now().add(Duration(days: sDay)));
    report(date);
  }

  selectDate(double sWindowWidth, double sWindowHeight) {
    return Container(
      color: Color.fromRGBO(248, 246, 255, 1),
      // margin: EdgeInsets.only(
      //   right: screenWidth * 0.05,
      // ),
      padding: EdgeInsets.only(
        left: sWindowWidth * 0.05,
      ),
      height: 60,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {
                dayDecrease();
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
                  initialDate: selectedTime, // 초깃값
                  firstDate: DateTime(2018), // 시작일
                  lastDate: DateTime(2030), // 마지막일
                );
                selectedDate.then((dateTime) {
                  setState(() {
                    dayFocusChange(dayFormKey.currentContext, dayFocusNode);
                    nextFocusChange(nextFormKey.currentContext, nextFocusNode);
                    remarkFocusChange(
                        remarkFormKey.currentContext, remarkFocusNode);
                    dayTextEditController.text = "";
                    nextTextEditController.text = "";
                    remarkTextEditController.text = "";
                    if (dateTime != null) {
                      isFocused = false;
                      isChanged = true;
                      selectedTime = dateTime;
                      sDay = dateTime.difference(DateTime.now()).inDays;
                      report(date);
                    } else {
                      dateTime = selectedTime;
                    }
                    changeDate = Date().getDateString(selectedTime);
                    date = Date().date(selectedTime);
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
                      dayIncrease();
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
  }

  dayForm() {
    return Form(
      key: dayFormKey,
      child: AutoSizeTextField(
        autofocus: false,
        controller: dayTextEditController,
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
        minFontSize: 10,
        // textInputAction: TextInputAction.next,
        // onFieldSubmitted: (value) {
        //   dayFocusChange(dayFormKey.currentContext, dayFocusNode);
        // },
      ),
    );
  }

  nextForm() {
    return Form(
      key: nextFormKey,
      child: AutoSizeTextField(
        autofocus: false,
        controller: nextTextEditController,
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
        minFontSize: 10,
        // textInputAction: TextInputAction.next,
        // onFieldSubmitted: (value) {
        //   nextFocusChange(nextFormKey.currentContext, nextFocusNode);
        // },
      ),
    );
  }

  writeReport(String sType, double sWindowWidth, double sWindowHeight) {
    return Column(
      // alignment:
      //     AlignmentDirectional.topStart, //alignment:new Alignment(x, y)
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30,
          width: sWindowWidth * 0.9,
          margin: EdgeInsets.only(
            left: sWindowWidth * 0.05,
            right: sWindowWidth * 0.05,
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
          height: sWindowHeight * 0.15,
          margin: EdgeInsets.only(
            top: 14,
            left: sWindowWidth * 0.05,
            right: sWindowWidth * 0.05,
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
                  child: (sType == "today") ? dayForm() : nextForm(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
            show("등록이 완료되었습니다.");
          } else {
            show("내용을 입력하거나 수정해주세요.");
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    windowHeight = screenHeight;
    windowWidth = screenWidth;

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

    // Widget remarkForm = Form(
    //   key: remarkFormKey,
    //   child: TextFormField(
    //     autofocus: false,
    //     controller: remarkTextEditController,
    //     focusNode: remarkFocusNode,
    //     maxLines: 999,
    //     decoration: InputDecoration(
    //       border: InputBorder.none,
    //       focusedBorder: InputBorder.none,
    //       enabledBorder: InputBorder.none,
    //       errorBorder: InputBorder.none,
    //       disabledBorder: InputBorder.none,
    //     ),
    //     style: TextStyle(
    //       fontSize: 14,
    //       fontFamily: 'NotoSansKR',
    //     ),
    //     // textInputAction: TextInputAction.next,
    //     // onFieldSubmitted: (value) {
    //     //   dayFocusChange(dayFormKey.currentContext, dayFocusNode);
    //     // },
    //   ),
    // );

    // remark() {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Container(
    //         height: 30,
    //         width: screenWidth * 0.9,
    //         margin: EdgeInsets.only(
    //           left: screenWidth * 0.05,
    //           right: screenWidth * 0.05,
    //         ),
    //         decoration: BoxDecoration(
    //           border: Border(
    //             bottom: BorderSide(
    //               color: Color.fromRGBO(45, 43, 77, 1),
    //               width: 3,
    //             ),
    //           ),
    //         ),
    //         child: Text(
    //           '특이사항',
    //           textAlign: TextAlign.left,
    //           style: TextStyle(
    //             color: Color.fromRGBO(86, 98, 112, 1),
    //             fontWeight: FontWeight.w700,
    //             fontSize: 16,
    //           ),
    //         ),
    //       ),
    //       Container(
    //         height: screenHeight * 0.14,
    //         margin: EdgeInsets.only(
    //           top: 14,
    //           left: screenWidth * 0.05,
    //           right: screenWidth * 0.05,
    //         ),
    //         padding: EdgeInsets.only(left: 10),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(5),
    //           boxShadow: [
    //             BoxShadow(
    //               blurRadius: 6.0,
    //               offset: const Offset(0.0, 3.0),
    //               color: Color.fromRGBO(0, 0, 0, 0.16),
    //             )
    //           ],
    //           color: Color.fromRGBO(248, 246, 255, 1),
    //         ),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Expanded(
    //               flex: 14,
    //               child: Container(
    //                 alignment: Alignment.topLeft,
    //                 child: remarkForm,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
    // }

    // #region Body
    return Scaffold(
      key: scaffoldKey,
      appBar: KulsAppBar(
        globalKey: scaffoldKey,
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
        globalKey: scaffoldKey,
        id: id,
        pass: pass,
        member: member,
        selectedIndex: 1,
        pageName: "",
      ),
      body: GestureDetector(
        child: Container(
          color: Color.fromRGBO(248, 246, 255, 1),
          child: ListView(
            children: [
              SizedBox(height: 10),
              menuName,
              selectDate(screenWidth, screenHeight),
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
                    writeReport("today", screenWidth, screenHeight),
                    SizedBox(height: 30),
                    writeReport("next", screenWidth, screenHeight),
                    SizedBox(height: 15),
                    saveButton(screenWidth, screenHeight,
                        member.user.organizationCode, member.user.userId),
                    SizedBox(height: 15),
                    // remark(),
                    // SizedBox(height: 100),
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
          // dayFocusChange(dayFormKey.currentContext, dayFocusNode);
          // nextFocusChange(nextFormKey.currentContext, nextFocusNode);
          // remarkFocusChange(remarkFormKey.currentContext, remarkFocusNode);
        },
      ),
    );
  }
  // #endregion

  void doSave(String organizationCode, String userId) {
    isSaved = false;
    dayFocusNode.unfocus();
    nextFocusNode.unfocus();
    // remarkFocusNode.unfocus();
    // APIService apiService = new APIService();
    APIServiceNew apiServiceNew = new APIServiceNew();

    List<String> sParam;

    if (dayReport != dayTextEditController.text) {
      sParam = [
        dayTextEditController.text,
        userId,
        organizationCode,
        date,
        userId
      ];

      if (dayReport == "") {
        //  INSERT
        if (nextReport == "") {
          //  익일 업무내용 정보가 DB에 없을 때
          apiServiceNew.getInsert("DAYREPORTI1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              dayReport = dayTextEditController.text;
            } else {}
          });
        } else {
          //  익일 업무내용 정보가 DB에 있을 때
          apiServiceNew.getUpdate("DAYREPORTU1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              dayReport = dayTextEditController.text;
            } else {}
          });
        }
      } else {
        if (dayTextEditController.text == "" &&
            nextTextEditController.text == "") {
          sParam = [organizationCode, date, userId];
          apiServiceNew.getDelete("DAYREPORTD1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              dayReport = dayTextEditController.text;
            } else {}
          });
        } else {
          apiServiceNew.getUpdate("DAYREPORTU1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              dayReport = dayTextEditController.text;
            } else {}
          });
        }
      }
      isSaved = true;
    }
    if (nextReport != nextTextEditController.text) {
      sParam = [
        nextTextEditController.text,
        userId,
        organizationCode,
        date,
        userId
      ];
      if (nextReport == "") {
        //  INSERT
        if (dayReport == "" && dayTextEditController.text == "") {
          //  일일 업무내용 정보가 DB에 없을 때
          apiServiceNew.getInsert("NEXTREPORTI1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              nextReport = nextTextEditController.text;
            } else {}
          });
        } else {
          //  일일 업무내용 정보가 DB에 있을 때
          apiServiceNew.getUpdate("NEXTREPORTU1", sParam).then((value) {
            if (value.result.isNotEmpty) {
              nextReport = nextTextEditController.text;
            } else {}
          });
        }
      } else {
        //  일일 업무내용 정보가 DB에 있을 때
        apiServiceNew.getUpdate("NEXTREPORTU1", sParam).then((value) {
          if (value.result.isNotEmpty) {
            nextReport = nextTextEditController.text;
          } else {}
        });
      }
      isSaved = true;
    }
  }

  void dayFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
  }

  void nextFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
  }

  void remarkFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
  }

  show(String sMessage) {
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
