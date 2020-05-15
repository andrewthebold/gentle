import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class CircleParticle extends StatelessWidget {
  final Offset offset;
  final Duration delay;

  const CircleParticle({
    Key key,
    this.offset = Offset.zero,
    this.delay = Duration.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track<double>('scale')
          .add(const Duration(milliseconds: 2000), Tween(begin: 1.0, end: 0.0),
              curve: Curves.easeInOutCirc)
          .add(const Duration(milliseconds: 3000), ConstantTween(0.0))
          .add(const Duration(milliseconds: 2000), Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeInOutCirc)
          .add(const Duration(milliseconds: 3000), ConstantTween(1.0))
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
          child: Transform.scale(
            scale: animation['scale'] as double,
            child: CustomPaint(
              painter: _CircleParticlePainter(),
              child: const SizedBox(
                width: _CircleParticlePainter.circleRadius * 2,
                height: _CircleParticlePainter.circleRadius * 2,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircleParticlePainter extends CustomPainter {
  static const double circleRadius = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Palette.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), circleRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter _) => false;
}
