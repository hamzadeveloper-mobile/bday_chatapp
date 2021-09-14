import 'package:flutter/material.dart';

class ElasticInOutAnimation extends PageRouteBuilder {
  final Widget widgets;
  final int secs;

  ElasticInOutAnimation({@required this.widgets, @required this.secs})
      : super(
          transitionDuration: Duration(seconds: secs),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: Curves.elasticInOut,
            );

            return ScaleTransition(
              alignment: Alignment.center,
              scale: animation,
              child: child,
            );
          },
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secAnimation) {
            return widgets;
          },
        );
}
