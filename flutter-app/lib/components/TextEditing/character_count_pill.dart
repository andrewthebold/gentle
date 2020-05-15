import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';

class CharacterCountPill extends StatelessWidget {
  const CharacterCountPill({
    Key key,
    @required this.visible,
    @required this.count,
    @required this.maxCount,
  }) : super(key: key);

  final bool visible;
  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Material(
        color: Palette.transparent,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Constants.fastAnimDuration,
          child: Container(
            decoration: BoxDecoration(
              color: count >= maxCount ? Palette.red : Palette.grayPrimary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [GentleShadow.basic],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6.0,
            ),
            child: Text(
              '$count / $maxCount',
              style: GentleText.floatingWordCount,
            ),
          ),
        ),
      ),
    );
  }
}
