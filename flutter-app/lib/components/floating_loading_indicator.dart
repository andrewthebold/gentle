import 'dart:math';

import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FloatingLoadingIndicator extends StatelessWidget {
  final bool isDestructive;

  const FloatingLoadingIndicator({
    Key key,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isDestructive ? Palette.red : Palette.blue,
          boxShadow: const [GentleShadow.large],
          borderRadius: BorderRadius.circular(26),
        ),
        child: LoopAnimation<double>(
          tween: Tween(begin: 0.0, end: 360.0),
          duration: const Duration(milliseconds: 1000),
          builder: (context, child, value) => Transform.rotate(
            angle: (value ?? 0.0) * pi / 180,
            child: child,
          ),
          child: const Image(
            image: AssetImage('assets/images/icons/24x24/spinner.png'),
            height: 24,
            width: 24,
            color: Palette.white,
          ),
        ),
      ),
    );
  }
}
