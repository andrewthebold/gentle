import 'dart:math';
import 'package:gentle/components/Envelope/envelope_style.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/theme.dart';

enum Stamp {
  alien,
  dog,
  duck,
  fish,
  icecream,
  landscape,
  space,
  tree,
  verified,
}

class EnvelopeStamp extends StatelessWidget {
  static const List<Color> stampColors = [
    Palette.red,
    Palette.blue,
    Palette.yellow,
    Palette.green
  ];

  final EnvelopeStyle style;

  const EnvelopeStamp({@required this.style});

  @override
  Widget build(BuildContext context) {
    final stampNameString = EnumToString.parse(style.stamp) ?? Stamp.fish;
    return Transform.rotate(
      angle: style.stampRotationAngle * pi / 180,
      child: Image(
        height: 30.0,
        width: 30.0,
        image: AssetImage('assets/images/stamps/$stampNameString.png'),
        color: style.stampColor,
      ),
    );
  }

  static Stamp getStampFromString(String stamp) =>
      EnumToString.fromString(Stamp.values, stamp) ?? Stamp.icecream;
}
