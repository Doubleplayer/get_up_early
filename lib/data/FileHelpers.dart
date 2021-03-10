import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileHelpers {
  /***
   * 获取应用文档路径
   */
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /***
   * 返回应用文档路径File
   */
  Future<File> get _localFile async {
    final path = await _localPath;
    var file = File('$path/identification.txt');
    print(path);
    try {
      bool exists = await file.exists();
      if (!exists) {
        await file.create();
      }
      return file;
    } catch (e) {
      print(e);
    }
  }

  /***
   * 读取文件中的数据
   */
  Future<String> readFile() async {
    try {
      final file = await _localFile;
      String data = await file.readAsString();
      print(data);
      return data;
    } catch (e) {
      return "error";
    }
  }

  /***
   * 将文字存储到文件中
   */
  Future<File> writeFile(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }
}
