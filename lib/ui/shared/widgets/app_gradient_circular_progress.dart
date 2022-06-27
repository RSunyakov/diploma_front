import 'package:flutter/material.dart';
import 'dart:math';

class AppGradientCircularProgress extends StatelessWidget {
  const AppGradientCircularProgress({
    Key? key,
    required this.size,
    required this.listGradientColors,
    this.strokeWidth = 10.0,
    this.strokeCap = StrokeCap.butt,
    required this.value,
  }) : super(key: key);

  final double size;
  final List<Color> listGradientColors;
  final double strokeWidth;
  final double value;
  final StrokeCap strokeCap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(size / 2),
      painter: GradientCircularProgressPainter(
        radius: size,
        gradientColors: listGradientColors,
        strokeWidth: strokeWidth,
        value: value,
        strokeCap: strokeCap,
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  GradientCircularProgressPainter(
      {required this.radius,
      required this.gradientColors,
      required this.strokeWidth,
      required this.value,
      this.strokeCap = StrokeCap.butt})
      : arcStart = _startAngle,
        arcSweep = value.clamp(0.0, 1.0) * _sweep;

  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;
  final double value;
  final double arcStart;
  final double arcSweep;
  final StrokeCap strokeCap;

  static const double _epsilon = .001;
  static const double _sweep = (pi * 2) - _epsilon;
  static const double _startAngle = -pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius / 2);
    double offset = strokeWidth / 2;
    Rect rect = Offset(offset, offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap
      ..strokeWidth = strokeWidth;
    paint.shader = LinearGradient(colors: gradientColors).createShader(rect);
    canvas.drawArc(Offset.zero & size, arcStart, arcSweep, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
