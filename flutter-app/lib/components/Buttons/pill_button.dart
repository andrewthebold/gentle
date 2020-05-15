import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final AssetImage icon;
  final String label;
  final GestureTapCallback onPressed;

  const PillButton({
    Key key,
    this.icon,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onPressed: onPressed,
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Palette.grayTertiary,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...[
              Image(
                image: icon,
                height: 16,
                width: 16,
              ),
              const SizedBox(width: 8),
            ],
            Text(label, style: GentleText.listSecondaryLabel),
          ],
        ),
      ),
    );
  }
}
