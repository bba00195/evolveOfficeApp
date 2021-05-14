import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'daily_page.dart';

class HomePage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;

  HomePage({
    this.id,
    this.pass,
    this.member,
  });
  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    date = Date().date(DateTime.now().add(Duration(days: -1)));
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

    DecorationImage _memberImage() {
      if (mem.user.imgSajin != "" && mem.user.imgSajin != null) {
        return DecorationImage(
          image: NetworkImage(
              'http://211.213.24.71:8080/Upload/sajin/' + mem.user.imgSajin),
          fit: BoxFit.cover,
        );
      } else {
        return DecorationImage(
          image: AssetImage('resource/person.png'),
          fit: BoxFit.cover,
        );
      }
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
          // height: screenHeight * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   // width: screenWidth * 32,
              //   height: screenHeight * 0.1,
              //   decoration: BoxDecoration(
              //     color: Colors.transparent,
              //     image: DecorationImage(
              //       image: AssetImage('resource/kuls.png'),
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        Container(
                          // height: screenHeight * 0.005,
                          child: Text(
                            'welcome Office',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      image: _memberImage(),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10.0,
                          offset: const Offset(3.0, 5.0),
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Text(
                  Date().dateWeek(null),
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Expanded(
              //         child:
              //       ),
              //       Container(
              //         child: Text(
              //           Date().dateWeek(null),
              //           style: TextStyle(
              //             fontSize: 14,
              //             fontFamily: 'NotoSansKR',
              //             fontWeight: FontWeight.w600,
              //           ),
              //           textAlign: TextAlign.right,
              //         ),
              //       ),
              //     ]),
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
        SizedBox(height: 20),
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
        top: screenHeight * 0.02,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        bottom: screenHeight * 0.01,
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

    Widget buildManage = Container(
      // height: 170,
      margin: EdgeInsets.only(
        top: 15.0,
        bottom: 25.0,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      ),
      // padding: EdgeInsets.only(
      //   left: 15.0,
      //   right: 15.0,
      // ),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 6.0,
        //     offset: const Offset(0.0, 3.0),
        //     color: Color.fromRGBO(0, 0, 0, 0.16),
        //   )
        // ],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   CupertinoPageRoute(
          //     builder: (context) => DailyPage(
          //       id: id,
          //       member: member,
          //     ),
          //   ),
          // );
        },
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // margin: EdgeInsets.only(
                    //   top: 15.0,
                    // ),
                    padding: EdgeInsets.all(5.0),
                    width: screenWidth,
                    color: Color.fromRGBO(244, 242, 255, 1),
                    // height: 30,
                    child: Text(
                      '금일 예정 업무',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                      top: 15.0,
                      left: 15.0,
                    ),
                    child: FutureBuilder<DailyResultModel>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.day.isNotEmpty) {
                            return Text(
                              snapshot.data.day.elementAt(0).nextReport,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'NotoSansKR',
                              ),
                            );
                          } else {
                            return Text('');
                          }
                        }
                        return Text('');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

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
      key: _scaffoldKey,
      appBar: KulsAppBar(
        globalKey: _scaffoldKey,
        id: id,
        pass: pass,
        member: member,
        storage: storage,
      ),
      bottomNavigationBar: KulsNavigationBottomBar(
        globalKey: _scaffoldKey,
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
              // buildSearchButton,
              // buildDashboard,
              Expanded(
                child: buildManage,
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
