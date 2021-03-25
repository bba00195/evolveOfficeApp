import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 위젯 정리
class KulsWidget {
  final AppBar appBar = AppBar(
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
      height: 85,
      child: Image.asset(
        'resource/kuls_home.png',
        fit: BoxFit.cover,
      ),
    ),
    toolbarHeight: 70,
  );

  final BottomAppBar bottomNavi = BottomAppBar(
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
