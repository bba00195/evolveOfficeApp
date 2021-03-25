import 'package:evolveofficeapp/pages/daily_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:evolveofficeapp/api/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _RotationTransitionExample(),
    );
  }
}

class _RotationTransitionExample extends StatefulWidget {
  _RotationTransitionExampleState createState() =>
      _RotationTransitionExampleState();
}

class _RotationTransitionExampleState extends State<_RotationTransitionExample>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  bool reverse = false;
  bool isLogin = false;

  String userInfo = "";
  static final storage =
      new FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
      value: 0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 600), () {
            _controller.reverse();
            reverse = true;
          });
        }
        if (reverse) {
          Future.delayed(const Duration(milliseconds: 500), () {});
          //비동기로 flutter secure storage 정보를 불러오는 작업.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _asyncMethod();
          });
        }
      });
    Future.delayed(const Duration(milliseconds: 1000), () {
      _controller.forward();
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RotationTransition(
          turns: _animation,
          alignment: Alignment(0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  width: 114,
                  height: 119,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("resource/kuls_logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    userInfo = await storage.read(key: "login");
    print(userInfo);

    //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
    if (userInfo != null) {
      var member = UserManager();

      APIService apiService = new APIService();
      apiService.login(userInfo.split(" ")[1]).then((value) {
        if (value.user.isNotEmpty) {
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
        }

        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => HomePage(
              id: userInfo.split(" ")[1],
              pass: userInfo.split(" ")[3],
              member: member,
            ),
          ),
        );
      });
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }
}
