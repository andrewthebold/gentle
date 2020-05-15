import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/widgets.dart';

class OverlayHeaderActionButton extends StatelessWidget {
  final AssetImage icon;
  final Color iconColor;
  final String text;
  final TextStyle textStyle;
  final bool enabled;
  final GestureTapCallback onPressed;

  const OverlayHeaderActionButton({
    Key key,
    @required this.icon,
    @required this.iconColor,
    @required this.text,
    @required this.textStyle,
    this.enabled = true,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      label: text,
      onPressed: enabled ? onPressed : null,
      enabled: enabled,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 6,
          left: 16,
          right: 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildIcon(),
            const SizedBox(width: 8),
            _buildLabel()
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Image(
      image: icon,
      height: 22,
      width: 22,
      color: enabled ? iconColor : Palette.graySecondary,
    );
  }

  Widget _buildLabel() {
    return DefaultTextStyle(
      style: enabled
          ? textStyle
          : textStyle.merge(const TextStyle(color: Palette.graySecondary)),
      child: Text(
        text,
      ),
    );
  }

  const OverlayHeaderActionButton.buildCloseButton({@required this.onPressed})
      : icon = const AssetImage('assets/images/icons/24x24/cross.png'),
        iconColor = Palette.grayPrimary,
        text = UIStrings.close,
        textStyle = GentleText.appBarDefaultButtonLabel,
        enabled = true;

  const OverlayHeaderActionButton.buildSendButton({
    @required this.onPressed,
    @required this.enabled,
  })  : icon = const AssetImage('assets/images/icons/24x24/airplane.png'),
        iconColor = Palette.blue,
        text = UIStrings.send,
        textStyle = GentleText.appBarAccentButtonLabel;

  const OverlayHeaderActionButton.buildCancelButton({@required this.onPressed})
      : icon = const AssetImage('assets/images/icons/24x24/cross.png'),
        iconColor = Palette.grayPrimary,
        text = UIStrings.cancel,
        textStyle = GentleText.appBarDefaultButtonLabel,
        enabled = true;

  const OverlayHeaderActionButton.buildReportButton({@required this.onPressed})
      : icon = const AssetImage('assets/images/icons/24x24/flag.png'),
        iconColor = Palette.red,
        text = UIStrings.report,
        textStyle = GentleText.appBarDestructiveButtonLabel,
        enabled = true;
}
