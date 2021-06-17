import 'package:evolveofficeapp/pages/aproval_page.dart';
import 'package:evolveofficeapp/pages/dailySelect_page.dart';
import 'package:evolveofficeapp/pages/home_page.dart';
import 'package:evolveofficeapp/pages/login_page.dart';
import 'package:evolveofficeapp/pages/profile_page.dart';
import 'package:evolveofficeapp/pages/wheremanage_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
      title: Container(
        height: 70,
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
            'resource/office_head.png',
            fit: BoxFit.fitHeight,
            // fit: BoxFit.fill,
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
  final GlobalKey<ScaffoldState> globalKey;
  final String id;
  final String pass;
  final UserManager member;
  final int selectedIndex;
  final String pageName;

  KulsNavigationBottomBar({
    Key key,
    this.globalKey,
    this.id,
    this.pass,
    this.member,
    this.selectedIndex,
    this.pageName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = selectedIndex;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 6.0,
            offset: const Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Container(
        height: 40,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromRGBO(248, 246, 255, 1),
          selectedItemColor: pageName != 'home' ? Colors.black : Colors.grey,
          unselectedItemColor: Colors.black,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          currentIndex: _selectedIndex, //현재 선택된 Index
          onTap: (int index) {
            if (_selectedIndex != index && index == 0) {
              globalKey.currentState.openDrawer();
            } else if (index == 1 && pageName != 'home') {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePage(
                    id: id,
                    pass: pass,
                    member: member,
                  ),
                ),
              );
              _selectedIndex = index;
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
              _selectedIndex = index;
            }
          },
          items: [
            BottomNavigationBarItem(
              label: 'Menu',
              icon: Icon(
                Icons.menu_rounded,
                size: 16,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home,
                size: 16,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(
                Icons.person_outline,
                size: 16,
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
    // final screenWidth = MediaQuery.of(context).size.width;

    Widget menuRow(String sMenuName) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: Text(
              sMenuName,
              style: TextStyle(
                fontSize: 16,
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
      );
    }

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
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        storage.deleteAll();
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Icon(
                        Entypo.log_out,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
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
                        builder: (context) => HomePage(
                          id: id,
                          pass: pass,
                          member: member,
                        ),
                      ),
                    );
                  },
                  child: menuRow('HOME'),
                ),
                SizedBox(height: 20),
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
                  child: menuRow('오늘 내 고민'),
                ),
                SizedBox(height: 20),
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
                  child: menuRow('너 어디니'),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AprovalPage(
                          id: id,
                          pass: pass,
                          member: member,
                        ),
                      ),
                    );
                  },
                  child: menuRow('휴가원 관리'),
                ),
              ],
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
