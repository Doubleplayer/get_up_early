import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import '../../data/data.dart' as server;
//定义apk的名称，与下载进度dialog
String apkName = 'flutterApp.apk';
ProgressDialog pr;

httpGet(String address) async {
  var apiUrl = address;
  var value = await http.get(apiUrl);
  return value.body;
}

class Upgrade {
  ///检查是否有更新
  Future<void> checkUpdate(BuildContext context) async {
    //Android , 需要下载apk包
    if (Platform.isAndroid) {
      print('is android');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String localVersion = packageInfo.version;
      print(localVersion);
      //此处使用了dio，封装了httpGet方法，获取服务端中最新的app版本信息
      String versionInfo =
          await httpGet(server.url+"?action=update");
      print(versionInfo);
      print(1);
      if (versionInfo != "") {
        Map<String, dynamic> map = json.decode(versionInfo);
        String serverAndroidVersion = map['android_version'].toString();
        String serverMsg = map['android_msg'].toString();
        String url = map['android_url'].toString();
        print(url);
        print('本地版本: ' + localVersion + ',最新版本: ' + serverAndroidVersion);
        int c = serverAndroidVersion.compareTo(localVersion);
        //如果服务端版本大于本地版本则提示更新
        if (c == 1) {
          showUpdate(context, serverAndroidVersion, serverMsg, url);
        }
      }
    }

    //Ios , 只能跳转到 AppStore , 直接采用url_launcher就可以了
    //android也可以采用此方法，会跳转到手机浏览器中下载
    // if (Platform.isIOS) {
    //   print('is ios');
    //   final url =
    //       "https://itunes.apple.com/cn/app/id1380512641"; // id 后面的数字换成自己的应用 id 就行了

    // }
  }

  ///2.显示更新内容
  Future<void> showUpdate(
      BuildContext context, String version, String data, String url) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('检测到新版本 v$version'),
          content: Text('更新日志：' + '\n' + data + '\n\n' + "是否更新"),
          actions: <Widget>[
            FlatButton(
              child: Text('下次再说'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('立即更新'),
                onPressed: () async {
                  print(url);
                  if (await canLaunch(url)) {
                    await launch(url, forceSafariVC: false);
                  } else {
                    throw 'Could not launch $url';
                  }
                }),
          ],
        );
      },
    );
  }

  // ///3.执行更新操作
  // doUpdate(BuildContext context, String version, String url) async {
  //   //关闭更新内容提示框
  //   Navigator.pop(context);
  //   //获取权限
  //   var per = await checkPermission();
  //   if (per != null && !per) {
  //     return null;
  //   }
  //   //开始下载apk
  //   executeDownload(context, url);
  // }

  // ///4.检查是否有权限
  // Future<bool> checkPermission() async {
  //检查是否已有读写内存权限
  // var status = await Permission.camera.status();
  // print(status);

  // //判断如果还没拥有读写权限就申请获取权限
  // if (status != PermissionStatus.granted) {
  //   var map = await PermissionHandler()
  //       .requestPermissions([PermissionGroup.storage]);
  //   if (map[PermissionGroup.storage] != PermissionStatus.granted) {
  //     return false;
  //   }
  // }
  // return true;
}

//   ///5.下载apk
//   Future<void> executeDownload(BuildContext context, String url) async {
//     //下载时显示下载进度dialog
//     pr = new ProgressDialog(context,
//         type: ProgressDialogType.Download, isDismissible: true, showLogs: true);
//     if (!pr.isShowing()) {
//       pr.show();
//     }
//     //apk存放路径
//     final path = await _apkLocalPath;
//     File file = File(path + '/' + apkName);
//     if (await file.exists()) await file.delete();

//     //下载
//     final taskId = await FlutterDownloader.enqueue(
//         url: url, //下载最新apk的网络地址
//         savedDir: path,
//         fileName: apkName,
//         showNotification: true,
//         openFileFromNotification: true);

//     FlutterDownloader.registerCallback((id, status, progress) {
//       if (status == DownloadTaskStatus.running) {
//         pr.update(progress: progress.toDouble(), message: "下载中，请稍后…");
//       }
//       if (status == DownloadTaskStatus.failed) {
//         if (pr.isShowing()) {
//           pr.hide();
//         }
//       }
//       if (taskId == id && status == DownloadTaskStatus.complete) {
//         if (pr.isShowing()) {
//           pr.hide();
//         }
//         _installApk();
//       }
//     });
//   }

//   //6.安装app
//   Future<Null> _installApk() async {
//     String path = await _apkLocalPath;
//     await OpenFile.open(path + '/' + apkName);
//   }

//   // 获取apk存放地址(外部路径)
//   Future<String> get _apkLocalPath async {
//     final directory = await getExternalStorageDirectory();
//     return directory.path;
//   }
// }
