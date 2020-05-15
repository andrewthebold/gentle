import 'dart:math';

import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class PlusParticle extends StatelessWidget {
  final Offset offset;
  final Duration delay;

  const PlusParticle({
    Key key,
    this.offset = Offset.zero,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track<double>('rotate')
          .add(const Duration(milliseconds: 2000), Tween(begin: 0, end: 360.0),
              curve: Curves.easeInOutCirc)
          .add(const Duration(milliseconds: 3000), ConstantTween(360.0))
          .add(
              const Duration(milliseconds: 2000), Tween(begin: 360.0, end: 0.0),
              curve: Curves.easeInOutCirc)
          .add(const Duration(milliseconds: 3000), ConstantTween(0.0))
    ]);

    return ControlledAnimation(
      delay: delay,
      duration: Constants.particleDuration,
      tween: tween,
      playback: Playback.LOOP,
      builder: (_, Map<String, dynamic> animation) {
        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: Transform.rotate(
            angle: (animation['rotate'] as double) * pi / 180,
            child: CustomPaint(
              painter: _PlusParticlePainter(),
              child: const SizedBox(
                width: _PlusParticlePainter.plusLineHeight,
                height: _PlusParticlePainter.plusLineHeight,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PlusParticlePainter extends CustomPainter {
  static const double plusLineHeight = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Palette.yellow
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    final pos = Offset(size.width / 2, size.height / 2);

    canvas.drawLine(pos.translate(0, -plusLineHeight / 2),
        pos.translate(0, plusLineHeight / 2), paint);
    canvas.drawLine(pos.translate(-plusLineHeight / 2, 0),
        pos.translate(plusLineHeight / 2, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter _) => false;
}
