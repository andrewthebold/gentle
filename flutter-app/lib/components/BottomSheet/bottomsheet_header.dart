import 'package:flutter/material.dart';
import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';

class BottomSheetHeader extends StatelessWidget {
  final String label;

  const BottomSheetHeader({
    Key key,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 16.0,
          right: 16.0,
          bottom: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label, style: GentleText.bottomsheetTitle),
            ScaleButton(
              label: UIStrings.close,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Palette.offBlack10,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Image(
                  image: AssetImage('assets/images/icons/24x24/cross.png'),
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
