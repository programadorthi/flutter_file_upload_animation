import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter File Upload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'File Upload'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _centerCloudUploadStartAnimation;
  Animation<double> _centerCloudUploadEndAnimation;
  Animation<double> _progressAnimation;
  Animation<double> _progressOpacityAnimation;
  Animation<double> _uploadStartAnimation;
  Animation<double> _uploadingAnimation;
  Animation<double> _uploadEndAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(
        milliseconds: 4000,
      ),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _centerCloudUploadStartAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.175,
        0.6,
        curve: Curves.easeOutQuart,
      ),
    );

    _centerCloudUploadEndAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.6,
        1.0,
        curve: Curves.easeInOutCubic,
      ),
    );

    _progressAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuint,
    );

    _progressOpacityAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.9,
          1.0,
          curve: Curves.easeInCubic,
        ),
      ),
    );

    _uploadStartAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0,
        0.075,
        curve: Curves.decelerate,
      ),
    );

    _uploadingAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.2,
        0.4,
        curve: Curves.easeOutCirc,
      ),
    );

    _uploadEndAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.9,
        1.0,
        curve: Curves.decelerate,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _controller.forward(from: 0.0);
              },
              child: CustomPaint(
                painter: CustomBorder(
                  borderColor: Colors.blue,
                  progressAnimation: _progressAnimation,
                  progressOpacityAnimation: _progressOpacityAnimation,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: ShapeDecoration(
                      color: Colors.lightBlueAccent[100].withOpacity(0.6),
                      shape: CircleBorder(),
                    ),
                    child: ClipOval(
                      clipper: CustomOvalClipper(),
                      child: LayoutBuilder(
                        builder: (ctx, constraints) {
                          double halfHeight = constraints.maxHeight / 2;
                          double halfWidth = constraints.maxWidth / 2;
                          return Stack(
                            children: <Widget>[
                              Positioned(
                                left: halfWidth - 45,
                                top:
                                    halfHeight - 55 + _getCenterCloudPosition(),
                                child: Icon(
                                  MdiIcons.appleIcloud,
                                  color: Colors.blue[400],
                                  size: 90,
                                ),
                              ),
                              Positioned(
                                left: halfWidth - 25,
                                top: halfHeight - 23 + _getArrowPosition(),
                                child: Icon(
                                  MdiIcons.arrowUpBold,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                              Positioned(
                                right: -25,
                                top: -150 + (300 * _getRightCloudPosition()),
                                child: Icon(
                                  MdiIcons.appleIcloud,
                                  color: Colors.blue[400],
                                  size: 90,
                                ),
                              ),
                              Positioned(
                                left: -25,
                                top: -150 + (300 * _getLeftCloudPosition()),
                                child: Icon(
                                  MdiIcons.appleIcloud,
                                  color: Colors.blue[400],
                                  size: 90,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              _progressAnimation.value < 1.0
                  ? "${(_progressAnimation.value * 100).toInt()}%"
                  : "Completed",
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }

  double _getArrowPosition() {
    double arrowDownPosition = 7.0 * _uploadStartAnimation.value;
    double arrowUpPosition = 17 * _uploadingAnimation.value;
    double arrowResetPosition = 10 * _uploadEndAnimation.value;
    return arrowDownPosition - arrowUpPosition + arrowResetPosition;
  }

  double _getCenterCloudPosition() {
    if (_centerCloudUploadStartAnimation.value == 0.0 &&
        _centerCloudUploadEndAnimation.value == 0.0) {
      return 0.0;
    }

    if (_centerCloudUploadStartAnimation.value < 1.0) {
      return 200.0 * _centerCloudUploadStartAnimation.value;
    }

    return -200.0 * (1.0 - _centerCloudUploadEndAnimation.value);
  }

  double _getLeftCloudPosition() {
    double time = 0.0;
    if (_controller.value >= 0.2 && _controller.value <= 0.4) {
      time = (_controller.value - 0.2) / 2;
    }
    if (_controller.value >= 0.5 && _controller.value <= 0.7) {
      time = (_controller.value - 0.5) / 2;
    }
    return Curves.easeIn.transform(time * 10);
  }

  double _getRightCloudPosition() {
    double time = 0.0;
    if (_controller.value >= 0.125 && _controller.value <= 0.325) {
      time = (_controller.value - 0.125) / 2;
    }
    if (_controller.value >= 0.425 && _controller.value <= 0.625) {
      time = (_controller.value - 0.425) / 2;
    }
    return Curves.easeIn.transform(time * 10);
  }
}

class CustomBorder extends CustomPainter {
  final Paint _borderPaint;
  final Animation<double> progressAnimation;

  CustomBorder({
    Color borderColor,
    this.progressAnimation,
    Animation<double> progressOpacityAnimation,
  }) : _borderPaint = Paint()
          ..color = borderColor.withOpacity(progressOpacityAnimation.value)
          ..strokeWidth = 5.0
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
      Offset.zero & size,
      -math.pi / 2,
      2 * math.pi * progressAnimation.value,
      false,
      _borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomBorder oldDelegate) {
    return oldDelegate.progressAnimation.value != progressAnimation.value;
  }
}

class CustomOvalClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
