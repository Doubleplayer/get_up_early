import 'package:flutter/material.dart';
import '../pages/Tabs.dart';
import '../pages/Screens/Login/index.dart';
import '../pages/Start.dart';
import '../pages/Tabs/UploadImage.dart';
//配置路由
final routes = {
  '/uploadImage':(context,{arguments})=>HeadImageUploadPage(),
  '/tabs':(context,{arguments})=>Tabs(),
  '/login':(context,{arguments})=>LoginScreen(),
  '/':(context,{arguments})=>StartScreen(),
  // '/login':(context)=>LoginPage(),
  // '/registerFirst':(context)=>RegisterFirstPage(),
  // '/registerSecondPage':(context)=>RegisterSecondPage(),
  // '/registerThirdPage':(context)=>RegisterThirddPage(),
  // '/http':(context)=>HttpPage(),
};
//固定写法
var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    //跳转页面的构造函数不为空

    if (settings.arguments != null) {
      //如果跳转页面时传参数
      final Route route = MaterialPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments),
      );
      return route;
    } else {
      //如果跳转页面时不传参
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context),
      );
      return route;
    }
  }
};
