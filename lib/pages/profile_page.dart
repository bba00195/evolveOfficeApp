import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolveofficeapp/api/api_service_new.dart';
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
  bool hidePasswordNow = true; // Password Hide
  bool hidePasswordNew = true; // Password Hide
  bool hidePasswordConfirm = true; // Password Hide
  //데이터를 이전 페이지에서 전달 받은 정보를 저장하기 위한 변수
  String id;
  String pass;
  UserManager member;
  GlobalKey<FormState> _passwordNowFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _passwordNewFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _passwordConfirmFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _telFormKey = GlobalKey<FormState>();
  final _passwordNowEditController = TextEditingController();
  final _passwordNewEditController = TextEditingController();
  final _passwordConfirmEditController = TextEditingController();
  final _telTextEditController = TextEditingController();
  FocusNode telFocusNode;
  FocusNode passwordNowFocusNode;
  FocusNode passwordNewFocusNode;
  FocusNode passwordConfirmFocusNode;

  final String uploadEndPoint =
      'http://211.213.24.71:8080/Upload/sajin/imgup.jsp';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  bool _isChoosed = false;

  String pPassword;
  int pPassLength;

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
    pPassword = pass;
    pPassLength = pass.length;
    telFocusNode = FocusNode();
    passwordNowFocusNode = FocusNode();
    passwordNewFocusNode = FocusNode();
    passwordConfirmFocusNode = FocusNode();
    _telTextEditController.text = member.user.mobileTel;
    _passwordNowEditController.text = "";
    _passwordNewEditController.text = "";
    _passwordConfirmEditController.text = "";
  }

  _show(String sMessage) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
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

  void _profileSave(String sImg, String sPassword, String sTel) {
    if (tmpFile == null) {
      if (member.user.imgSajin == '') {
        sImg = '';
      }
    }

    APIServiceNew apiServiceNew = new APIServiceNew();
    List<String> sParam = [
      sImg,
      sPassword,
      sTel,
      member.user.organizationCode,
      member.user.userId,
    ];
    apiServiceNew.getUpdate("PROFILE_U2", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          if (value.result.elementAt(0).rsCode == "E") {
            if (value.result.elementAt(0).rsMsg.indexOf("중복") > 0) {
              _show("이미 등록된 내용입니다.");
              return;
            } else {
              _show(value.result.elementAt(0).rsMsg);
            }
          } else {
            _show("프로필 수정이 완료되었습니다.");
            member.user.imgSajin = sImg;
            member.user.password = sPassword;
            member.user.mobileTel = sTel;
          }
        } else {
          _show("등록에 실패하였습니다.");
        }
      });
    });
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

  showImage() {
    return Image(
      image: NetworkImage(
          'http://211.213.24.71:8080/Upload/sajin/' + member.user.imgSajin),
      fit: BoxFit.cover,
      key: ValueKey(new Random().nextInt(100)),
    );
  }

  chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        tmpFile = File(pickedFile.path);
        base64Image = base64Encode(tmpFile.readAsBytesSync());
        _isChoosed = true;
      } else {
        print('No image selected.');
      }
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  upload(String fileName) async {
    var request = http.MultipartRequest('POST', Uri.parse(uploadEndPoint));
    request.files.add(
      http.MultipartFile(
        'filename1',
        tmpFile.readAsBytes().asStream(),
        tmpFile.lengthSync(),
        filename: fileName,
      ),
    );
    var response = await request.send();
    if (response.statusCode == 200) {
      // _show("정보가 수정되었습니다.");
    }
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (tmpFile != null ||
        pPassword != member.user.password ||
        _telTextEditController.text != member.user.mobileTel) {
      String fileName = member.user.userId + ".jpg";
      // if (member.user.imgSajin == '') {
      //   fileName = '';
      // }
      if (tmpFile != null) {
        upload(fileName);
      }
      _profileSave(fileName, pPassword, _telTextEditController.text);
    } else {
      _show("수정할 내용을 입력해주세요.");
      return;
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

  _memberImage() {
    if (_isChoosed) {
      if (tmpFile != null) {
        return DecorationImage(
          image: FileImage(tmpFile),
          fit: BoxFit.cover,
        );
      }
    } else {
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
  }

  showPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
          body: GestureDetector(
            onTap: () {
              passwordNowFocusNode.unfocus();
              passwordNewFocusNode.unfocus();
              passwordConfirmFocusNode.unfocus();
            },
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.45,
                margin: EdgeInsets.only(left: 20, right: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "비밀번호 변경",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: 'NotoSansKR',
                      ),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: AutoSizeText(
                            '현재 비밀번호',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'NotoSansKR',
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Form(
                              key: _passwordNowFormKey,
                              child: TextField(
                                controller: _passwordNowEditController,
                                focusNode: passwordNowFocusNode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePasswordNow = !hidePasswordNow;
                                      });
                                    },
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.4),
                                    icon: Icon(hidePasswordNow
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'NotoSansKR',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                obscureText: hidePasswordNow,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: AutoSizeText(
                            '변경 비밀번호',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'NotoSansKR',
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Form(
                              key: _passwordNewFormKey,
                              child: TextField(
                                controller: _passwordNewEditController,
                                focusNode: passwordNewFocusNode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePasswordNew = !hidePasswordNew;
                                      });
                                    },
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.4),
                                    icon: Icon(hidePasswordNew
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'NotoSansKR',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                obscureText: hidePasswordNew,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: AutoSizeText(
                            '비밀번호 확인',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'NotoSansKR',
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Form(
                              key: _passwordConfirmFormKey,
                              child: TextField(
                                controller: _passwordConfirmEditController,
                                focusNode: passwordConfirmFocusNode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePasswordConfirm =
                                            !hidePasswordConfirm;
                                      });
                                    },
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.4),
                                    icon: Icon(hidePasswordConfirm
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'NotoSansKR',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                obscureText: hidePasswordConfirm,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 22),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5),
                              ),
                              primary: Colors.black54,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              _passwordNowEditController.text = "";
                              _passwordNewEditController.text = "";
                              _passwordConfirmEditController.text = "";
                              hidePasswordNow = true;
                              hidePasswordNew = true;
                              hidePasswordConfirm = true;
                            },
                            child: Text(
                              '닫기',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 22),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5),
                              ),
                              primary: Colors.indigo[900],
                            ),
                            onPressed: () {
                              if (_passwordNowEditController.text == "" ||
                                  _passwordNewEditController.text == "" ||
                                  _passwordConfirmEditController.text == "") {
                                _show("비밀번호를 입력해주세요.");
                              } else {
                                if (_passwordNowEditController.text !=
                                    pPassword) {
                                  _show("현재 비밀번호가 일치하지 않습니다.");
                                } else {
                                  if (_passwordNewEditController.text !=
                                      _passwordConfirmEditController.text) {
                                    _show("변경 비밀번호가 일치하지 않습니다.");
                                  } else {
                                    if (pPassword ==
                                            _passwordNewEditController.text ||
                                        pPassword ==
                                            _passwordConfirmEditController
                                                .text) {
                                      _show("비밀번호가 변경되지 않았습니다.");
                                    } else {
                                      setState(() {
                                        pPassword =
                                            _passwordNewEditController.text;
                                        pPassLength = pPassword.length;
                                        _passwordNowEditController.text = "";
                                        _passwordNewEditController.text = "";
                                        _passwordConfirmEditController.text =
                                            "";
                                      });
                                      Navigator.of(context).pop(true);
                                    }
                                  }
                                }
                              }
                            },
                            child: Text(
                              '변경',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final profileHead = Container(
      width: screenHeight * 0.15,
      height: screenHeight * 0.15,
      margin: EdgeInsets.only(
        left: (screenWidth - (screenHeight * 0.15)) / 2,
        right: (screenWidth - (screenHeight * 0.15)) / 2,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: screenHeight * 0.15,
            height: screenHeight * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenHeight * 0.175),
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              color: Colors.red,
              image: _memberImage(),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1.0,
                  offset: const Offset(2.0, 3.0),
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                )
              ],
            ),
          ),
          Positioned(
            child: Center(
              child: InkWell(
                child: Container(
                  width: screenHeight * 0.05,
                  height: screenHeight * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenHeight * 0.175),
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    color: Colors.blue[300],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.edit,
                      size: screenHeight * 0.03,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: chooseImage,
              ),
            ),
            left: screenHeight * 0.1,
            top: screenHeight * 0.1,
          ),
        ],
      ),
    );

    final profileContent = Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.2,
        right: screenWidth * 0.2,
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
                  fontSize: 14,
                  fontFamily: 'NotoSansKR',
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 3),
                width: screenWidth - (screenWidth * 0.3),
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(
                //       width: 1.0,
                //     ),
                //   ),
                // ),
                child: Text(
                  member.user.nameKor,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              // ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '소속부서',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'NotoSansKR',
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 3),
                width: screenWidth - (screenWidth * 0.3),
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(
                //       width: 1.0,
                //     ),
                //   ),
                // ),
                child: Text(
                  member.user.deptName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              // ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'E-MAIL',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'NotoSansKR',
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 3),
                width: screenWidth - (screenWidth * 0.3),
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(
                //       width: 1.0,
                //     ),
                //   ),
                // ),
                child: Text(
                  member.user.eMail,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
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
                    fontSize: 14,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.only(top: 5, bottom: 5, left: 3),
              //   width: screenWidth - (screenWidth * 0.3),
              //   decoration: BoxDecoration(
              //     border: Border(
              //       bottom: BorderSide(
              //         width: 1.0,
              //       ),
              //     ),
              //   ),
              //   child: Text(
              //     member.user.mobileTel,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 16,
              //       fontFamily: 'NotoSansKR',
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              Container(
                // height: 50,
                width: screenWidth - (screenWidth * 0.3),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                    ),
                  ),
                ),
                child: Form(
                  key: _telFormKey,
                  child: TextField(
                    controller: _telTextEditController,
                    focusNode: telFocusNode,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'NotoSansKR',
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '비밀번호',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
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
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showPassword();
                        },
                        child: Text(
                          hidePassword
                              ? (pPassword).replaceRange(
                                  0, pPassLength, '•' * pPassLength)
                              : pPassword,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      child: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          //           fontSize: 14,
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
          //             fontSize: 16,
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

    final btnSave = Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.2,
        right: screenWidth * 0.2,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 22),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5),
          ),
          primary: Colors.indigo[900],
        ),
        onPressed: startUpload,
        child: Text(
          'SAVE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
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
        pageName: "",
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
                  SizedBox(height: 10),
                  profileHead,
                  // SizedBox(height: 30),
                  // uploadImage,
                  // showImage(),
                  SizedBox(height: 30),
                  profileContent,
                  SizedBox(height: 20),
                  btnSave,
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          telFocusNode.unfocus();
        },
      ),
    );
  }
}
