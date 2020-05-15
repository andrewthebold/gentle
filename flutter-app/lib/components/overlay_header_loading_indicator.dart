import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/theme.dart';
import 'package:simple_animations/simple_animations.dart';

class OverlayHeaderLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 24,
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 6.0),
      child: LoopAnimation<double>(
        tween: Tween(begin: 0.0, end: 360.0),
        builder: (context, child, value) => Transform.rotate(
          angle: (value ?? 0.0) * pi / 180,
          child: child,
        ),
        child: const Image(
          image: AssetImage('assets/images/icons/24x24/spinner.png'),
          height: 24,
          width: 24,
          color: Palette.blue,
        ),
      ),
    );
  }
}
