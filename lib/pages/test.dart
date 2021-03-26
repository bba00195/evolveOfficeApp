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
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      body: Center(
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
            forgotLabel,
            SizedBox(
              height: 24.0,
            ),
            pnlUserName,
            SizedBox(
              height: 36.0,
            ),
            pnlPassword,
            SizedBox(
              height: 48.0,
            ),
          ],
        ),
      ),
    );
    // #endregion
  }
  // #region Event
  // #endregion
}
