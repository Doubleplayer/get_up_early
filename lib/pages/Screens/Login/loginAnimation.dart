import 'package:flutter/material.dart';
import 'dart:async';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController})
      : buttonSqueezeanimation = new Tween(
          begin: 320.0,
          end: 70.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.3,
            ),
          ),
        ),
        // buttomZoomOut = new Tween(
        //   begin: 70.0,
        //   end: 1000.0,
        // ).animate(
        //   new CurvedAnimation(
        //     parent: buttonController,
        //     curve: new Interval(
        //       0.550,
        //       0.999,
        //       curve: Curves.bounceOut,
        //     ),
        //   ),
        // ),
        // containerCircleAnimation = new EdgeInsetsTween(
        //   begin: const EdgeInsets.only(bottom: 50.0),
        //   end: const EdgeInsets.only(bottom: 0.0),
        // ).animate(
        //   new CurvedAnimation(
        //     parent: buttonController,
        //     curve: new Interval(
        //       0.500,
        //       0.800,
        //       curve: Curves.ease,
        //     ),
        //   ),
        // ),
        super(key: key);
  final AnimationController buttonController;
  // final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;
  // final Animation buttomZoomOut;
  @override
  void dispose() {
    buttonController.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new InkWell(
        onTap: () {
          _playAnimation();
        },
        child: new Hero(
            tag: "fade",
            child: new Container(
                width: buttonSqueezeanimation.value,
                height: 60.0,
                alignment: FractionalOffset.center,
                decoration: new BoxDecoration(
                    color: const Color.fromRGBO(247, 64, 106, 1.0),
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(30.0))),
                child: buttonSqueezeanimation.value > 75.0
                    ? new Text(
                        "Sign In",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.3,
                        ),
                      )
                    : new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 1.0,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ))));
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushNamed(context, "/home");
      }
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
