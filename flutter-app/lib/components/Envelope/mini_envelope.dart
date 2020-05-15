import 'dart:math';

import 'package:gentle/components/avatar.dart';
import 'package:gentle/components/Envelope/envelope_style.dart';
import 'package:gentle/models/activity_log_item_model.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';

class MiniEnvelope extends StatelessWidget {
  final ActivityLogItemModel item;

  const MiniEnvelope({
    Key key,
    @required this.item,
  })  : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget mailContent = Container();
    final style = EnvelopeStyleDecider.genEnvelopeStyle(
      id: item.linkedContentID,
      isAdmin: item.linkedContentAvatar == AvatarName.gentle,
    );

    switch (style.variant) {
      case MailVariant.plain:
        mailContent = _buildPlainMail(context, style);
        break;
      case MailVariant.airmail:
        mailContent = _buildAirmailMail(context, style);
        break;
      case MailVariant.official:
        mailContent = _buildOfficialMail(context, style);
        break;
    }

    if (mailContent != null) {
      return RepaintBoundary(
        child: SizedBox(
          height: 32,
          width: 32,
          child: Center(
            child: Transform.rotate(
              angle: style.stampRotationAngle * pi / 180,
              child: SizedBox(
                height: 20,
                width: 28,
                child: mailContent,
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox(
      height: 32,
      width: 32,
    );
  }

  Widget _buildStamp(BuildContext context, EnvelopeStyle style) {
    return Transform.rotate(
      angle: style.stampRotationAngle * pi / 180,
      child: Container(
        height: 5,
        width: 7,
        decoration: BoxDecoration(
          color: style.stampColor,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildPlainMail(BuildContext context, EnvelopeStyle style) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: Palette.grayTertiary,
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
          // White Layer
          Positioned(
            child: Container(
              margin:
                  const EdgeInsets.only(top: 1, left: 2, right: 2, bottom: 3),
              decoration: const BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),

          // Stamp
          Positioned(
            top: 3,
            right: 4,
            child: _buildStamp(context, style),
          ),
        ],
      ),
    );
  }

  Widget _buildAirmailMail(BuildContext context, EnvelopeStyle style) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: Palette.white,
        boxShadow: [
          GentleShadow.mini,
        ],
      ),
      child: Stack(
        children: <Widget>[
          // Striped Border
          CustomPaint(
            painter: _MiniAirStripesPainter(),
            child: const SizedBox.expand(),
          ),

          // Stamp
          Positioned(
            top: 4,
            right: 4,
            child: _buildStamp(context, style),
          ),

          // Outline
          DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Palette.grayPrimary,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialMail(BuildContext context, EnvelopeStyle style) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: Palette.blueTertiary,
        boxShadow: [
          GentleShadow.mini,
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: <Widget>[
            // White Layer
            Positioned(
              child: Container(
                margin:
                    const EdgeInsets.only(top: 1, left: 2, right: 2, bottom: 3),
                decoration: const BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
            ),

            // Blue Circle
            Positioned(
              top: -8,
              right: 0,
              child: Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Palette.blueTertiary,
                ),
              ),
            ),

            // Stamp
            Positioned(
              top: 4,
              right: 5,
              child: _buildStamp(context, style),
            ),

            // Blue Outline
            Container(
              margin: const EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Palette.blue,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: const SizedBox.expand(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAirStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()
      ..color = Palette.red
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    final blue = Paint()
      ..color = Palette.blue
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    // Top
    canvas.drawCircle(const Offset(3.0, 1.5), 0.5, blue);
    canvas.drawCircle(const Offset(6.0, 1.5), 0.5, red);
    canvas.drawCircle(const Offset(9.0, 1.5), 0.5, blue);
    canvas.drawCircle(const Offset(12.0, 1.5), 0.5, red);
    canvas.drawCircle(const Offset(15.0, 1.5), 0.5, blue);
    canvas.drawCircle(const Offset(18.0, 1.5), 0.5, red);
    canvas.drawCircle(const Offset(21.0, 1.5), 0.5, blue);
    canvas.drawCircle(const Offset(24.0, 1.5), 0.5, red);

    // Right
    canvas.drawCircle(const Offset(26.5, 3.0), 0.5, blue);
    canvas.drawCircle(const Offset(26.5, 6.0), 0.5, red);
    canvas.drawCircle(const Offset(26.5, 9.0), 0.5, blue);
    canvas.drawCircle(const Offset(26.5, 12.0), 0.5, red);
    canvas.drawCircle(const Offset(26.5, 15.0), 0.5, blue);

    // Bottom
    canvas.drawCircle(const Offset(26.0, 18.0), 1.0, red);
    canvas.drawCircle(const Offset(22.0, 18.0), 1.0, blue);
    canvas.drawCircle(const Offset(18.0, 18.0), 1.0, red);
    canvas.drawCircle(const Offset(14.0, 18.0), 1.0, blue);
    canvas.drawCircle(const Offset(10.0, 18.0), 1.0, red);
    canvas.drawCircle(const Offset(6.0, 18.0), 1.0, blue);
    canvas.drawCircle(const Offset(2.0, 18.0), 1.0, red);

    // Left
    canvas.drawCircle(const Offset(1.5, 15.0), 0.5, blue);
    canvas.drawCircle(const Offset(1.5, 12.0), 0.5, red);
    canvas.drawCircle(const Offset(1.5, 9.0), 0.5, blue);
    canvas.drawCircle(const Offset(1.5, 6.0), 0.5, red);
    canvas.drawCircle(const Offset(1.5, 3.0), 0.5, blue);
  }

  @override
  bool shouldRepaint(_) => false;
}
