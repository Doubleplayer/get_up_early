import 'dart:convert';
import 'package:GetUpEarly/pages/update/Update.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animated_card/animated_card.dart';
import 'package:flutter/cupertino.dart';
import '../../data/data.dart' as serverUrl;

var lista = [];

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var result;
  @override
  void initState() {
    var url = serverUrl.url + "orders";
    print(url);
    // TODO: implement initState
    http.get(url).then((value) {
      var temp = jsonDecode(value.body);
      setState(() {
        lista = temp;
      });
    });
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
      appBar: AppBar(title: Text("历史订单~",style: TextStyle(fontFamily: "MyOwnFonts")),),
      body: lista.length <= 0
          ? SizedBox()
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                return AnimatedCard(
                  direction:
                      AnimatedCardDirection.right, //Initial animation direction
                  initDelay:
                      Duration(milliseconds: 0), //Delay to initial animation
                  duration: Duration(seconds: 1,milliseconds: 100), //Initial animation duration
                  // onRemove: () => lista.removeAt(
                  //     index), //Implement this action to active dismiss
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
                      child: Row(children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              lista[index]["description"],
                              style: TextStyle(fontFamily: "MyOwnFonts"),
                            ),
                            subtitle: Text(
                                "积分：" + lista[index]["scores"].toString(),
                                style: TextStyle(fontFamily: "MyOwnFonts")),
                            leading: Container(
                              height: 50,
                              width: 50,
                              child: Image.network(lista[index]["url"],
                                  fit: BoxFit.cover),
                            ),
                            onTap: () {
                              // showInfo(context, lista[index]["count"].toString(),
                              //     lista[index]["description"], lista[index]["url"]);
                            },
                          ),
                        ),
                        Padding(child: Text(
                          lista[index]["state"],
                          style: TextStyle(
                              fontFamily: "MyOwnFonts",
                              color: checkState(lista[index]["state"])),
                        ),
                        padding: EdgeInsets.all(10),
                        )
                      ])
                    ),
                  ),
                );
              },
            ),
    );
  }
}

Color checkState(String s) {
  if (s == "处理中")
    return Colors.orange;
  else if (s == "已完成")
    return Colors.green;
  else if (s == "已撤回") return Colors.red;
}
// Future<void> showInfo(
//     BuildContext context, String scores, String description, String url) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return CupertinoAlertDialog(
//         title: Text(description, style: TextStyle(fontFamily: "MyOwnFonts")),
//         content: Column(
//           children: [
//             Image.network(url),
//             Text("需要积分：" + scores, style: TextStyle(fontFamily: "MyOwnFonts"))
//           ],
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('还没想好', style: TextStyle(fontFamily: "MyOwnFonts")),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           FlatButton(
//               child: Text('就要这个！', style: TextStyle(fontFamily: "MyOwnFonts")),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await order(context, scores, description, url);
//               }),
//         ],
//       );
//     },
//   );
// }

// void order(
//     BuildContext context, String scores, String description, String url) async {
// var temp = {
//   "type": "ORDER",
//   "scores": scores,
//   "description": description,
//   "url": url
// };
// var result = await http.post(serverUrl.url, body: temp);
// print("1111");
// print(result.body);
// print(result.body.runtimeType);
// if (jsonDecode(result.body) == "FINISH") {
//   showDialog(
//     context: context,
//     builder: (_) {
//       return Center(
//           child: Container(
//         height: 100,
//         width: 150,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text('消费成功！\n已经添加到肖肖的订单当中了哦',
//             style: TextStyle(
//                 fontFamily: "MyOwnFonts",
//                 fontSize: 20,
//                 color: Colors.black,
//                 decoration: TextDecoration.none)),
//       ));
//     },
//   );
// } else {
//   showDialog(
//       context: context,
//       builder: (_) {
//         return Center(
//             child: Container(
//           alignment: Alignment.center,
//           height: 100,
//           width: 150,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Text('积分不足！肖肖多多早起攒积分吧',
//               style: TextStyle(
//                   fontFamily: "MyOwnFonts",
//                   fontSize: 20,
//                   color: Colors.black,
//                   decoration: TextDecoration.none)),
//         ));
//       });
// }
// }
