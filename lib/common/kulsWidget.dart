import 'package:evolveofficeapp/pages/daily_page.dart';
import 'package:evolveofficeapp/pages/dayText_page.dart';
import 'package:evolveofficeapp/pages/home_page.dart';
import 'package:evolveofficeapp/pages/home_page_new.dart';
import 'package:evolveofficeapp/pages/login_page.dart';
import 'package:evolveofficeapp/pages/menu_page.dart';
import 'package:evolveofficeapp/pages/profile_page.dart';
import 'package:evolveofficeapp/pages/whereis_page.dart';
import 'package:evolveofficeapp/pages/wheremanage_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'common.dart';

class KulsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final String id;
  final String pass;
  final UserManager member;
  final FlutterSecureStorage storage;

  KulsAppBar(
      {Key key, this.globalKey, this.id, this.pass, this.member, this.storage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new AppBar(
      actions: [],
      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => globalKey.currentState.openDrawer(),
      ),
      title: SizedBox(
        height: 95,
        child: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePageNew(
                  id: id,
                  pass: pass,
                  member: member,
                ),
              ),
            );
          },
          child: Image.asset(
            'resource/kuls.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      toolbarHeight: 100,
      iconTheme: IconThemeData(color: Colors.black),
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
      height: screenHeight * 0.1,
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
          selectedItemColor: Colors.grey,
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
            } else if (_selectedIndex != index && index == 1) {
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
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(
                Icons.person_outline,
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

  DecorationImage _memberImage() {
    if (member.user.imgSajin != "" && member.user.imgSajin != null) {
      return DecorationImage(
        image: NetworkImage(
            'http://211.213.24.71:8080/Upload/sajin/' + member.user.imgSajin),
        fit: BoxFit.cover,
      );
    } else {
      return DecorationImage(
        image: AssetImage('resource/person.png'),
        fit: BoxFit.cover,
      );
    }
  }

  KulsDrawer({Key key, this.id, this.pass, this.member, this.storage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return new Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            height: 100,
            color: Color.fromRGBO(244, 242, 255, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
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
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        member.user.nameKor + " 님",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        "활기찬 오후를 위해 힘내세요.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'NotoSansKR',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight - 210,
            padding: EdgeInsets.all(45),
            child: ListView(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => HomePageNew(
                          id: id,
                          pass: pass,
                          member: member,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Text(
                          'HOME',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Text(
                          '일일 업무 보고',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => WhereIsPage(
                          id: id,
                          pass: pass,
                          member: member,
                          isUpdate: false,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Text(
                          '행선지 등록',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Text(
                          '행선지 관리',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'NotoSansKR',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // storage.delete(key: "login");
              storage.deleteAll();
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            child: Container(
              height: 70,
              margin: EdgeInsets.only(
                left: 45,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ),
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
