import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/api/api_service_new.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:evolveofficeapp/model/main_model.dart';
import 'package:evolveofficeapp/pages/aproval_page.dart';
import 'package:evolveofficeapp/pages/dailySelect_page.dart';
import 'package:evolveofficeapp/pages/profile_page.dart';
import 'package:evolveofficeapp/pages/wheremanage_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  List<InformationResponseModel> infoValue;
  List<BoardResponseModel> boardValue;
  String sNextReport = "";
  String sInfoText = "";

  String unDecided = "0";
  String returnApr = "0";
  String receive = "0";
  String complete = "0";

  int itemCount = 0;

  final ScrollController _scrollController = ScrollController();

  void _report(String selectedDate) async {
    setState(() {
      APIService apiService = new APIService();
      futureAlbum = apiService.report(
          mem.user.organizationCode, mem.user.userId, selectedDate);
    });
  }

  void board() async {
    APIServiceNew apiServiceNew = new APIServiceNew();
    List<String> sParam = [
      mem.user.organizationCode,
      mem.user.userId,
    ];
    apiServiceNew.getSelect("BOARD_S1", sParam).then((value) {
      setState(() {
        if (value.board.isNotEmpty) {
          boardValue = value.board;
          itemCount = boardValue.length;
        } else {
          itemCount = 0;
        }
      });
    });
  }

  void approval() async {
    APIServiceNew apiServiceNew = new APIServiceNew();
    List<String> sParam = [
      mem.user.organizationCode,
      mem.user.userId,
    ];
    apiServiceNew.getSelect("APPROVAL_S1", sParam).then((value) {
      setState(() {
        if (value.approval.isNotEmpty) {
          unDecided = value.approval.elementAt(0).unDecieded;
          returnApr = value.approval.elementAt(0).returnApr;
          receive = value.approval.elementAt(0).receive;
          complete = value.approval.elementAt(0).complete;
        } else {
          unDecided = "0";
          returnApr = "0";
          receive = "0";
          complete = "0";
        }
      });
    });
  }

  void _information() async {
    APIServiceNew apiServiceNew = new APIServiceNew();
    List<String> sParam = [
      mem.user.organizationCode,
    ];
    apiServiceNew.getSelect("INFORMATION_S1", sParam).then((value) {
      setState(() {
        if (value.information.isNotEmpty) {
          // infoValue = value.information;
          sInfoText = value.information.elementAt(0).infoText;
        } else {
          sInfoText = "";
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    date = Date().date(DateTime.now().add(Duration(days: -1)));
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass; //widget.pass LogOutPage에서 전달받은 pass 의미한다.
    mem = widget.member;
    approval();
    board();
    _information();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    _report(date);
    var member = mem;

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
    Widget buildHeader = Container(
      // height: screenHeight * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 3),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(77, 80, 119, 1),
            ),
            child: CarouselSlider(
                options: CarouselOptions(
                  height: 40,
                  initialPage: 0,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
                items: [
                  for (int i = 0; i < itemCount; i++)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      width: screenWidth,
                      child: Center(
                        child: AutoSizeText(
                          boardValue.elementAt(i).contents.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          maxFontSize: 14,
                          minFontSize: 8,
                          maxLines: 1,
                        ),
                      ),
                    ),
                ]),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ProfilePage(
                            id: id,
                            pass: pass,
                            member: member,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: _memberImage(),
                          ),
                        ),
                        Text(
                          mem.user.nameKor,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Text(
                      Date().dateWeek(null),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Expanded(
          //       flex: 4,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Container(
          //             // height: screenHeight * 0.05,
          //             child: Text(
          //               mem.user.nameKor,
          //               style: TextStyle(
          //                 fontSize: 30,
          //                 fontFamily: 'NotoSansKR',
          //               ),
          //             ),
          //           ),
          //           SizedBox(height: 14),
          //           // Container(
          //           //   // height: screenHeight * 0.005,
          //           //   child: Text(
          //           //     'welcome Office',
          //           //     style: TextStyle(
          //           //       fontSize: 16,
          //           //       fontFamily: 'NotoSansKR',
          //           //       fontWeight: FontWeight.w600,
          //           //     ),
          //           //   ),
          //           // ),
          //         ],
          //       ),
          //     ),
          //     Container(
          //       width: 90,
          //       height: 90,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(45),
          //         border: Border.all(
          //           color: Colors.white,
          //           width: 3,
          //         ),
          //         image: _memberImage(),
          //         boxShadow: [
          //           BoxShadow(
          //             blurRadius: 10.0,
          //             offset: const Offset(3.0, 5.0),
          //             color: Color.fromRGBO(0, 0, 0, 0.16),
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // Container(
          //   child: Text(
          //     Date().dateWeek(null),
          //     style: TextStyle(
          //       fontSize: 14,
          //       fontFamily: 'NotoSansKR',
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenWidth / 5.5,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DailySelectPage(
                            id: id,
                            pass: pass,
                            member: member,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(3),
                      height: screenWidth / 5.5,
                      width: screenWidth / 5.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            offset: const Offset(1.0, 1.0),
                            color: Color.fromRGBO(0, 0, 0, 0.16),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 14,
                                  ),
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                      builder: (context, constraint) {
                                    return new Icon(
                                      Icons.description_outlined,
                                      size: constraint.biggest.height,
                                      color: Color.fromRGBO(251, 215, 100, 1),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: AutoSizeText(
                                '일일업무',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                minFontSize: 8,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => WhereManagePage(
                            id: id,
                            pass: pass,
                            member: member,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(3),
                      height: screenWidth / 5.5,
                      width: screenWidth / 5.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            offset: const Offset(1.0, 1.0),
                            color: Color.fromRGBO(0, 0, 0, 0.16),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 14,
                                  ),
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                      builder: (context, constraint) {
                                    return new Icon(
                                      Icons.directions_car,
                                      size: constraint.biggest.height,
                                      color: Color.fromRGBO(180, 115, 222, 1),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: AutoSizeText(
                                '행선지',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                minFontSize: 8,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       CupertinoPageRoute(
                  //         builder: (context) => AprovalPage(
                  //           id: id,
                  //           pass: pass,
                  //           member: member,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.all(5),
                  //     margin: EdgeInsets.all(3),
                  //     height: screenWidth / 5.5,
                  //     width: screenWidth / 5.5,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(5),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           blurRadius: 3.0,
                  //           offset: const Offset(1.0, 1.0),
                  //           color: Color.fromRGBO(0, 0, 0, 0.16),
                  //         )
                  //       ],
                  //     ),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           flex: 1,
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Expanded(
                  //                 child: AutoSizeText(
                  //                   '',
                  //                   style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                   maxLines: 1,
                  //                   minFontSize: 14,
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                 child: LayoutBuilder(
                  //                     builder: (context, constraint) {
                  //                   return new Icon(
                  //                     Icons.directions_boat,
                  //                     size: constraint.biggest.height,
                  //                     color: Color.fromRGBO(255, 101, 129, 1),
                  //                   );
                  //                 }),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 1,
                  //           child: Container(
                  //             alignment: Alignment.bottomLeft,
                  //             child: AutoSizeText(
                  //               '휴가원',
                  //               style: TextStyle(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //               maxLines: 1,
                  //               minFontSize: 8,
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
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
              height: (screenHeight * 0.45),
              //  - (screenWidth / 4),
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
              // child: Text(sNextReport),
            ),
            // Container(
            //   height: screenWidth / 4,
            //   child: Row(
            //     children: [
            //       Expanded(
            //         flex: 3,
            //         child: Container(
            //           padding: EdgeInsets.all(5),
            //           margin: EdgeInsets.all(3),
            //           height: screenWidth / 4,
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(5),
            //             boxShadow: [
            //               BoxShadow(
            //                 blurRadius: 3.0,
            //                 offset: const Offset(1.0, 1.0),
            //                 color: Color.fromRGBO(0, 0, 0, 0.16),
            //               )
            //             ],
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Expanded(
            //                 flex: 1,
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Expanded(
            //                       child: AutoSizeText(
            //                         '대기',
            //                         style: TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                         maxLines: 1,
            //                         minFontSize: 14,
            //                       ),
            //                     ),
            //                     Expanded(
            //                       child: Container(
            //                         child: Icon(
            //                           Icons.description_outlined,
            //                           size: screenWidth * 0.1,
            //                           color: Color.fromRGBO(129, 121, 214, 1),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Expanded(
            //                 flex: 1,
            //                 child: Container(
            //                   alignment: Alignment.bottomLeft,
            //                   child: AutoSizeText(
            //                     unDecided,
            //                     style: TextStyle(
            //                       fontSize: 32,
            //                       fontWeight: FontWeight.w600,
            //                     ),
            //                     maxLines: 1,
            //                     minFontSize: 20,
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 3,
            //         child: Container(
            //           padding: EdgeInsets.all(5),
            //           margin: EdgeInsets.all(3),
            //           height: screenWidth / 4,
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(5),
            //             boxShadow: [
            //               BoxShadow(
            //                 blurRadius: 3.0,
            //                 offset: const Offset(1.0, 1.0),
            //                 color: Color.fromRGBO(0, 0, 0, 0.16),
            //               )
            //             ],
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Expanded(
            //                 flex: 1,
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Expanded(
            //                       child: AutoSizeText(
            //                         '수신',
            //                         style: TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                         maxLines: 1,
            //                         minFontSize: 14,
            //                       ),
            //                     ),
            //                     Expanded(
            //                       child: Container(
            //                         child: Icon(
            //                           Icons.near_me_outlined,
            //                           size: screenWidth * 0.1,
            //                           color: Color.fromRGBO(251, 195, 55, 1),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Expanded(
            //                 flex: 1,
            //                 child: Container(
            //                   alignment: Alignment.bottomLeft,
            //                   child: AutoSizeText(
            //                     receive,
            //                     style: TextStyle(
            //                       fontSize: 32,
            //                       fontWeight: FontWeight.w600,
            //                     ),
            //                     maxLines: 1,
            //                     minFontSize: 20,
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 3,
            //         child: Container(
            //           padding: EdgeInsets.all(5),
            //           margin: EdgeInsets.all(3),
            //           height: screenWidth / 4,
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(5),
            //             boxShadow: [
            //               BoxShadow(
            //                 blurRadius: 3.0,
            //                 offset: const Offset(1.0, 1.0),
            //                 color: Color.fromRGBO(0, 0, 0, 0.16),
            //               )
            //             ],
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Expanded(
            //                 flex: 1,
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Expanded(
            //                       child: AutoSizeText(
            //                         '반려',
            //                         style: TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                         maxLines: 1,
            //                         minFontSize: 14,
            //                       ),
            //                     ),
            //                     Expanded(
            //                       child: Container(
            //                         child: Icon(
            //                           Icons.replay,
            //                           size: screenWidth * 0.1,
            //                           color: Color.fromRGBO(255, 135, 128, 1),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Expanded(
            //                 flex: 1,
            //                 child: Container(
            //                   alignment: Alignment.bottomLeft,
            //                   child: AutoSizeText(
            //                     returnApr,
            //                     style: TextStyle(
            //                       fontSize: 32,
            //                       fontWeight: FontWeight.w600,
            //                     ),
            //                     maxLines: 1,
            //                     minFontSize: 20,
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 3,
            //         child: Container(
            //           padding: EdgeInsets.all(5),
            //           margin: EdgeInsets.all(3),
            //           height: screenWidth / 4,
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(5),
            //             boxShadow: [
            //               BoxShadow(
            //                 blurRadius: 3.0,
            //                 offset: const Offset(1.0, 1.0),
            //                 color: Color.fromRGBO(0, 0, 0, 0.16),
            //               )
            //             ],
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Expanded(
            //                 flex: 1,
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Expanded(
            //                       child: AutoSizeText(
            //                         '완료',
            //                         style: TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                         maxLines: 1,
            //                         minFontSize: 14,
            //                       ),
            //                     ),
            //                     Expanded(
            //                       child: Container(
            //                         child: Icon(
            //                           Icons.folder_open_outlined,
            //                           size: screenWidth * 0.1,
            //                           color: Color.fromRGBO(74, 72, 102, 1),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Expanded(
            //                 flex: 1,
            //                 child: Container(
            //                   alignment: Alignment.bottomLeft,
            //                   child: AutoSizeText(
            //                     complete,
            //                     style: TextStyle(
            //                       fontSize: 32,
            //                       fontWeight: FontWeight.w600,
            //                     ),
            //                     maxLines: 1,
            //                     minFontSize: 20,
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
        child: ListView(
          controller: _scrollController,
          children: [
            Container(
              child: Column(
                children: [
                  buildHeader,
                  buildManage,
                  Container(
                    margin: EdgeInsets.only(
                      top: 15.0,
                      bottom: 25.0,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: 5.0,
                            bottom: 5.0,
                          ),
                          alignment: Alignment.center,
                          width: screenWidth - (screenWidth * 0.1),
                          color: Colors.indigo[900],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'FYI 내용',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'NotoSansKR',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              // Icon(
                              //   Icons.keyboard_arrow_down_rounded,
                              //   size: 32,
                              //   color: Colors.white,
                              // )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                            top: 5.0,
                            bottom: 5.0,
                          ),
                          alignment: Alignment.center,
                          child: Linkify(
                            onOpen: (link) async {
                              print("Clicked ${link.url}!");
                              final url = '${link.url}';
                              await launch(
                                url,
                                forceWebView: false,
                                forceSafariVC: false,
                              );
                            },
                            text: sInfoText,
                            options: LinkifyOptions(humanize: false),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        // Column(
        //   children: [
        //     Container(
        //       child: Column(
        //         children: [
        //           Expanded(
        //             flex: 3,
        //             child: buildHeader,
        //           ),
        //           Expanded(
        //             flex: 6,
        //             child: buildManage,
        //           ),
        //           Expanded(
        //             flex: 1,
        //             child: Container(
        //                 // child: Text(sInfoText),
        //                 ),
        //           ),
        //         ],
        //       ),
        //       // Text(sInfoText),
        //     ),
        //   ],
        // ),
        // child: Container(
        //   child: Column(
        //     children: [
        //       Expanded(
        //         flex: 3,
        //         child: buildHeader,
        //       ),
        //       Expanded(
        //         flex: 6,
        //         child: buildManage,
        //       ),
        //       Expanded(
        //         flex: 1,
        //         child: Container(
        //             // child: Text(sInfoText),
        //             ),
        //       ),
        //       Container(
        //         child: Text(sInfoText),
        //       ),
        //     ],
        //   ),
        //   // Container(),
        // ),
        onWillPop: _onBackPressed,
      ),
      drawer: KulsDrawer(
        id: id,
        pass: pass,
        member: member,
        storage: storage,
      ),
      // floatingActionButton: _showBackToTopButton == false
      //     ? null
      //     : FloatingActionButton(
      //         onPressed: _scrollToTop,
      //         child: Icon(Icons.arrow_upward),
      //       ),
    );
  }
  // #endregion
}
