import 'dart:math';

import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class LoadingShimmerBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Color bgColor) builder;
  final bool enabled;

  const LoadingShimmerBuilder({
    Key key,
    @required this.builder,
    this.enabled = true,
  }) : super(key: key);

  static final ColorTween _loadingColorTween = ColorTween(
    begin: Palette.shimmerDark,
    end: Palette.shimmerLight,
  );
  static const loadingDuration = 300.0;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: TickerMode(
        enabled: enabled,
        child: Rendering(
          builder: (BuildContext context, Duration timeElapsed) {
            final pos = sin(timeElapsed.inMilliseconds / loadingDuration);
            final bgColor = _loadingColorTween.transform(pos);
            return builder(context, bgColor);
          },
        ),
      ),
    );
  }
}
