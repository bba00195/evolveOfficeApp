import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:evolveofficeapp/common/kulsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';

class ProfilePage extends StatefulWidget {
  //로그인 정보를 이전 페이지에서 전달 받기 위한 변수
  final String id;
  final String pass;
  final UserManager member;

  ProfilePage({this.id, this.pass, this.member});
  @override
  _ProfilePage createState() => new _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final storage = FlutterSecureStorage();
  bool hidePassword = true; // Password Hide
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String pass;
  UserManager member;
  GlobalKey<FormState> _telFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final _telTextEditController = TextEditingController();
  final _passwordEditController = TextEditingController();
  FocusNode telFocusNode;
  FocusNode passwordFocusNode;

  static final String uploadEndPoint =
      'http://localhost/flutter_test/upload_image.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    id = widget.id; //widget.id는 LogOutPage에서 전달받은 id를 의미한다.
    pass = widget.pass;
    member = widget.member;
    telFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    _telTextEditController.text = member.user.mobileTel;
    _passwordEditController.text = member.user.password;

    _show(String sMessage) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(sMessage),
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

    final menuName = AppBar(
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      actions: [],
      backgroundColor: Color.fromRGBO(248, 246, 255, 1),
      centerTitle: true,
      title: Text(
        'Profile',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'NotoSansKR',
          fontWeight: FontWeight.w600,
        ),
      ),
      toolbarHeight: 75,
      bottomOpacity: 0.0,
      elevation: 0.0,
    );

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

    final pageHead = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(121, 102, 254, 1),
            width: 2.0,
          ),
        ),
      ),
      height: 90,
      child: Center(
        child: Text(
          'Profile',
          style: TextStyle(
            color: Color.fromRGBO(121, 102, 254, 1),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    final profileHead = Container(
      child: Center(
        child: Container(
          width: screenHeight * 0.25,
          height: (screenHeight * 0.25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenHeight * 0.05),
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            color: Colors.red,
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
      ),
    );

    chooseImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          tmpFile = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }

    final uploadImage = Container(
      child: TextButton(
        onPressed: () async {
          final picker = ImagePicker();
          final pickedFile = await picker.getImage(source: ImageSource.gallery);
          setState(() {
            if (pickedFile != null) {
              tmpFile = File(pickedFile.path);
            } else {
              print('No image selected.');
            }
          });
        },
        child: Text('Choose Image'),
      ),
    );

    final profileContent = Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '사용자명',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'NotoSansKR',
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 3),
                width: screenWidth - (screenWidth * 0.3),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  member.user.nameKor,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              // ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'E-MAIL',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'NotoSansKR',
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 3),
                width: screenWidth - (screenWidth * 0.3),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  member.user.eMail,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  '전화번호',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 3),
                width: screenWidth - (screenWidth * 0.3),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  member.user.mobileTel,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Container(
              //   // height: 50,
              //   width: screenWidth - (screenWidth * 0.3),
              //   decoration: BoxDecoration(
              //     border: Border(
              //       bottom: BorderSide(
              //         width: 1.0,
              //       ),
              //     ),
              //   ),
              //   child: Form(
              //     key: _telFormKey,
              //     child: TextField(
              //       controller: _telTextEditController,
              //       focusNode: telFocusNode,
              //       decoration: InputDecoration(
              //         contentPadding:
              //             EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: Colors.transparent,
              //           ),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(
              //             color: Colors.transparent,
              //           ),
              //         ),
              //         filled: true,
              //         fillColor: Colors.white,
              //       ),
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontFamily: 'NotoSansKR',
              //         color: Colors.black,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          // SizedBox(height: 20),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       child: Text(
          //         '비밀번호',
          //         textAlign: TextAlign.left,
          //         style: TextStyle(
          //           color: Colors.grey,
          //           fontSize: 16,
          //           fontFamily: 'NotoSansKR',
          //         ),
          //       ),
          //     ),
          //     Container(
          //       // height: 50,
          //       width: screenWidth - (screenWidth * 0.3),
          //       decoration: BoxDecoration(
          //         border: Border(
          //           bottom: BorderSide(
          //             width: 1.0,
          //           ),
          //         ),
          //       ),
          //       child: Form(
          //         key: _passwordFormKey,
          //         child: TextField(
          //           controller: _passwordEditController,
          //           focusNode: passwordFocusNode,
          //           decoration: InputDecoration(
          //             contentPadding:
          //                 EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          //             enabledBorder: OutlineInputBorder(
          //               borderSide: BorderSide(
          //                 color: Colors.transparent,
          //               ),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderSide: BorderSide(
          //                 color: Colors.transparent,
          //               ),
          //             ),
          //             filled: true,
          //             fillColor: Colors.white,
          //             suffixIcon: IconButton(
          //               onPressed: () {
          //                 setState(() {
          //                   hidePassword = !hidePassword;
          //                 });
          //               },
          //               color: Theme.of(context).accentColor.withOpacity(0.4),
          //               icon: Icon(hidePassword
          //                   ? Icons.visibility_off
          //                   : Icons.visibility),
          //             ),
          //           ),
          //           style: TextStyle(
          //             fontSize: 20,
          //             fontFamily: 'NotoSansKR',
          //             color: Colors.black,
          //             fontWeight: FontWeight.w600,
          //           ),
          //           obscureText: hidePassword,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );

    // #region Body
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      // appBar: menuName,
      drawer: KulsDrawer(
        id: id,
        pass: pass,
        member: member,
        storage: storage,
      ),
      bottomNavigationBar: KulsNavigationBottomBar(
        globalKey: _scaffoldKey,
        id: id,
        pass: pass,
        member: member,
        selectedIndex: 2,
      ),
      body: GestureDetector(
        child: Center(
          child: Container(
            color: Color.fromRGBO(248, 246, 255, 1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              // padding: EdgeInsets.only(
              //   top: 70,
              // ),
              child: ListView(
                children: [
                  pageHead,
                  SizedBox(height: 30),
                  profileHead,
                  // SizedBox(height: 30),
                  // uploadImage,
                  SizedBox(height: 30),
                  profileContent,
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          telFocusNode.unfocus();
          passwordFocusNode.unfocus();
        },
      ),
    );
  }
}
