import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
  late final ValueNotifier<Vector2> playerPosition;
  @override
  void initState() {
    playerPosition = ValueNotifier(Vector2(100, 100));
    _ticker = Ticker((elapsed) {
      // calculate tick

      final dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
      _lastElapsed = elapsed;
      update();
      render();
    });

    _ticker.start();

    super.initState();
  }

  @override
  void dispose() {
    playerPosition.dispose();

    super.dispose();
  }

  void update() {}
  void render() {}

  void updatePlayerPosition(Vector2 directionVector) {
    const velocity = 10.0;
    directionVector = directionVector.normalized() * velocity;
    playerPosition.value = Vector2(
      playerPosition.value.x + directionVector.x,
      playerPosition.value.y + directionVector.y,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => updatePlayerPosition(
        Vector2(
          details.globalPosition.dx - playerPosition.value.x,
          details.globalPosition.dy - playerPosition.value.y,
        ),
      ),

      child: Container(
        height: widget.height,
        width: widget.width,
        color: Colors.grey,
        child: CustomPaint(painter: PlayerPainter(repaint: playerPosition)),
      ),
    );
  }
}

class PlayerPainter extends CustomPainter {
  final ValueNotifier<Vector2> repaint;

  PlayerPainter({required this.repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final size = 10.0;
    final map = [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 1, 1, 1, 1, 0, 0, 1],
      [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ];
    const TILE_HEIGHT = 30.0;
    const TILE_WIDTH = 30.0;
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        final tile = Rect.fromLTWH(
          j * TILE_WIDTH,
          i * TILE_HEIGHT,
          TILE_WIDTH - 1,
          TILE_HEIGHT - 1,
        );
        final tilePaint = Paint()
          ..color = map[i][j] == 0 ? Colors.white : Colors.black;
        canvas.drawRect(tile, tilePaint);
      }
    }
    final paint = Paint()..color = Colors.yellow;
    final rect = Rect.fromLTWH(repaint.value.x, repaint.value.y, size, size);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant PlayerPainter oldPainter) {
    return false;
  }
}
