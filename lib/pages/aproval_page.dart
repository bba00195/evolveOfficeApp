import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AprovalPage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;
  final bool isUpdate;
  final DateTime updateDate;
  final String startTime;
  final String endTime;
  final String area;
  final String contents;
  final String carType;

  AprovalPage({
    this.id,
    this.pass,
    this.member,
    this.isUpdate,
    this.updateDate,
    this.startTime,
    this.endTime,
    this.area,
    this.contents,
    this.carType,
  });
  @override
  _AprovalPage createState() => new _AprovalPage();
}

class _AprovalPage extends State<AprovalPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final storage = FlutterSecureStorage();
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String pass;
  UserManager member;

  // void _getDailySelect() async {
  //   APIServiceNew apiServiceNew = new APIServiceNew();

  //   List<String> sParam = [];

  //   apiServiceNew.getSelect("DAILY_S1", sParam).then((value) {
  //     setState(() {
  //       // itemCount = 0;
  //       // if (value.dailySelect.isNotEmpty) {
  //       //   dailySelectValue = value.dailySelect;
  //       //   for (var i = 0; i < value.dailySelect.length; i++) {
  //       //     itemCount++;
  //       //   }
  //       // } else {}
  //     });
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;
    super.initState();
  }

  // #메뉴네임
  menuName() {
    return Container(
      color: Color.fromRGBO(244, 242, 255, 1),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: AutoSizeText(
          '휴가원 관리',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'NotoSansKR',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  approvalHead() {
    return Container();
  }

  aprovalList() {
    return Container(
      color: Colors.red,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("김신입"),
                ),
                Expanded(
                  flex: 1,
                  child: Text("연차휴가"),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("김신입"),
                ),
                Expanded(
                  flex: 1,
                  child: Text("연차휴가"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  aprovalForm() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        children: [
          approvalHead(),
          Divider(color: Colors.grey),
          aprovalList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // #region Body
    return Scaffold(
      key: _scaffoldKey,
      appBar: KulsAppBar(
        globalKey: _scaffoldKey,
        id: id,
        pass: pass,
        member: member,
        storage: storage,
      ),
      drawer: KulsDrawer(
        id: id,
        pass: pass,
        member: member,
        storage: storage,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: KulsNavigationBottomBar(
        globalKey: _scaffoldKey,
        id: id,
        pass: pass,
        member: member,
        selectedIndex: 1,
        pageName: "",
      ),
      body: GestureDetector(
        // 포커싱 제거
        onTap: () {
          FocusScope.of(context).unfocus();
          new TextEditingController().clear();
        },
        // Body 컨테이너
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              menuName(),
              SizedBox(height: 10),
              aprovalForm(),
            ],
          ),
        ),
      ),
    );
  }
  // #endregion

}
