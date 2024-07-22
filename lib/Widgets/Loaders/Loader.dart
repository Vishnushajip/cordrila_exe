import 'package:flutter/material.dart';

class SpinnerWidget extends StatefulWidget {
  const SpinnerWidget({Key? key, }) : super(key: key);

  @override
  _SpinnerWidgetState createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<SpinnerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  final List<String> _words = [
    'Loading..',
    'Please Wait',
    'Almost There',
    'Getting Ready',
    'Hold On',
  ];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 5), // Total animation duration for cycling through words
    );
    _animation = IntTween(begin: 0, end: _words.length - 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _index = _animation.value;
        });
      });
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value *
                    2 *
                    3.1415926535897932, // Full rotation in radians
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Text(
            _words[_index],
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
