import 'package:flutter/material.dart';
import 'Tabs/Awards.dart';
import 'Tabs/Home.dart';
import 'Tabs/Orders.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:animations/animations.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'Components/cartoon.dart';
import 'Tabs/MusicPlayer.dart';
class FadeBox extends StatelessWidget {
  final Animation<double> containerGrowAnimation;
  final Animation<Color> fadeScreenAnimation;
  FadeBox({this.containerGrowAnimation, this.fadeScreenAnimation});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return (new Hero(
        tag: "fade",
        child: new Container(
          width: containerGrowAnimation.value < 1 ? screenSize.width : 0.0,
          height: containerGrowAnimation.value < 1 ? screenSize.height : 0.0,
          decoration: new BoxDecoration(
            color: fadeScreenAnimation.value,
          ),
        )));
  }
}

class Tabs extends StatefulWidget {
  final index;
  Tabs({Key key, this.index = 0}) : super(key: key);

  @override
  _TabsState createState() => _TabsState(index);
}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  List _pageList = [
    HomePage(),
    AwardsPage(),
    OrdersPage(),
  ];
  int _currentIndex;

  _TabsState(index) {
    this._currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '肖肖饲养计划',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "MyOwnFonts"),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          color: Colors.white,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.music_note,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(context, CustomRouteJianBian((MusicPlayerPage()))); //要跳转的页面
          },
        ),
      ),

      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: this._pageList[this._currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(255, 239, 239, 1.0),
        type: BottomNavigationBarType.fixed, //配置底部栏可以有多个按钮
        iconSize: 40.0, //Icon大小
        fixedColor: Theme.of(context).primaryColor, //选中的颜色
        currentIndex: this._currentIndex, //配置选中的索引值
        onTap: (int index) {
          setState(() {
            //改变状态，重新渲染
            this._currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("签到", style: TextStyle(fontFamily: "MyOwnFonts")),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text("积分兑换", style: TextStyle(fontFamily: "MyOwnFonts")),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text("兑换订单", style: TextStyle(fontFamily: "MyOwnFonts")),
          ),
        ],
      ),
      drawer: Drawer(
          child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text("还在研发中~"),
        ),
      )),
      // endDrawer: Drawer(
      //   child: Column(
      //     children: [
      //       Row(
      //         children: [
      //           Expanded(
      //             child: UserAccountsDrawerHeader(
      //               accountEmail: Text("1125195347"),
      //               accountName: Text("Doubleplayer"),
      //               currentAccountPicture: CircleAvatar(
      //                 backgroundImage: NetworkImage(
      //                     "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1558349259,3976161526&fm=26&gp=0.jpg"),
      //               ),
      //               decoration: BoxDecoration(
      //                 image: DecorationImage(
      //                     image: NetworkImage(
      //                         "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3863083147,1632168095&fm=11&gp=0.jpg"),
      //                     fit: BoxFit.cover),
      //               ),
      //               otherAccountsPictures: [
      //                 Image.network(
      //                     "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3438893302,3337810097&fm=26&gp=0.jpg"),
      //                 Image.network(
      //                     "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3438893302,3337810097&fm=26&gp=0.jpg"),
      //               ],
      //             ),
      //           )
      //         ],
      //       ),

      //       ListTile(
      //         leading: CircleAvatar(
      //           child: Icon(Icons.home),
      //         ),
      //         title: Text("我的空间"),
      //         onTap: () {
      //           Navigator.of(context).pop();
      //           Navigator.pushNamed(context, "/registerSecondPage");
      //         },
      //       ),
      //       Divider(), //下划线
      //       ListTile(
      //         leading: CircleAvatar(
      //           child: CircleAvatar(
      //             child: Icon(Icons.people),
      //           ),
      //         ),
      //         title: Text("用户中心"),
      //         onTap: () {
      //           Navigator.pushNamed(context, "/userPage");
      //         },
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
