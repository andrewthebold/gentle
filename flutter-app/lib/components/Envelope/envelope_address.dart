import 'dart:math';

import 'package:gentle/components/Envelope/envelope_style.dart';
import 'package:flutter/widgets.dart';

class EnvelopeAddress extends StatelessWidget {
  final EnvelopeStyle style;

  const EnvelopeAddress({@required this.style});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _EnvelopeAddressPainter(style: style),
      willChange: false,
      child: const SizedBox(width: 32, height: 11),
    );
  }
}

class _EnvelopeAddressPainter extends CustomPainter {
  static const int maxOffset = 32;
  static const int minOffset = 16;

  final EnvelopeStyle style;

  _EnvelopeAddressPainter({@required this.style});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = style.addressColor;
    paint.strokeWidth = 1;

    final random = Random(style.seed);

    const topLeft = Offset(0, 0);
    canvas.drawLine(
        topLeft,
        Offset(size.width - minOffset + random.nextInt(maxOffset - minOffset),
            size.topRight(topLeft).dy),
        paint);
    canvas.drawLine(
        size.centerLeft(topLeft),
        Offset(size.width - minOffset + random.nextInt(maxOffset - minOffset),
            size.centerRight(topLeft).dy),
        paint);
    canvas.drawLine(
        size.bottomLeft(topLeft),
        Offset(size.width - minOffset + random.nextInt(maxOffset - minOffset),
            size.bottomRight(topLeft).dy),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
