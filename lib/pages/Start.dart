/**
 * 广告页，3秒自动跳转到首页
 */
import 'dart:async';
import 'dart:io';
import 'package:GetUpEarly/pages/Screens/Home/styles.dart';
import 'package:flutter/material.dart';
import 'Components/cartoon.dart';
import 'Screens/Login/index.dart';
import 'package:http/http.dart' as http;
import '../data/data.dart' as data;
import 'dart:convert';
import 'Tabs.dart';
import '../data/FileHelpers.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => new _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Timer _timer;
  int count = 1;

  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 1);
    new Timer(_duration, () {
      // 空等1秒之后再计时
      _timer = new Timer.periodic(const Duration(milliseconds: 1000), (v) {
        count--;
        if (count == 0) {
          navigationPage();
        } else {
          setState(() {});
        }
      });
      return _timer;
    });
  }

  void navigationPage() async {
    _timer.cancel();
    File indentification_file;
    var file = FileHelpers();
    String temp = await file.readFile();
    if (temp != '') {
      var identification = jsonDecode(temp);
      var result = await http.post(data.url, body: identification);
      if (jsonDecode(result.body) == "SUCCEED") {
        // Navigator.pushNamed(context, '/tabs',);
        Navigator.of(context).pop();
        Navigator.push(context, CustomRouteJianBian(Tabs()));
      } else {
        Navigator.of(context).pop();
        Navigator.push(context, CustomRouteJianBian((LoginScreen()))); //要跳转的页面
      }
    } else {
      Navigator.of(context).pop();
      Navigator.push(context, CustomRouteJianBian((LoginScreen()))); //要跳转的页面
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: const Alignment(1.0, -1.0), // 右上角对齐
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/start.jpg"), fit: BoxFit.cover),
          ),
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Text(
              "肖\n肖\n饲\n养\n计\n划",
              style: TextStyle(
                  letterSpacing: 30.0,
                  decoration: TextDecoration.none,
                  fontFamily: "MyOwnFonts",
                  color: Colors.white,
                  fontSize: 70),
            ),
          ),
        ),

//         new Padding(
//           padding: new EdgeInsets.fromLTRB(0.0, 30.0, 10.0, 0.0),
//           child: new FlatButton(
//             onPressed: () {
//               navigationPage();
//             },
// //            padding: EdgeInsets.all(0.0),
//             color: Colors.grey,
//             child: new Text(
//               "$count 跳过广告",
//               style: new TextStyle(color: Colors.white, fontSize: 12.0),
//             ),
//           ),
//         )
      ],
    );
  }
}
