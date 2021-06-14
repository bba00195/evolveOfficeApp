import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolveofficeapp/api/api_service_new.dart';
import 'package:evolveofficeapp/model/daily_model.dart';
import 'package:evolveofficeapp/pages/dailySelect_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:evolveofficeapp/common/common.dart';
import 'package:intl/intl.dart';

class PopUpDailyReply extends StatefulWidget {
  final UserManager member;
  final String sOrganizationCode;
  final String sUserId;
  final String sUserName;
  final String sDeptName;
  final String sDate;
  final String sDailyReport;
  final String sNextReport;
  final int sLikeQty;
  final String sLikeFlag;
  final int sReplyQty;
  final String sLikePerson;

  PopUpDailyReply(
      {this.member,
      this.sOrganizationCode,
      this.sUserId,
      this.sUserName,
      this.sDeptName,
      this.sDate,
      this.sDailyReport,
      this.sNextReport,
      this.sLikeQty,
      this.sLikeFlag,
      this.sReplyQty,
      this.sLikePerson});
  @override
  PopUpDailyReplyState createState() => new PopUpDailyReplyState();
}

class PopUpDailyReplyState extends State<PopUpDailyReply> {
  DailySelectPages _dailySelectPage = DailySelectPages();
  APIServiceNew apiServiceNew = new APIServiceNew();

  double windowHeight;
  double windowWidth;

  UserManager member;
  String sOrganizationCode;
  String sUserId;
  String sUserName;
  String sDeptName;
  String sDate;
  String sDailyReport;
  String sNextReport;
  int sLikeQty;
  String sLikeFlag;
  int sReplyQty;
  String sLikePerson;

  int replyCount = 0;

  List<DailySelectResponseModel> dailySelectValue;
  List<ReplyResponseModel> replyValue;

  Key _replyKey;
  final _replyTextEditController = TextEditingController();
  FocusNode replyFocusNode;

  Key _replyChildKey;
  final _replyChildTextEditController = TextEditingController();
  FocusNode replyChildFocusNode;

  List<bool> replyChildList = [];
  List<bool> replyChildUpdateList = [];
  bool isUpdated = false;

  @override
  void initState() {
    member = widget.member;
    sOrganizationCode = widget.sOrganizationCode;
    sUserId = widget.sUserId;
    sUserName = widget.sUserName;
    sDeptName = widget.sDeptName;
    sDate = widget.sDate;
    sDailyReport = widget.sDailyReport;
    sNextReport = widget.sNextReport;
    sLikeQty = widget.sLikeQty;
    sLikeFlag = widget.sLikeFlag;
    sReplyQty = widget.sReplyQty;
    sLikePerson = widget.sLikePerson;
    replySelect(sOrganizationCode, sUserId, sDate);
    getDailySelect(sDate);
    replyFocusNode = FocusNode();
    replyChildFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _replyTextEditController.dispose();
    _replyChildTextEditController.dispose();
    super.dispose();
  }

  void getDailySelect(String startDate) async {
    List<String> sParam = [
      startDate,
      startDate,
      "WK_DAILYMONTH",
      member.user.userId,
      "",
      sUserId,
      "",
      "",
      member.user.organizationCode
    ];

    apiServiceNew.getSelect("DAILY_S1", sParam).then((value) {
      setState(() {
        if (value.dailySelect.isNotEmpty) {
          dailySelectValue = value.dailySelect;
        } else {}
      });
    });
  }

  void replySelect(String sOrganizationCode, String sUserId, String date) {
    List<String> sParam = [
      sOrganizationCode,
      date,
      sUserId,
      member.user.userId
    ];

    apiServiceNew.getSelect("DAILYREPLY_S1", sParam).then((value) {
      setState(() {
        if (value.reply.isNotEmpty) {
          replyValue = value.reply;
          for (int i = 0; i < replyValue.length; i++) {
            if (replyChildList.length < replyValue.length) {
              replyChildList.add(false);
              replyChildUpdateList.add(false);
            }
          }
        } else {}
      });
    });
  }

  void dailyLike(String sOrganizationCode, String sUserId, String date) {
    setState(() {
      List<String> sParam = [
        sOrganizationCode,
        member.user.userId,
        sUserId,
        date,
      ];

      apiServiceNew.getUpdate("DAILYLIKE_U1", sParam).then((value) {
        if (value.result.isNotEmpty) {
          getDailySelect(sDate);
          replySelect(sOrganizationCode, sUserId, sDate);
        } else {}
      });
    });
  }

  void replyInsert(String sOrganizationCode, String sUserId, String date,
      String sReplyContents) {
    setState(() {
      List<String> sParam = [
        sOrganizationCode,
        date,
        sUserId,
        member.user.userId,
        sReplyContents
      ];

      apiServiceNew.getInsert("DAILYREPLY_I1", sParam).then((value) {
        if (value.result.isNotEmpty) {
          _replyTextEditController.text = "";
        } else {}
      });
    });
  }

  void replyChildInsert(String sOrganizationCode, String sUserId, int sReplyNo,
      String date, String sReplyContents) {
    setState(() {
      List<String> sParam = [
        sOrganizationCode,
        date,
        sUserId,
        member.user.userId,
        sReplyNo.toString(),
        sReplyContents
      ];

      apiServiceNew.getInsert("DAILYREPLY_I2", sParam).then((value) {
        if (value.result.isNotEmpty) {
          getDailySelect(sDate);
          replySelect(sOrganizationCode, sUserId, sDate);
          _replyChildTextEditController.text = "";
        } else {}
      });
    });
  }

  void replyChildUpdate(String sOrganizationCode, String sUserId, int sReplyNo,
      int sGroupNo, String date, String sReplyContents) {
    setState(() {
      List<String> sParam = [
        sReplyContents,
        sOrganizationCode,
        date,
        sUserId,
        member.user.userId,
        sReplyNo.toString(),
        sGroupNo.toString()
      ];

      apiServiceNew.getUpdate("DAILYREPLY_U1", sParam).then((value) {
        if (value.result.isNotEmpty) {
          getDailySelect(sDate);
          replySelect(sOrganizationCode, sUserId, sDate);
          _replyChildTextEditController.text = "";
        } else {}
      });
    });
  }

  void replyDelete(String sOrganizationCode, String date, String sUserId,
      int sReplyNo, int sGroupNo) {
    setState(() {
      List<String> sParam = [
        sOrganizationCode,
        date,
        sUserId,
        member.user.userId,
        sReplyNo.toString(),
        sGroupNo.toString(),
      ];

      apiServiceNew.getDelete("DAILYREPLY_D1", sParam).then((value) {
        if (value.result.isNotEmpty) {
          getDailySelect(sDate);
          replySelect(sOrganizationCode, sUserId, sDate);
          show("댓글이 정상적으로 삭제되었습니다.");
        } else {}
      });
    });
  }

  void replyLike(String sOrganizationCode, String sUserId, String date,
      int sReplyNo, int sGroupNo) {
    setState(() {
      List<String> sParam = [
        sOrganizationCode,
        member.user.userId,
        sReplyNo.toString(),
        sGroupNo.toString(),
        sUserId,
        date,
      ];

      apiServiceNew.getUpdate("REPLYLIKE_U1", sParam).then((value) {
        if (value.result.isNotEmpty) {
          getDailySelect(sDate);
          replySelect(sOrganizationCode, sUserId, sDate);
        } else {}
      });
    });
  }

  cardLikeNReplyIn(String sOrganizationCode, String sUserId, String sDate,
      String sLikeFlag) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: sLikeFlag == 'Y'
                          ? Icon(Icons.favorite, color: Colors.pink)
                          : Icon(Icons.favorite_border, color: Colors.grey),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        '좋아요',
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                dailyLike(sOrganizationCode, sUserId, sDate);
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Icon(
                        Icons.message_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text('댓글 달기'),
                    ),
                  ],
                ),
              ),
              onTap: () {
                replyFocusNode.requestFocus();
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: Text(''),
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage memberImage(String sUserImg) {
    if (sUserImg != "" && sUserImg != null) {
      return DecorationImage(
        image:
            NetworkImage('http://211.213.24.71:8080/Upload/sajin/' + sUserImg),
        fit: BoxFit.cover,
      );
    } else {
      return DecorationImage(
        image: AssetImage('resource/person.png'),
        fit: BoxFit.cover,
      );
    }
  }

  replyTable() {
    if (replyValue != null && replyValue.length > 0) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int i = 0; i < replyValue.length; i++)
              replyRow(
                  replyValue.elementAt(i).organizationCode,
                  replyValue.elementAt(i).workDate,
                  replyValue.elementAt(i).userId,
                  replyValue.elementAt(i).replyId,
                  replyValue.elementAt(i).userNameKor,
                  replyValue.elementAt(i).uploadImgSajin,
                  replyValue.elementAt(i).replyNo,
                  replyValue.elementAt(i).groupNo,
                  replyValue.elementAt(i).depth,
                  replyValue.elementAt(i).replyContents,
                  replyValue.elementAt(i).likeQty,
                  replyValue.elementAt(i).likeFlag,
                  replyValue.elementAt(i).creationDate,
                  i),
            SizedBox(height: 50),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  replyRow(
      String organizationCode,
      String workDate,
      String userId,
      String replyId,
      String userNameKor,
      String uploadImgSajin,
      int replyNo,
      int groupNo,
      int depth,
      String replyContents,
      int likeQty,
      String likeFlag,
      String creationDate,
      int replyCount) {
    return Container(
      margin: EdgeInsets.only(
        left: depth == 1 ? windowWidth * 0.1 : 0,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Visibility(
            visible: !replyChildUpdateList[replyCount],
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: windowWidth * 0.1,
                      height: windowWidth * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(windowWidth * 0.05),
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1,
                        ),
                        image: memberImage(uploadImgSajin),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minWidth: windowWidth * 0.5,
                        maxWidth:
                            depth == 1 ? windowWidth * 0.5 : windowWidth * 0.65,
                      ),
                      padding: EdgeInsets.only(
                          left: 10, top: 5, bottom: 5, right: 5),
                      margin: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        // border: Border.all(
                        //   color: Colors.grey,
                        //   width: 1,
                        // ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            userNameKor,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            minFontSize: 10,
                          ),
                          AutoSizeText(
                            replyContents,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'NotoSansKR',
                            ),
                            minFontSize: 10,
                          ),
                        ],
                      ),
                    ),
                    if (likeQty > 0)
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6.0,
                              offset: const Offset(0.0, 3.0),
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.pink,
                            ),
                            SizedBox(width: 5),
                            AutoSizeText(
                              likeQty.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'NotoSansKR',
                              ),
                              maxLines: 1,
                              minFontSize: 10,
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      width: windowWidth * 0.1,
                    ),
                    Expanded(
                      flex: 2,
                      child: AutoSizeText(
                        creationDate,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'NotoSansKR',
                        ),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          replyLike(organizationCode, userId, workDate, replyNo,
                              groupNo);
                        },
                        child: AutoSizeText(
                          '좋아요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: likeFlag == "Y"
                                ? Colors.blue[700]
                                : Colors.black,
                            fontSize: 12,
                            fontFamily: 'NotoSansKR',
                          ),
                          maxLines: 1,
                          minFontSize: 8,
                        ),
                      ),
                    ),
                    if (depth == 0)
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isUpdated = false;
                              _replyChildTextEditController.text = "";
                              replyChildList[replyCount] =
                                  !replyChildList[replyCount];
                              for (int i = 0; i < replyChildList.length; i++) {
                                if (i != replyCount) {
                                  replyChildList[i] = false;
                                }
                                replyChildUpdateList[i] = false;
                              }
                              replyChildFocusNode.requestFocus();
                            });
                          },
                          child: AutoSizeText(
                            '댓글 달기',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'NotoSansKR',
                            ),
                            maxLines: 1,
                            minFontSize: 8,
                          ),
                        ),
                      ),
                    if (replyId == member.user.userId)
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              for (int i = 0; i < replyChildList.length; i++) {
                                replyChildList[i] = false;
                              }
                              replyChildList[replyCount] =
                                  !replyChildList[replyCount];

                              for (int i = 0; i < replyChildList.length; i++) {
                                replyChildUpdateList[i] = false;
                              }
                              replyChildUpdateList[replyCount] = true;

                              replyChildFocusNode.requestFocus();
                              _replyChildTextEditController.text =
                                  replyContents;
                              isUpdated = true;
                            });
                          },
                          child: AutoSizeText(
                            '수정',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'NotoSansKR',
                            ),
                            maxLines: 1,
                            minFontSize: 8,
                          ),
                        ),
                      ),
                    if (replyId == member.user.userId)
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            showMessage(organizationCode, workDate, userId,
                                replyNo, groupNo);
                          },
                          child: AutoSizeText(
                            '삭제',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'NotoSansKR',
                            ),
                            maxLines: 1,
                            minFontSize: 8,
                          ),
                        ),
                      ),
                    if (userId != member.user.userId)
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                    if (depth == 1)
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: replyChildList[replyCount],
            child: Container(
              margin: EdgeInsets.only(
                top: 5,
                left: isUpdated ? 0 : windowWidth * 0.1,
              ),
              constraints: BoxConstraints(
                minHeight: windowWidth * 0.1,
                maxHeight: windowWidth * 0.25,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: windowWidth * 0.1,
                        height: windowWidth * 0.1,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(windowWidth * 0.05),
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1,
                          ),
                          image: memberImage(member.user.imgSajin),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          height: windowWidth * 0.2,
                          child: Form(
                            key: _replyChildKey,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _replyChildTextEditController,
                              focusNode: replyChildFocusNode,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '댓글을 입력하세요.',
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: Colors.indigo[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (_replyChildTextEditController.text == "") {
                                show("댓글 내용을 입력해주세요.");
                                return;
                              } else {
                                if (isUpdated) {
                                  replyChildUpdate(
                                      organizationCode,
                                      userId,
                                      replyNo,
                                      groupNo,
                                      workDate,
                                      _replyChildTextEditController.text);
                                  replySelect(
                                      sOrganizationCode, sUserId, sDate);
                                } else {
                                  replyChildInsert(
                                      organizationCode,
                                      userId,
                                      replyNo,
                                      workDate,
                                      _replyChildTextEditController.text);
                                  replySelect(
                                      sOrganizationCode, sUserId, sDate);
                                }
                                isUpdated = false;
                                replyChildList[replyCount] = false;
                                replyChildUpdateList[replyCount] = false;
                              }
                            },
                            child: Text(
                              isUpdated ? '수정' : '등록',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        width: windowWidth * 0.1,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isUpdated = false;
                            _replyChildTextEditController.text = "";
                            replyChildList[replyCount] =
                                !replyChildList[replyCount];
                            for (int i = 0; i < replyChildList.length; i++) {
                              if (i != replyCount) {
                                replyChildList[i] = false;
                              }
                              replyChildUpdateList[i] = false;
                            }
                            replyChildFocusNode.requestFocus();
                          });
                        },
                        child: AutoSizeText(
                          '취소',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'NotoSansKR',
                          ),
                          maxLines: 1,
                          minFontSize: 8,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  show(String sMessage) {
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

  showMessage(
    String organizationCode,
    String workDate,
    String userId,
    int replyNo,
    int groupNo,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text("이 댓글을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop(true);
                replyDelete(
                    organizationCode, workDate, userId, replyNo, groupNo);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    windowHeight = screenHeight;
    windowWidth = screenWidth;

    if (dailySelectValue != null) {
      sLikeQty = dailySelectValue.elementAt(0).likeQty;
      sReplyQty = dailySelectValue.elementAt(0).replyQty;
      sLikeFlag = dailySelectValue.elementAt(0).likeFlag;
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
      body: GestureDetector(
        onTap: () {
          replyFocusNode.unfocus();
          replyChildFocusNode.unfocus();
        },
        child: Center(
          child: Container(
            height: screenHeight * 0.85,
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        child: Icon(Icons.close, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _dailySelectPage.cardColor(sDeptName),
                        // borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(10),
                        //   topRight: Radius.circular(10),
                        // ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AutoSizeText(
                            sUserName,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            maxFontSize: 14,
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              child: AutoSizeText(
                                '[' + sDeptName + ']',
                                style: TextStyle(
                                  color: Colors.black87,
                                  // fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                maxFontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: AutoSizeText(
                              DateFormat('yyyy. MM. dd')
                                  .format(DateTime.parse(sDate)),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                              maxFontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300],
                            width: 1,
                          ),
                        ),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _dailySelectPage.cardContentHeader("금일업무 내용"),
                          _dailySelectPage.cardContent(sDailyReport),
                          _dailySelectPage.cardContentHeader("익일업무 내용"),
                          _dailySelectPage.cardContent(sNextReport),
                          // Divider(
                          //   color: Colors.grey,
                          // ),
                          _dailySelectPage.cardLikeQty(
                              sOrganizationCode,
                              sUserId,
                              sUserName,
                              sDeptName,
                              sDate,
                              sDailyReport,
                              sNextReport,
                              sLikeQty,
                              sLikeFlag,
                              sReplyQty,
                              sLikePerson),
                          Divider(
                            color: Colors.grey,
                          ),
                          cardLikeNReplyIn(
                              sOrganizationCode, sUserId, sDate, sLikeFlag),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300],
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                              border: Border.all(
                                color: Colors.grey[300],
                                width: 1,
                              ),
                              image: memberImage(member.user.imgSajin),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              height: screenWidth * 0.2,
                              child: Form(
                                key: _replyKey,
                                child: TextField(
                                  autofocus: false,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: _replyTextEditController,
                                  focusNode: replyFocusNode,
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
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: '댓글을 입력하세요.',
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'NotoSansKR',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                color: Colors.indigo[800],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (_replyTextEditController.text == "") {
                                    show("댓글 내용을 입력해주세요.");
                                    return;
                                  } else {
                                    replyInsert(sOrganizationCode, sUserId,
                                        sDate, _replyTextEditController.text);
                                    replySelect(
                                        sOrganizationCode, sUserId, sDate);
                                  }
                                },
                                child: Text(
                                  '등록',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'NotoSansKR',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    replyTable(),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
