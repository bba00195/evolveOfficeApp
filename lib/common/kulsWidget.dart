import 'package:evolveofficeapp/pages/dayText_page.dart';
import 'package:evolveofficeapp/pages/home_page.dart';
import 'package:evolveofficeapp/pages/home_page_new.dart';
import 'package:evolveofficeapp/pages/login_page.dart';
import 'package:evolveofficeapp/pages/menu_page.dart';
import 'package:evolveofficeapp/pages/whereis_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'common.dart';

class KulsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String id;
  final String pass;
  final UserManager member;

  KulsAppBar({Key key, this.id, this.pass, this.member}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new AppBar(
      actions: [
        // new IconButton(
        //   icon: new Icon(
        //     Icons.notifications,
        //     color: Colors.white,
        //     size: 30,
        //   ),
        //   onPressed: null,
        // ),
        new IconButton(
          icon: new Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('준비중입니다.'),
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
          },
        )
      ],
      backgroundColor: Color.fromRGBO(101, 209, 182, 1.0),
      centerTitle: true,
      title: SizedBox(
        height: 95,
        child: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePage(
                  id: id,
                  pass: pass,
                  member: member,
                ),
              ),
            );
          },
          child: Image.asset(
            'resource/kuls_home.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      toolbarHeight: 100,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class KulsBottomBar extends StatelessWidget implements PreferredSizeWidget {
  KulsBottomBar({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new BottomAppBar(
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              height: 70,
              alignment: Alignment.center,
              child: Text(
                'Copyright ⓒ 2021 KULS All right reserved.',
                style: TextStyle(
                  color: Color.fromARGB(255, 175, 175, 175),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

// ignore: must_be_immutable
class KulsNavigationBottomBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String id;
  final String pass;
  final UserManager member;
  final int selectedIndex;

  KulsNavigationBottomBar(
      {Key key, this.id, this.pass, this.member, this.selectedIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    int _selectedIndex = selectedIndex;
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 6.0,
            offset: const Offset(0.0, 3.0),
          ),
        ],
      ),
      margin: EdgeInsets.only(
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        top: screenHeight * 0.01,
        bottom: screenHeight * 0.01,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromRGBO(248, 246, 255, 1),
          // backgroundColor: Colors.red,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: _selectedIndex, //현재 선택된 Index
          onTap: (int index) {
            if (_selectedIndex != index && index == 0) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MenuPage(
                    id: id,
                    pass: pass,
                    member: member,
                  ),
                ),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePageNew(
                    id: id,
                    pass: pass,
                    member: member,
                  ),
                ),
              );
            } else if (_selectedIndex != index && index == 2) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("준비중입니다."),
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
            _selectedIndex = index;
          },
          items: [
            BottomNavigationBarItem(
              label: 'Menu',
              icon: Icon(
                Icons.menu_rounded,
                size: 26,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home,
                size: 26,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(
                Icons.person_outline,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class KulsDrawer extends StatelessWidget implements PreferredSizeWidget {
  final String id;
  final String pass;
  final UserManager member;
  final FlutterSecureStorage storage;

  KulsDrawer({Key key, this.id, this.pass, this.member, this.storage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            height: 70,
            color: Color.fromRGBO(101, 209, 182, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Text(
                      "안녕하세요 " + member.user.nameKor + " 님",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(111, 217, 191, 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    height: 40,
                    child: TextButton(
                      child: Text(
                        "로그아웃",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                      onPressed: () {
                        // storage.delete(key: "login");
                        storage.deleteAll();
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 40,
            padding: EdgeInsets.only(
              left: 10,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              '업무관리',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'NotoSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[400],
                      ),
                      right: BorderSide(
                        color: Colors.grey[400],
                      ),
                      bottom: BorderSide(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.create,
                            color: Colors.black,
                            // size: 55.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Container(
                          child: TextButton(
                            child: Text(
                              '일일 업무 보고',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => DailyTextPage(
                                    id: id,
                                    member: member,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[400],
                      ),
                      bottom: BorderSide(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 3),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.black,
                            // size: 55.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Container(
                          child: TextButton(
                            child: Text(
                              '일일업무 기간별조회',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text('준비중입니다.'),
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
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey[400],
                      ),
                      bottom: BorderSide(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                            // size: 55.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Container(
                          child: TextButton(
                            child: Text(
                              '행선지 등록',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => WhereIsPage(
                                    id: id,
                                    member: member,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class KulsMessage extends StatelessWidget implements PreferredSizeWidget {
  final String sMessage;
  KulsMessage({Key key, this.sMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text('AlertDialog Title'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(sMessage),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('확인'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  } // 비밀번호 불일치

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
