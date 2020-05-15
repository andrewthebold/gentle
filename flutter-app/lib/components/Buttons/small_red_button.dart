import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';

class SmallRedButton extends StatelessWidget {
  final AssetImage icon;
  final String label;
  final GestureTapCallback onPressed;

  const SmallRedButton({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onPressed: onPressed,
      label: label,
      child: Container(
        height: Constants.smallFloatingButtonDiameter,
        width: Constants.smallFloatingButtonDiameter,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Constants.smallFloatingButtonDiameter / 2),
          boxShadow: const [GentleShadow.basic],
          color: Palette.red,
        ),
        child: Image(
          height: 32,
          width: 32,
          image: icon,
        ),
      ),
    );
  }
}
