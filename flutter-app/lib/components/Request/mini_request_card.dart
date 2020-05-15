import 'dart:math';

import 'package:gentle/components/avatar.dart';
import 'package:gentle/models/activity_log_item_model.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';

class MiniRequestCard extends StatelessWidget {
  final ActivityLogItemModel item;

  const MiniRequestCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final random = Random(item.id.hashCode);
    final angle = random.nextInt(6 * 2) - 6.0;

    return RepaintBoundary(
      child: SizedBox(
        height: 32,
        width: 32,
        child: Center(
          child: Transform.rotate(
            angle: angle * pi / 180,
            child: Container(
              height: 24,
              width: 28,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: Palette.white,
                border: Border.all(
                  width: 1,
                  color: Palette.grayPrimary,
                ),
                boxShadow: const [
                  GentleShadow.mini,
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: CustomPaint(
                      painter: _MiniRequestCardBodyPainter(item: item),
                      willChange: false,
                      child: const SizedBox(
                        width: 18,
                        height: 7,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Transform.scale(
                      scale: 0.33,
                      origin: const Offset(16.0, 16.0),
                      child: Avatar(
                        avatarName: item.linkedContentAvatar,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniRequestCardBodyPainter extends CustomPainter {
  static const int maxOffset = 18;
  static const int minOffset = 14;

  final ActivityLogItemModel item;

  _MiniRequestCardBodyPainter({@required this.item});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Palette.graySecondary;
    paint.strokeWidth = 1;

    final random = Random(item.id.hashCode);

    const topLeft = Offset(0, 0);
    canvas.drawLine(
        topLeft,
        Offset(random.nextInt(maxOffset - minOffset).toDouble() + minOffset,
            size.topRight(topLeft).dy),
        paint);
    canvas.drawLine(
        size.centerLeft(topLeft),
        Offset(random.nextInt(maxOffset - minOffset).toDouble() + minOffset,
            size.centerRight(topLeft).dy),
        paint);
    canvas.drawLine(
        size.bottomLeft(topLeft),
        Offset(random.nextInt(maxOffset - minOffset).toDouble() + minOffset - 6,
            size.bottomRight(topLeft).dy),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter _) => false;
}
