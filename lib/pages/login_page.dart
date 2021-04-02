// #region Import
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// #endregion

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true; // Password Hide

  final _idTextEditController = TextEditingController();
  final _passwordTextEditController = TextEditingController();

  @override
  void dispose() {
    _idTextEditController.dispose();
    _passwordTextEditController.dispose();
    super.dispose();
  }

  static final storage =
      new FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // #region Widget

    // #region Logo
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('resource/EvolveOffice.png'),
      ),
    );
    // #endregion

    // #region IdIcon
    final userIcon = Positioned(
      left: 1.0,
      child: Container(
        width: 63,
        height: 63,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              offset: const Offset(1.0, 4.0),
              color: Color.fromRGBO(187, 235, 223, 1.0),
            )
          ],
          color: Colors.white,
        ),
        child: Image.asset('resource/icon_user.png'),
      ),
    );
    // #endregion

    // #region PasswordIcon
    final lockIcon = Positioned(
      left: 1.0,
      child: Container(
        width: 63,
        height: 63,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              offset: const Offset(1.0, 4.0),
              color: Color.fromRGBO(187, 235, 223, 1.0),
            )
          ],
          color: Colors.white,
        ),
        child: Image.asset('resource/icon_lock.png'),
      ),
    );
    // #endregion

    // #region IdTextField
    final txtUserName = Material(
      borderRadius: BorderRadius.circular(25.0),
      child: TextField(
        autofocus: false,
        controller: _idTextEditController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(80.0, 8.0, 0.0, 8.0),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Username',
        ),
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'NotoSansKR',
        ),
      ),
      elevation: 6.0,
      shadowColor: Color.fromRGBO(187, 235, 223, 1.0),
    );
    // #endregion

    // #region PasswordTextField
    final txtPassword = Material(
      borderRadius: BorderRadius.circular(25.0),
      child: TextField(
        autofocus: false,
        controller: _passwordTextEditController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(80.0, 8.0, 0.0, 8.0),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Password',
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            color: Theme.of(context).accentColor.withOpacity(0.4),
            icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
          ),
        ),
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'NotoSansKR',
        ),
        obscureText: hidePassword,
      ),
      elevation: 6.0,
      shadowColor: Color.fromRGBO(187, 235, 223, 1.0),
    );
    // #endregion

    // #region IdPanel
    final pnlUserName = Container(
      height: 65,
      child: Stack(
        alignment: AlignmentDirectional.center, //alignment:new Alignment(x, y)
        children: <Widget>[
          txtUserName,
          userIcon,
        ],
      ),
    );
    // #endregion

    // #region PasswordPanel
    final pnlPassword = Container(
      height: 65,
      child: Stack(
        alignment: AlignmentDirectional.center, //alignment:new Alignment(x, y)
        children: <Widget>[
          txtPassword,
          lockIcon,
        ],
      ),
    );
    // #endregion

    // #region ButtonLogin
    final loginButton = Container(
      height: 40,
      padding: EdgeInsets.only(left: 35.0, right: 35.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(24),
          ),
          primary: Color.fromRGBO(102, 209, 182, 1.0),
        ),
        onPressed: () async {
          _login(_idTextEditController.text, _passwordTextEditController.text);
        },
        child: Text(
          'Sign in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
    // #endregion

    // #region Label
    final forgotLabel = TextButton(
      child: Text(
        'Login to your account',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );
    // #endregion

    // #endregion

    // #region Body

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
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
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      body: WillPopScope(
        child: Center(
          child: ListView(
            shrinkWrap: false,
            padding: EdgeInsets.only(left: 55.0, right: 55.0),
            children: <Widget>[
              SizedBox(
                height: 135.0,
              ),
              logo,
              SizedBox(
                height: 72.0,
              ),
              // forgotLabel,
              // SizedBox(
              //   height: 24.0,
              // ),
              pnlUserName,
              SizedBox(
                height: 36.0,
              ),
              pnlPassword,
              SizedBox(
                height: 48.0,
              ),
              loginButton,
            ],
          ),
        ),
        onWillPop: _onBackPressed,
      ),
    );
    // #endregion
  }
  // #region Event

  Future _login(String sUserId, String sPassword) async {
    if (sUserId == '') {
      show("아이디를 입력해주세요."); // 아이디 미입력
      return;
    }
    if (sPassword == '') {
      show("비밀번호를 입력해주세요."); // 비밀번호 미입력
      return;
    }

    APIService apiService = new APIService();
    apiService.login(_idTextEditController.text).then((value) {
      if (value.user.isNotEmpty) {
        if (_passwordTextEditController.text !=
            value.user.elementAt(0).password) {
          show("비밀번호가 일치하지 않습니다."); // 비밀번호 불일치
        } else {
          var member = UserManager();
          member.user = User(
            organizationCode: value.user.elementAt(0).organizationCode,
            userId: value.user.elementAt(0).userId,
            nameKor: value.user.elementAt(0).nameKor,
            eMail: value.user.elementAt(0).email,
            password: value.user.elementAt(0).password,
            deptCode: value.user.elementAt(0).deptCode,
            deptName: value.user.elementAt(0).deptName,
            gradeCode: value.user.elementAt(0).gradeCode,
            gradeName: value.user.elementAt(0).gradeName,
            mobileTel: value.user.elementAt(0).mobileTel,
          );
          // print(member);
          // print(member.user);
          storage.write(
            key: "login",
            value: "id " +
                _idTextEditController.text.toString() +
                " " +
                "password " +
                _passwordTextEditController.text.toString(),
          );

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => HomePage(
                id: _idTextEditController.text,
                pass: _passwordTextEditController.text,
                member: member,
              ),
            ),
          );
        }
      } else {
        show("등록되지 않는 아이디입니다."); // 등록되지 않은 아이디
      }
    });
  }

  Future show(sMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert(sMessage);
        }); // 비밀번호 불일치
  }

  Widget alert(String sContent) {
    return AlertDialog(
      // title: Text('AlertDialog Title'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(sContent),
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
  }

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
}
