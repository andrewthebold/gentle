import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class RectParticle extends StatelessWidget {
  final Offset offset;
  final Duration delay;
  final bool horizontal;

  const RectParticle({
    Key key,
    this.offset = Offset.zero,
    this.delay = Duration.zero,
    this.horizontal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track<double>('pos')
          .add(const Duration(milliseconds: 2000), Tween(begin: 0.0, end: 24.0),
              curve: Curves.easeInOutCirc)
          .add(const Duration(milliseconds: 3000), ConstantTween(24.0))
          .add(const Duration(milliseconds: 2000), Tween(begin: 24.0, end: 0.0),
              curve: Curves.easeInOutCirc)
          .add(const Duration(milliseconds: 3000), ConstantTween(0.0))
    ]);

    return ControlledAnimation(
      delay: delay,
      duration: Constants.particleDuration,
      tween: tween,
      playback: Playback.LOOP,
      builder: (_, Map<String, dynamic> animation) {
        final pos = animation['pos'] as double;
        final posX = horizontal ? pos + offset.dx : offset.dx;
        final posY = horizontal ? offset.dy : pos + offset.dy;

        return Positioned(
          left: posX,
          top: posY,
          child: CustomPaint(
            painter: _RectParticlePainter(),
            child: const SizedBox(
              width: _RectParticlePainter.rectangleSideLength,
              height: _RectParticlePainter.rectangleSideLength,
            ),
          ),
        );
      },
    );
  }
}

class _RectParticlePainter extends CustomPainter {
  static const double rectangleSideLength = 6;
  static const double rectangleBorderRadius = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Palette.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: rectangleSideLength,
          height: rectangleSideLength,
        ),
        const Radius.circular(rectangleBorderRadius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter _) => false;
}
