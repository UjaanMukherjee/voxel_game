import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyGame());
}

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voxel Game',
      home: const Screen(height: 400, width: 400),
    );
  }
}

class Screen extends StatefulWidget {
  final double height;
  final double width;
  const Screen({required this.height, required this.width, super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  @override
  void initState() {
    _ticker = Ticker((elapsed) {
      // calculate tick
      final dt = (elapsed - _lastElapsed) / 1000000.0;
      _lastElapsed = elapsed;
      update();
      render();
    });
    _ticker.start();

    super.initState();
  }

  void update() {}
  void render() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      color: Colors.grey,
      child: CustomPaint(painter: PlayerPainter()),
    );
  }
}

class PlayerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final size = 10.0;
    final paint = Paint()..color = Colors.yellow;
    final rect = Rect.fromLTWH(100, 100, size, size);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant PlayerPainter oldPainter) {
    return false;
  }
}
