import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'styles.dart';
import 'loginAnimation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../../Components/SignUpLink.dart';
import '../../Components/Form.dart';
import '../../Components/SignInButton.dart';
import '../../Components/InputFields.dart';
import '../../Components/WhiteTick.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart' show timeDilation;
import '../../../data/data.dart' as data;
import '../../Tabs.dart';
import '../../Components/cartoon.dart';
import '../../../data/FileHelpers.dart';

var temp = FormContainer();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this)
      ..addListener(() async {
        if (_loginButtonController.isCompleted) {
          var identification = {
            "type": "Login",
            "user": temp.username.text,
            "password": temp.passward.text,
          };
          var result = await http.post(data.url, body: identification);
          if (jsonDecode(result.body) == "SUCCEED") {
            FileHelpers().writeFile(jsonEncode(identification));
            // Navigator.pushNamed(context, '/tabs',);
            Navigator.of(context).pop();
            Navigator.push(context, CustomRouteSlide(Tabs()));
            dispose();
          } else {
            _loginButtonController.reverse();
          }
        }
      });
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    if (temp.username.text == null || temp.username.text == null)
      ;
    else {
      setState(() {
        animationStatus = 1;
      });
      _loginButtonController.forward();
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Are you sure?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/home"),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: null,
              ),
              child: new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                    colors: <Color>[
                      const Color.fromRGBO(162, 146, 199, 0.8),
                      const Color.fromRGBO(51, 51, 63, 0.9),
                    ],
                    stops: [0.2, 1.0],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                  )),
                  child: new ListView(
                    
                    padding: const EdgeInsets.all(0.0),
                    children: <Widget>[
                      new Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Tick(image: null),
                              temp,
                              new SignUp()
                            ],
                          ),
                          animationStatus == 0
                              ? new Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: new InkWell(
                                      onTap: () {
                                        _playAnimation();
                                      },
                                      child: new SignIn()),
                                )
                              : new Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: new InkWell(
                                    onTap: () {
                                      _playAnimation();
                                    },
                                    child: new StaggerAnimation(
                                        buttonController:
                                            _loginButtonController.view),
                                  ),
                                )
                        ],
                      ),
                    ],
                  ))),
        )));
  }
}
