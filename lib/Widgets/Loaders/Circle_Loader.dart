import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class CircleLoader extends StatefulWidget {
  const CircleLoader({super.key});

  @override
  _CircleLoaderState createState() => _CircleLoaderState();
}

class _CircleLoaderState extends State<CircleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Total animation duration
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: IconLoaderPainter(_controller),
      ),
    );
  }
}

class IconLoaderPainter extends CustomPainter {
  final AnimationController controller;

  IconLoaderPainter(this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 10.0;
    double radius = size.width / 2 - strokeWidth;

    // Calculate dash length and gap length
    double length = 2 * pi * radius;
    double dashLength = length / 8;
    double gapLength = length / 100;

    // Paint for first circle
    Paint paint1 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Paint for second circle
    Paint paint2 = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Calculate animations
    double animationValue = controller.value * 2 * pi; // Full rotation
    double offset1 =
        dashLength * (1 - (controller.value % 0.5) * 2); // For first circle
    double offset2 =
        dashLength * ((controller.value % 0.5) * 2 - 1); // For second circle

    // Draw first circle
    Path path1 = Path()
      ..addArc(
          Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
          -pi / 2,
          animationValue);
    drawDashedArc(canvas, path1, paint1, [dashLength, gapLength], offset1);

    // Draw second circle
    Path path2 = Path()
      ..addArc(
          Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
          -pi / 2,
          animationValue);
    drawDashedArc(canvas, path2, paint2, [dashLength, gapLength], offset2);
  }

  void drawDashedArc(Canvas canvas, Path path, Paint paint,
      List<double> dashArray, double offset) {
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      double length = pathMetric.length;
      for (double distance = offset;
          distance < length;
          distance += dashArray[0] + dashArray[1]) {
        double start = distance;
        double end = min(distance + dashArray[0], length);
        canvas.drawPath(pathMetric.extractPath(start, end), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
