import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _loginButtonController;
  Animation<double> animation;
  Animation<double> buttonSqueezeAnimation;
  Animation<double> buttonZoomOut;
  @override
  void initState() {
    //创建动画
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this)
      ..addListener(() {
        if (_loginButtonController.isCompleted) {
          //动画完成，路由到主界面
          Navigator.pushNamed(context, "/tabs");
        }
      });
    buttonSqueezeAnimation = new Tween(
      begin: 320.0,
      end: 70.0,
    ).animate(new CurvedAnimation(
        parent: _loginButtonController, curve: new Interval(0.0, 0.100)))
      ..addListener(() {
          _loginButtonController.stop();

        setState(() {});
      });
    buttonZoomOut = new Tween(
      begin: 70.0,
      end: 1000.0,
    ).animate(new CurvedAnimation(
      parent: _loginButtonController,
      curve: new Interval(
        0.550,
        0.900,
        curve: Curves.bounceOut,
      ),
    ));

    // 执行动画
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: buttonZoomOut.value == 70
          ? const EdgeInsets.only(
              bottom: 50.0,
            )
          : const EdgeInsets.only(top: 0.0, bottom: 0.0),
      child: InkWell(
        child: new Container(
            width: buttonZoomOut.value == 70
                ? buttonSqueezeAnimation.value
                : buttonZoomOut.value,
            height: buttonZoomOut.value == 70 ? 60.0 : buttonZoomOut.value,
            alignment: FractionalOffset.center,
            decoration: new BoxDecoration(
              color: const Color.fromRGBO(247, 64, 106, 1.0),
              borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
            ),
            child: buttonSqueezeAnimation.value > 75.0
                ? new Text(
                    "Sign In",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3,
                    ),
                  )
                : buttonZoomOut.value < 300.0
                    ? new CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : null),
        onTap: () {
          print(111);
          _playAnimation();
        },
      ),
    )));
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
    } on TickerCanceled {}
  }
}
