import 'package:flutter/material.dart';
import 'package:gentle/theme.dart';

class GradientBG extends StatelessWidget {
  static const double height = 400;
  static const double paddingTop = 800;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Palette.gradientBG, Palette.white],
          begin: FractionalOffset(0.0, 1 - height / (height + paddingTop)),
          end: FractionalOffset(0.0, 1.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),

      // To make this cover the overflow scroll area on iOS,
      // we add extra space to the top (and stretch the gradient).
      height: height + paddingTop,
    );
  }
}
