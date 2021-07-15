// #region Import
import 'dart:async';
import 'dart:ui';
import 'package:evolveofficeapp/api/api_service_new.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:evolveofficeapp/model/login_model.dart';
import 'package:evolveofficeapp/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// #endregion

class LoginPage extends StatefulWidget {
  // final String token;

  // LoginPage({
  //   this.token,
  // });
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true; // Password Hide

  final _idTextEditController = TextEditingController();
  final _passwordTextEditController = TextEditingController();

  GlobalKey<FormState> _idFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  FocusNode idFocusNode;
  FocusNode passwordFocusNode;
  // Future<ResultModel> userInfo;
  // String token;

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
    idFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    // token = widget.token;
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

    // #region IdTextField
    final txtUserName = Material(
      borderRadius: BorderRadius.circular(5.0),
      child: Form(
        key: _idFormKey,
        child: TextField(
          autofocus: false,
          controller: _idTextEditController,
          focusNode: idFocusNode,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            // contentPadding: EdgeInsets.fromLTRB(80.0, 8.0, 0.0, 8.0),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Username',
          ),
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'NotoSansKR',
          ),
        ),
      ),
      elevation: 6.0,
      shadowColor: Color.fromRGBO(121, 102, 254, 0.3),
    );
    // #endregion

    // #region PasswordTextField
    final txtPassword = Material(
      borderRadius: BorderRadius.circular(5.0),
      child: Form(
        key: _passwordFormKey,
        child: TextField(
          autofocus: false,
          controller: _passwordTextEditController,
          focusNode: passwordFocusNode,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            // contentPadding: EdgeInsets.fromLTRB(80.0, 8.0, 0.0, 8.0),
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
              icon:
                  Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'NotoSansKR',
          ),
          obscureText: hidePassword,
        ),
      ),
      elevation: 6.0,
      shadowColor: Color.fromRGBO(121, 102, 254, 0.3),
    );
    // #endregion

    // #region IdPanel
    final pnlUserName = Container(
      height: 65,
      child: Stack(
        alignment: AlignmentDirectional.center, //alignment:new Alignment(x, y)
        children: <Widget>[
          txtUserName,
          // userIcon,
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
          // lockIcon,
        ],
      ),
    );
    // #endregion

    // #region ButtonLogin
    final loginButton = Container(
      height: 50,
      // padding: EdgeInsets.only(left: 35.0, right: 35.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5),
          ),
          primary: Color.fromRGBO(121, 102, 254, 1.0),
        ),
        onPressed: () {
          _login(_idTextEditController.text, _passwordTextEditController.text);
          // show(_passwordTextEditController.text);

          // _log(_idTextEditController.text, _passwordTextEditController.text);
        },
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
    // #endregion
    //

    // #region Label
    final forgotLabel = Container(
      alignment: Alignment.center,
      child: Text(
        ' Login to your account',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    // #endregion

    // #endregion

    // #region Body

    return Scaffold(
      bottomNavigationBar: KulsBottomBar(),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      body: WillPopScope(
        child: GestureDetector(
          child: Center(
            child: ListView(
              shrinkWrap: false,
              padding: EdgeInsets.only(left: 55.0, right: 55.0),
              children: <Widget>[
                SizedBox(height: 135.0),
                logo,
                SizedBox(height: 48.0),
                forgotLabel,
                SizedBox(height: 36.0),
                pnlUserName,
                SizedBox(height: 36.0),
                pnlPassword,
                SizedBox(height: 48.0),
                loginButton,
                // hiddenLogin
              ],
            ),
          ),
          onTap: () {
            _idFocusChange(_idFormKey.currentContext, idFocusNode);
            _passwordFocusChange(
                _passwordFormKey.currentContext, passwordFocusNode);
          },
        ),
        onWillPop: _onBackPressed,
      ),
    );
    // #endregion
  }
  // #region Event
  //
  //
  //
  //
  //final

  _login(String sUserId, String sPassword) async {
    if (sUserId == '') {
      show("아이디를 입력해주세요."); // 아이디 미입력
      return;
    }
    if (sPassword == '') {
      show("비밀번호를 입력해주세요."); // 비밀번호 미입력
      return;
    }
    List<String> sParam = [sUserId];

    APIServiceNew apiServiceNew = new APIServiceNew();
    apiServiceNew.getSelect("LOGIN_S1", sParam).then((value) {
      if (value.user.isNotEmpty) {
        if (_passwordTextEditController.text !=
            value.user.elementAt(0).password) {
          show("비밀번호가 일치하지 않습니다."); // 비밀번호 불일치
        } else {
          // tokenUpdate(sUserId, token);
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
            imgSajin: value.user.elementAt(0).imgSajin,
            // token: value.user.elementAt(0).token,
          );
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

  // void tokenUpdate(String sUserId, String sToken) async {
  //   setState(() {
  //     APIServiceNew apiServiceNew = new APIServiceNew();
  //     List<String> sParam = [
  //       sToken,
  //       sUserId,
  //     ];
  //     apiServiceNew.getUpdate("LOGIN_U1", sParam).then((value) {
  //       if (value.result.isNotEmpty) {
  //       } else {}
  //     });
  //   });
  // }

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

  void _idFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
  }

  void _passwordFocusChange(BuildContext context, FocusNode currentFocus) {
    currentFocus.unfocus(); //현재 FocusNode의 포커스를 지운다.
  }
}
