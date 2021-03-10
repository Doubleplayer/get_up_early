import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

String host = '47.102.213.168';
String url = "http://47.102.213.168:10086/";
String workingPath = dirname(Platform.script.toFilePath());
var conn = MySqlConnection.connect(ConnectionSettings(
    host: '47.102.213.168',
    port: 3306,
    user: 'lsh',
    db: 'exp',
    password: 'lsh2xmz..'));

Future<String> getData({@required String action}) async {
  var apiUrl = url + '?' + action;
  var value = await http.get(apiUrl);
  var result = value.body;
  print(result);
  return result;
}
