import 'package:gentle/components/avatar.dart';
import 'package:gentle/components/Envelope/envelope_address.dart';
import 'package:gentle/components/Envelope/envelope_sender_name.dart';
import 'package:gentle/components/Envelope/envelope_stamp.dart';
import 'package:gentle/components/Envelope/envelope_style.dart';
import 'package:gentle/models/inbox_item_model.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';

class Envelope extends StatelessWidget {
  final InboxItemModel inboxItem;

  const Envelope({
    Key key,
    @required this.inboxItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inboxItem == null) {
      return Container();
    }

    Widget mailContent;
    final style = EnvelopeStyleDecider.genEnvelopeStyle(
      id: inboxItem.linkedContentID,
      isAdmin: inboxItem.linkedContentAvatar == AvatarName.gentle,
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

    return RepaintBoundary(
      child: mailContent,
    );
  }

  Widget _buildPlainMail(BuildContext context, EnvelopeStyle style) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Palette.grayTertiary,
        border: Border.all(
          width: 1,
          color: Palette.grayPrimary,
        ),
        boxShadow: const [
          GentleShadow.basic,
        ],
      ),
      child: Stack(
        children: <Widget>[
          // White layer
          Positioned(
            child: Container(
              margin:
                  const EdgeInsets.only(top: 1, left: 4, right: 4, bottom: 7),
              decoration: const BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
          ),

          // Mail Sender
          Positioned(
            top: 4,
            left: 6,
            child: EnvelopeSenderName(item: inboxItem),
          ),

          // Mail Address
          Center(
            child: EnvelopeAddress(
              style: style,
            ),
          ),

          // Stamp
          Positioned(
            right: 10,
            top: 6,
            child: EnvelopeStamp(
              style: style,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAirmailMail(BuildContext context, EnvelopeStyle style) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Palette.white,
        boxShadow: [
          GentleShadow.basic,
        ],
      ),
      child: Stack(
        children: <Widget>[
          // Striped Border
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const Image(
              image: AssetImage('assets/images/mail/airmail_stripes.png'),
              height: 200,
              width: 200,
              repeat: ImageRepeat.repeat,
              colorBlendMode: BlendMode.multiply,
            ),
          ),

          // White Layer
          Positioned(
            child: Container(
              margin:
                  const EdgeInsets.only(top: 3, left: 4, right: 4, bottom: 8),
              decoration: const BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
          ),

          // Sender Name
          Positioned(
            top: 6,
            left: 8,
            child: EnvelopeSenderName(item: inboxItem),
          ),

          // Mail Address
          Center(
            child: EnvelopeAddress(
              style: style,
            ),
          ),

          // Stamp
          Positioned(
            right: 11,
            top: 7,
            child: EnvelopeStamp(
              style: style,
            ),
          ),

          CustomPaint(
            painter: _AirmailBorderPainter(),
            child: const SizedBox.expand(),
          )
        ],
      ),
    );
  }

  Widget _buildOfficialMail(BuildContext context, EnvelopeStyle style) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Palette.white,
          boxShadow: [
            GentleShadow.basic,
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: <Widget>[
            // Blue Outline
            const DecoratedBox(
              decoration: BoxDecoration(
                  color: Palette.blueTertiary,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SizedBox.expand(),
            ),

            // White Layer
            Positioned(
              child: Container(
                margin:
                    const EdgeInsets.only(top: 2, left: 5, right: 5, bottom: 9),
                decoration: const BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),

            // Blue Circle
            Positioned(
              top: -80,
              right: -24,
              child: Container(
                height: 165,
                width: 165,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  color: Palette.blueTertiary,
                ),
              ),
            ),

            // Mail Sender
            Positioned(
              top: 6,
              left: 8,
              child: EnvelopeSenderName(item: inboxItem),
            ),

            // Mail Address
            Positioned(
              left: 15,
              bottom: 17,
              child: Container(
                height: 38,
                width: 80,
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 0,
                      offset: Offset(0, -1),
                      color: Palette.grayTertiary,
                    )
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: -128,
                      right: -104,
                      child: Container(
                        height: 165,
                        width: 165,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          color: Palette.blueTertiary.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: EnvelopeAddress(
                        style: style,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stamp
            Positioned(
              right: 10,
              top: 6,
              child: EnvelopeStamp(
                style: style,
              ),
            ),

            CustomPaint(
              painter: _GentleBorderPainter(),
              child: const SizedBox.expand(),
            )
          ],
        ),
      ),
    );
  }
}

class _GentleBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint();
    borderPaint.color = Palette.blue;
    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 2;
    borderPaint.blendMode = BlendMode.multiply;
    borderPaint.isAntiAlias = true;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(1.5, 1.5, size.width - 3, size.height - 3),
            const Radius.circular(10)),
        borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _AirmailBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint();
    borderPaint.color = Palette.grayPrimary.withOpacity(0.66);
    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 1;
    borderPaint.blendMode = BlendMode.multiply;
    borderPaint.isAntiAlias = true;

    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height),
            const Radius.circular(10)),
        borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
