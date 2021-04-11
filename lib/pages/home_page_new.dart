import 'dart:io';

import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:evolveofficeapp/pages/whereis_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';

import 'daily_page.dart';

class HomePageNew extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;

  HomePageNew({
    this.id,
    this.pass,
    this.member,
  });
  @override
  _HomePageNew createState() => new _HomePageNew();
}

class _HomePageNew extends State<HomePageNew> {
  static final storage = FlutterSecureStorage();
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String pass;
  String date;
  UserManager mem;
  Future<DailyResultModel> futureAlbum;

  void _report(String selectedDate) async {
    setState(() {
      APIService apiService = new APIService();
      futureAlbum = apiService.report(
          mem.user.organizationCode, mem.user.userId, selectedDate);
    });
  }

  @override
  void initState() {
    super.initState();
    date = Date().date(null);
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass; //widget.pass LogOutPage에서 전달받은 pass 의미한다.
    mem = widget.member;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    var member = mem;
    _report(date);

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

    // #region 헤더 결재관리
    Widget buildHeader = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30),
        Container(
          margin: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
          ),
          height: 160.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // width: screenWidth * 32,
                height: screenHeight * 0.1,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage('resource/kuls.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                // height: screenHeight * 0.05,
                child: Text(
                  mem.user.nameKor,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
              SizedBox(height: 14),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        // height: screenHeight * 0.005,
                        child: Text(
                          "welcome Office",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        Date().dateWeek(null),
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ],
    );
    // #endregion

    // #region 요일
    SliverToBoxAdapter _buildDate(double screenHeight) {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 6.0, right: 12.0),
          child: Text(
            Date().dateWeek(null),
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'NotoSansKR',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      );
    }

    // #endregion

    // #region 일일 업무보고
    Widget buildSearchButton = Column(
      children: [
        SizedBox(height: 30),
        InkWell(
          child: Container(
            margin: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            height: screenHeight * 0.07,
            decoration: BoxDecoration(
              color: Color.fromRGBO(244, 242, 255, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 26,
                    color: Color.fromRGBO(121, 101, 254, 1),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "search",
                    style: TextStyle(
                      color: Color.fromRGBO(121, 101, 254, 1),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            _show("준비중입니다.");
          },
        ),
      ],
    );
    // #endregion

    // #region 일일 업무보고
    Widget buildDashboard = Container(
      margin: EdgeInsets.only(
        top: screenHeight * 0.05,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        bottom: screenHeight * 0.05,
      ),
      height: 70.0,
      child: ListView(
        // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.0,
                    offset: const Offset(3.0, 5.0),
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                  )
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              width: 70,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.border_all,
                    size: 30,
                  ),
                  Text(
                    "All",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              _show("준비중입니다.");
            },
          ),
          SizedBox(width: 12),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.0,
                    offset: const Offset(3.0, 5.0),
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                  )
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              width: 70,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.radio_button_checked,
                    size: 30,
                  ),
                  Text(
                    "업무관리",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              _show("준비중입니다.");
            },
          ),
          SizedBox(width: 12),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10.0,
                    offset: const Offset(3.0, 5.0),
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                  )
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              width: 70,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_travel,
                    size: 30,
                  ),
                  Text(
                    "문서관리",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              _show("준비중입니다.");
            },
          ),
        ],
      ),
    );

    // #endregion

    SliverToBoxAdapter _buildManage(double screenHeight) {
      return SliverToBoxAdapter(
        child: Container(
          // alignment: Alignment.topCenter,
          height: 300.0,
          margin: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              top: 0,
            ),
            children: <Widget>[
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        offset: const Offset(3.0, 5.0),
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      )
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  height: screenHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 14),
                      Container(
                        width: screenHeight * 0.07,
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(244, 242, 255, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          color: Color.fromRGBO(121, 102, 254, 1),
                          size: 36,
                        ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          "일일업무보고",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => DailyPage(
                        id: id,
                        member: member,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 14),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        offset: const Offset(3.0, 5.0),
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      )
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  height: screenHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 14),
                      Container(
                        width: screenHeight * 0.07,
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(244, 242, 255, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.directions_car_rounded,
                          color: Color.fromRGBO(180, 115, 222, 1),
                          size: 36,
                        ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          "행선지 등록",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // _show("준비중입니다.");
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => WhereIsPage(
                        id: id,
                        pass: pass,
                        member: member,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 14),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        offset: const Offset(3.0, 5.0),
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      )
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  height: screenHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 14),
                      Container(
                        width: screenHeight * 0.07,
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(254, 242, 246, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.directions_boat,
                          color: Color.fromRGBO(255, 101, 129, 1),
                          size: 36,
                        ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          "휴가원 관리",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _show("준비중입니다.");
                },
              ),
            ],
          ),
        ),
      );
    }

    // #region 종료버튼
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => Material(
              type: MaterialType.transparency,
              child: Center(
                child: Container(
                  height: 250,
                  margin: EdgeInsets.only(
                    left: 35,
                    right: 35,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          image: DecorationImage(
                            image: AssetImage('resource/kuls.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(),
                        child: Text(
                          'Evolve Office를 종료하시겠습니까?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                ),
                              ),
                              height: 50,
                              child: TextButton(
                                child: Text(
                                  "취소",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'NotoSansKR',
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(121, 102, 254, 1.0),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              height: 50,
                              child: TextButton(
                                child: Text(
                                  "확인",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'NotoSansKR',
                                  ),
                                ),
                                onPressed: () => SystemNavigator.pop(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ) ??
          false;
    }
    // #endregion

    // #region Body
    return Scaffold(
      bottomNavigationBar: KulsNavigationBottomBar(
        id: id,
        pass: pass,
        member: member,
        selectedIndex: 1,
      ),
      body: WillPopScope(
        child: Center(
          child: Column(
            children: [
              buildHeader,
              buildSearchButton,
              buildDashboard,
              Expanded(
                child: CustomScrollView(
                  // customScrollView 에서는 children 대신 slivers를 사용
                  slivers: [
                    // _buildDate(screenHeight),
                    _buildManage(screenHeight),
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: _onBackPressed,
      ),
      drawer: KulsDrawer(
        id: id,
        pass: pass,
        member: member,
        storage: storage,
      ),
    );
  }
  // #endregion
}
