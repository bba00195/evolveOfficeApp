import 'package:evolveofficeapp/pages/daily_page.dart';
import 'package:evolveofficeapp/pages/home_page.dart';
import 'package:evolveofficeapp/pages/login_page.dart';
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
        new IconButton(
          icon: new Icon(
            Icons.notifications,
            color: Colors.white,
            size: 30,
          ),
          onPressed: null,
        ),
        new IconButton(
          icon: new Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
          onPressed: null,
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
                        storage.delete(key: "login");
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
                                  builder: (context) => DailyPage(
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
                            onPressed: () {},
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
                            onPressed: () {},
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
