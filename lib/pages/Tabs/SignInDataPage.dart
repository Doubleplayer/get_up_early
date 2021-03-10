import 'dart:convert';
import '../Components/AnimatedDialog.dart';
import 'package:GetUpEarly/pages/update/Update.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animated_card/animated_card.dart';
import 'package:flutter/cupertino.dart';
import '../../data/data.dart' as serverUrl;

final lista = [
  {
    "count": 5,
    "description": "一包薯片",
    "url":
        "https://c-ssl.duitang.com/uploads/item/201908/01/20190801162358_vpvyn.thumb.1000_0.jpg"
  },
  {
    "count": 10,
    "description": "一杯奶茶",
    "url":
        "https://c-ssl.duitang.com/uploads/item/201811/28/20181128103617_ayzyu.thumb.1000_0.jpg"
  },
  {
    "count": 15,
    "description": "一张外卖报销券",
    "url":
        "https://c-ssl.duitang.com/uploads/item/201804/20/20180420111912_d5tmP.thumb.1000_0.jpeg"
  },
  {
    "count": 20,
    "description": "胶带6卷",
    "url":
        "https://c-ssl.duitang.com/uploads/item/201511/02/20151102130205_XfnC2.thumb.1000_0.jpeg"
  },
  {
    "count": 25,
    "description": "汉儿的一封情书",
    "url":
        "https://c-ssl.duitang.com/uploads/item/201604/05/20160405130050_LxH3m.thumb.1000_0.jpeg"
  },
  {
    "count": 40,
    "description": "一件小裙子",
    "url":
        "https://c-ssl.duitang.com/uploads/item/201111/25/20111125192948_52sN3.thumb.1000_0.jpg"
  },
  {
    "count": 45,
    "description": "任意品牌口红一只",
    "url":
        "https://c-ssl.duitang.com/uploads/item/201606/12/20160612234741_Zad4y.thumb.1000_0.jpeg"
  },
  {
    "count": 50,
    "description": "指定汉儿到北京陪你！",
    "url":
        "https://c-ssl.duitang.com/uploads/item/201510/24/20151024132339_ind5e.thumb.1000_0.jpeg"
  },
];

class SignInDataPage extends StatefulWidget {
  SignInDataPage({Key key}) : super(key: key);

  @override
  _SignInDataPageState createState() => _SignInDataPageState();
}

class _SignInDataPageState extends State<SignInDataPage> {
  var result;
  @override
  void initState() {
    // TODO: implement initState
  }

  _getData() async {
    var apiUrl = serverUrl.url;
    var value = await http.get(apiUrl);
    setState(() {
      result = value.body;
    });
    print(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("积分兑换表~", style: TextStyle(fontFamily: "MyOwnFonts"))),
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index) {
          return AnimatedCard(
            direction:
                AnimatedCardDirection.right, //Initial animation direction
            initDelay: Duration(milliseconds: 0), //Delay to initial animation
            duration: Duration(
                seconds: 1, milliseconds: 100), //Initial animation duration
            // onRemove: () =>
            //     lista.removeAt(index), //Implement this action to active dismiss
            curve: Curves.bounceOut, //Animation curve
            child: Container(
              height: 120,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
              padding: EdgeInsets.all(10),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(25)),
                color: Colors.white,
                elevation: 5,
                child: ListTile(
                  title: Text(
                    lista[index]["description"],
                    style: TextStyle(fontFamily: "MyOwnFonts"),
                  ),
                  subtitle: Text("积分：" + lista[index]["count"].toString(),
                      style: TextStyle(fontFamily: "MyOwnFonts")),
                  leading: Container(
                    height: 50,
                    width: 50,
                    child: Hero(
                        tag: index,
                        child: Image.network(lista[index]["url"],
                            fit: BoxFit.cover)),
                  ),
                  onTap: () {
                    showInfo(
                        context,
                        lista[index]["count"].toString(),
                        lista[index]["description"],
                        lista[index]["url"],
                        index);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return InfoPage(
                    //       lista[index]["count"].toString(),
                    //       lista[index]["description"],
                    //       lista[index]["url"],
                    //       index);
                    // }));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// class InfoPage extends StatefulWidget {
//   String scores;
//   String description;
//   String url;
//   int tag;
//   InfoPage(this.scores, this.description, this.url, this.tag);
//   @override
//   _InfoPageState createState() => _InfoPageState();
// }
//
// class _InfoPageState extends State<InfoPage> {
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoAlertDialog(
//       title: Text(widget.description,
//           style: TextStyle(fontFamily: "MyOwnFonts")),
//       content: Column(
//         children: [
//           Hero(
//             tag: widget.tag,
//             child: Image.network(widget.url),
//           ),
//           Text("需要积分：" + widget.scores,
//               style: TextStyle(fontFamily: "MyOwnFonts"))
//         ],
//       ),
//       actions: <Widget>[
//         FlatButton(
//           child: Text('还没想好', style: TextStyle(fontFamily: "MyOwnFonts")),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         FlatButton(
//             child:
//                 Text('就要这个！', style: TextStyle(fontFamily: "MyOwnFonts")),
//             onPressed: () async {
//               Navigator.pop(context);
//               await order(
//                   context, widget.scores, widget.description, widget.url);
//             }),
//       ],
//     );
//   }
// }

void showInfo(BuildContext context, String scores, String description,
    String url, int tag) async {
  showAnimationDialog(
    transitionType: TransitionType.scale,
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(description, style: TextStyle(fontFamily: "MyOwnFonts")),
        content: Column(
          children: [
            Hero(

              tag: tag,
              child: Image.network(url),
            ),
            Text("需要积分：" + scores, style: TextStyle(fontFamily: "MyOwnFonts"))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('还没想好', style: TextStyle(fontFamily: "MyOwnFonts")),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
              child: Text('就要这个！', style: TextStyle(fontFamily: "MyOwnFonts")),
              onPressed: () async {
                Navigator.pop(context);
                await order(context, scores, description, url);
              }),
        ],
      );
    },
  );
}

void order(
    BuildContext context, String scores, String description, String url) async {
  var temp = {
    "type": "ORDER",
    "scores": scores,
    "description": description,
    "url": url
  };
  var result = await http.post(serverUrl.url, body: temp);
  print("1111");
  print(result.body);
  print(result.body.runtimeType);
  if (jsonDecode(result.body) == "FINISH") {
    showDialog(
      context: context,
      builder: (_) {
        return Center(
            child: Container(
          height: 100,
          width: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text('消费成功！\n已经添加到肖肖的订单当中了哦',
              style: TextStyle(
                  fontFamily: "MyOwnFonts",
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none)),
        ));
      },
    );
  } else {
    showDialog(
        context: context,
        builder: (_) {
          return Center(
              child: Container(
            alignment: Alignment.center,
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text('积分不足！肖肖多多早起攒积分吧',
                style: TextStyle(
                    fontFamily: "MyOwnFonts",
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none)),
          ));
        });
  }
}



