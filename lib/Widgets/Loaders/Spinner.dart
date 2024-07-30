import 'package:flutter/material.dart';
import 'dart:math' as math;

class BoxLoader extends StatefulWidget {
  const BoxLoader({super.key});

  @override
  _BoxLoaderState createState() => _BoxLoaderState();
}

class _BoxLoaderState extends State<BoxLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double progress = _controller.value;
        double boxShadowSize = 20 * progress;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateX(65 * math.pi / 280)
            ..rotateZ(45 * math.pi / 180),
          child: Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(boxShadowSize, boxShadowSize),
                      blurRadius: 4,
                      spreadRadius: -4,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(-25 * progress, -25 * progress),
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
