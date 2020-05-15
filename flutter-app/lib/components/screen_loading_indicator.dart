import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:simple_animations/simple_animations.dart';

class ScreenLoadingIndicator extends StatelessWidget {
  final double height;
  final bool enabled;

  const ScreenLoadingIndicator({
    Key key,
    @required this.height,
    @required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      child: TickerMode(
        enabled: enabled,
        child: Rendering(
          builder: (_, Duration timeElapsed) {
            final iterations = timeElapsed.inMilliseconds / 300.0;

            return Transform.rotate(
              angle: sin(iterations) * 10 * pi / 180,
              child: AnimatedOpacity(
                duration: Constants.mediumAnimDuration,
                // Add slight delay to loading indicator being visible
                opacity: timeElapsed.inMilliseconds > 300 ? 1.0 : 0.0,
                child: const Image(
                  image: AssetImage(
                      'assets/images/icons/56x56/loading_gentle.png'),
                  height: 56,
                  width: 56,
                  color: Palette.graySecondary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
