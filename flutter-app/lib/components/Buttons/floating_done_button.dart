import 'dart:math';

import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';

class FloatingDoneButton extends StatelessWidget {
  final String label;
  final AssetImage icon;
  final GestureTapCallback onPressed;
  final Color bgColor;

  const FloatingDoneButton({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.onPressed,
    this.bgColor = Palette.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: ScaleButton(
        onPressed: onPressed,
        label: UIStrings.done,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 52,
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: const [GentleShadow.large],
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            children: <Widget>[
              Image(
                image: icon,
                height: 22,
                width: 22,
                color: Palette.white,
              ),
              const SizedBox(width: 8),
              Text(label, style: GentleText.floatingButton),
            ],
          ),
        ),
      ),
    );
  }
}
