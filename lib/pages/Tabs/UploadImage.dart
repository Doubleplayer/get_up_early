import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../Components/AnimatedDialog.dart';
import 'package:date_format/date_format.dart';
import '../../data/data.dart' as server;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart'
    as toast; //toast
import 'package:image_picker/image_picker.dart'; //从相册里面选择图片或者拍照获取照片

class HeadImageUploadPage extends StatefulWidget {
  @override
  _HeadImageUploadPageState createState() => _HeadImageUploadPageState();
}

class _HeadImageUploadPageState extends State<HeadImageUploadPage> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _upLoadImage(image); //上传图片
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('上传单词打卡截图~'),
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

//上传图片
  _upLoadImage(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    // FormData formData = new FormData.fromMap({
    //   "file": new MultipartFile.fromFile (new File(path), name)
    // });

    FormData formdata = FormData.fromMap(
      {
        "type": "uploadImage",
        "file": await MultipartFile.fromFile(path, filename: name),
        "time": formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd,' ',HH, ':', nn, ':', ss]),
        "date":formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
      },
    );

    Dio dio = new Dio();
    dio.options.baseUrl = server.url;
    uploading(context);
    var respone = await dio.post<String>("upload", data: formdata);
    Navigator.of(context).pop();
    print("11111111111111111111111111111");
    toast.showToast(
      jsonDecode(respone.data),
      context: context,
      alignment: Alignment.topCenter,
      animation: toast.StyledToastAnimation.slideFromTop,
      reverseAnimation: toast.StyledToastAnimation.slideToTop,
    );
  }
}

void uploading(BuildContext context) async {
  showAnimationDialog(
    transitionType: TransitionType.scale,
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("上传中", style: TextStyle(fontFamily: "MyOwnFonts")),
        content: Center(
          child: CircularProgressIndicator(),
        ),
        actions: <Widget>[],
      );
    },
  );
}
