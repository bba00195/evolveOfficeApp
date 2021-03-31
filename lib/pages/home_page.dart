import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:evolveofficeapp/pages/daily_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';

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
  static final storage = FlutterSecureStorage();
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String pass;
  DateTime nowDateTime = DateTime.now().add(Duration(hours: 9));
  String workDate;
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
    String year = nowDateTime.year.toString();
    String month = nowDateTime.month.toString().padLeft(2, '0');
    String day = nowDateTime.day.toString().padLeft(2, '0');

    workDate = year + month + day;
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass; //widget.pass LogOutPage에서 전달받은 pass 의미한다.
    mem = widget.member;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    var member = mem;
    _report(workDate);

    // #region 헤더 결재관리
    SliverToBoxAdapter _buildHeader(double screenHeight) {
      return SliverToBoxAdapter(
        child: Container(
          height: 160.0,
          decoration: BoxDecoration(
            // color: Colors.amber[200],
            image: new DecorationImage(
              image: ExactAssetImage(
                'resource/home_background.png',
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
            ],
          ),
        ),
      );
    }
    // #endregion

    // #region 요일
    SliverToBoxAdapter _buildDate(double screenHeight) {
      var _now = DateTime.now();
      String year = _now.year.toString();
      String month = _now.month.toString();
      String day = _now.day.toString();
      String weekday;

      switch (_now.weekday) {
        case 1:
          weekday = "월요일";
          break;
        case 2:
          weekday = "화요일";
          break;
        case 3:
          weekday = "수요일";
          break;
        case 4:
          weekday = "목요일";
          break;
        case 5:
          weekday = "금요일";
          break;
        case 6:
          weekday = "토요일";
          break;
        case 7:
          weekday = "일요일";
          break;
        default:
          break;
      }

      String date = year + "년 " + month + "월 " + day + "일 " + weekday;

      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: 6.0, right: 12.0),
          child: Text(
            date,
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
    SliverToBoxAdapter _buildDashboard(double screenHeight) {
      return SliverToBoxAdapter(
        child: Container(
          height: 170,
          margin: EdgeInsets.only(
            top: 15.0,
            left: 45.0,
            bottom: 25.0,
            right: 45.0,
          ),
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 6.0,
                offset: const Offset(0.0, 3.0),
                color: Color.fromRGBO(0, 0, 0, 0.16),
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
          child: InkWell(
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
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 15.0,
                        ),
                        height: 30,
                        child: Text(
                          '일일 업무 보고',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        height: 120,
                        child: FutureBuilder<DailyResultModel>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.day.isNotEmpty) {
                                return Text(
                                  snapshot.data.day.elementAt(0).dayReport,
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                );
                              } else {
                                return Text("${snapshot.error}");
                              }
                            }
                            return Text('');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 36,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // #endregion

    SliverToBoxAdapter _buildManage(double screenHeight) {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 45.0, right: 45.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15.0,
                          offset: const Offset(3.0, 5.0),
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                        )
                      ],
                      color: Color.fromRGBO(255, 243, 243, 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                            left: 15,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.airplanemode_active,
                            color: Colors.deepOrange[300],
                            size: 55.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 43,
                            right: 15,
                          ),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '휴가원 관리',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15.0,
                          offset: const Offset(3.0, 5.0),
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                        )
                      ],
                      color: Color.fromRGBO(98, 208, 181, 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                            left: 15,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 55.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 43,
                            right: 15,
                          ),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '행선지 등록',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
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
                                color: Color.fromRGBO(101, 209, 182, 1.0),
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
                                onPressed: () => Navigator.pop(context, true),
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
      appBar: KulsAppBar(
        id: id,
        pass: pass,
        member: member,
      ),
      bottomNavigationBar: KulsBottomBar(),
      body: WillPopScope(
        child: Center(
          child: CustomScrollView(
            // customScrollView 에서는 children 대신 slivers를 사용
            slivers: [
              _buildHeader(screenHeight),
              _buildDate(screenHeight),
              _buildDashboard(screenHeight),
              _buildManage(screenHeight),
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
