import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/tip_bottomsheet.dart';
import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TipButton extends StatefulWidget {
  const TipButton({
    Key key,
    @required this.onPressed,
    @required this.visible,
    @required this.type,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool visible;
  final TipBottomSheetType type;

  @override
  _TipButtonState createState() => _TipButtonState();
}

class _TipButtonState extends State<TipButton> {
  bool _indicatorVisible = false;

  @override
  void initState() {
    super.initState();
    _getIndicatorVisible();
  }

  Future<void> _getIndicatorVisible() async {
    final prefKey = widget.type == TipBottomSheetType.request
        ? SharedPreferenceKeys.hasOpenedReplyTip
        : SharedPreferenceKeys.hasOpenedLetterTip;

    final prefs = await SharedPreferences.getInstance();
    final hasOpened = prefs.getBool(prefKey);
    if (hasOpened == null) {
      prefs.setBool(prefKey, false);
    }

    setState(() {
      _indicatorVisible = !prefs.getBool(prefKey);
    });
  }

  Future<void> _handlePressed() async {
    final prefKey = widget.type == TipBottomSheetType.request
        ? SharedPreferenceKeys.hasOpenedReplyTip
        : SharedPreferenceKeys.hasOpenedLetterTip;

    final prefs = await SharedPreferences.getInstance();
    final hasOpened = prefs.getBool(prefKey);
    if (!hasOpened) {
      prefs.setBool(prefKey, true);
      setState(() {
        _indicatorVisible = false;
      });
    }

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 5 * pi / 180,
      child: Material(
        color: Palette.transparent,
        child: AnimatedOpacity(
          opacity: widget.visible ? 1.0 : 0.0,
          duration: Constants.fastAnimDuration,
          child: ScaleButton(
            label: UIStrings.tips,
            onPressed: _handlePressed,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Palette.white,
                    border: Border.all(
                      color: Palette.graySecondary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [GentleShadow.basic],
                  ),
                  // height: 28,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 12.0,
                    top: 4.0,
                    bottom: 4.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      const Image(
                        image: AssetImage(
                            'assets/images/icons/24x24/tip_lightbulb.png'),
                        height: 24,
                        width: 24,
                      ),
                      Text(
                        UIStrings.tips,
                        style: GentleText.editorButtonLabel,
                      )
                    ],
                  ),
                ),
                if (_indicatorVisible)
                  Positioned(
                    top: 1,
                    right: 1,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Palette.red,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
