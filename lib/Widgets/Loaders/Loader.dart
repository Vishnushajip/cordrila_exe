import 'package:flutter/material.dart';



class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Total animation duration
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
      width: 24, // Adjust size as needed
      height: 48, // Adjust size as needed
      child: CustomPaint(
        painter: LoaderPainter(_controller),
      ),
    );
  }
}

class LoaderPainter extends CustomPainter {
  final Animation<double> animation;

  LoaderPainter(AnimationController controller)
      : animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
          ),
        )..addListener(() {
            // Redraw the widget when the animation changes
            // This is necessary to update the animation
            // and trigger repaints.
            // No need for mounted check here
            // setState(() {}); // This is not needed in CustomPainter
          }),
        super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    double translateY = size.height * animation.value;

    // Draw the gradient circle before animation
    Paint paint1 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFCE3A), Color(0xFF42B549)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint1);

    // Draw the gradient circle after animation with delay
    Paint paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF72DFE7), Color(0xFF42B549)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2 - translateY),
        size.width / 2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
