import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import '../update/Update.dart' as upgrade;
import '../../data/data.dart' as data;
import 'UploadImage.dart';
import 'package:date_format/date_format.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer _timer;
  String now = '';
  final GlobalKey<LikeButtonState> _globalKey = GlobalKey<LikeButtonState>();
  var get_up_success_sign;
  var result;
  // var db=await data.conn;
  @override
  void initState() {
    now = formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    startTimer();
    print("11111");
    super.initState();
    String temp = '0';
    _getData(action: "getScores").then((value) => scores = jsonDecode(value));
    _getData(action: 'getPersistantSignInDays')
        .then((value) => getSignInDays = jsonDecode(value));
    upgrade.Upgrade().checkUpdate(context);
  }

  String scores = "";
  String getSignInDays = '';
  @override
  _HomePageState() {}
  updateScores() async {
    String temp = '0';
    temp = await _getData(action: "getScores");
    setState(() {
      scores = jsonDecode(temp);
      print("1231231+$scores");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (v) {
      now = formatDate(
          DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
      setState(() {});
    });
    return _timer;
  }

  Future<String> _getData({String action = '', String path = ''}) async {
    var apiUrl = data.url + path;
    if (action == '')
      ;
    else {
      apiUrl = apiUrl + "?action=" + action;
    }
    var value = await http.get(apiUrl);
    setState(() {
      result = value.body;
    });
    print("121312");
    return result;
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    ///

    String res = await _getData(action: "getUp");
    print(res);
    res = jsonDecode(res);
    bool success = true;
    if (res == "SUCCEED") {
      success = true;
      updateScores();
      showToast("肖肖真棒！今天又早起了！",
          context: context,
          alignment: Alignment.topCenter,
          animation: StyledToastAnimation.slideFromTop,
          reverseAnimation: StyledToastAnimation.slideToTop);
      return !isLiked;
    } else if (res == "REPEAT") {
      showToast("肖肖今天已经签到过了哦~",
          context: context,
          alignment: Alignment.topCenter,
          animation: StyledToastAnimation.slideFromTop,
          reverseAnimation: StyledToastAnimation.slideToTop);
      success = false;
    } else if (res == "WRONG TIME") {
      showToast("还没到签到时间哦~",
          context: context,
          alignment: Alignment.topCenter,
          animation: StyledToastAnimation.slideFromTop,
          reverseAnimation: StyledToastAnimation.slideToTop);
      success = false;
    }

    print("success:${success},isLiked:${isLiked}");

    /// if failed, you can do nothing
    return success ? !isLiked : isLiked;

    return !isLiked;
  }

  _getInitial() {
    setState(() {
      _getData(action: 'getPersistantSignInDays')
          .then((value) => getSignInDays = jsonDecode(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/start.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Container(
            child: Text(
              now,
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: "MyOwnFonts",
                  color: Theme.of(context).primaryColor),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(children: [
              Text(
                "当前积分",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: "MyOwnFonts",
                    color: Theme.of(context).primaryColor),
              ),
              InkWell(
                child: Text(
                  scores,
                  style: TextStyle(
                      fontSize: 160,
                      fontFamily: "MyOwnFonts",
                      color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                child: Text(
                  "早起签到",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "MyOwnFonts",
                      color: Theme.of(context).primaryColor),
                ),
                onTap: () async {
                  await onLikeButtonTapped(true);
                },
              ),
            ]),
            Column(children: [
              Text(
                "连续打卡天数",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: "MyOwnFonts",
                    color: Colors.orangeAccent),
              ),
              InkWell(
                child: Text(
                  getSignInDays,
                  style: TextStyle(
                      fontSize: 160,
                      fontFamily: "MyOwnFonts",
                      color: Colors.orangeAccent),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                child: Text(
                  "背单词打卡",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "MyOwnFonts",
                      color: Colors.orangeAccent),
                ),
                onTap: () async {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HeadImageUploadPage()))
                      .then((value) => _getInitial());
                },
              ),
            ]),
          ]),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
