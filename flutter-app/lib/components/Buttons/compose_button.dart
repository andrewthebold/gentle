import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/screens/request_compose_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/theme.dart';

class ComposeButton extends StatefulWidget {
  @override
  _ComposeButtonState createState() => _ComposeButtonState();
}

class _ComposeButtonState extends State<ComposeButton> {
  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onPressed: () {
        Navigator.of(context).pushNamed(RequestComposeScreen.routeName);
      },
      label: UIStrings.createRequest,
      child: Container(
        height: Constants.floatingButtonDiameter,
        width: Constants.floatingButtonDiameter,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Constants.floatingButtonDiameter / 2),
          boxShadow: const [GentleShadow.basic],
          color: Palette.blue,
        ),
        child: const Image(
          height: 32,
          width: 32,
          image: AssetImage('assets/images/icons/32x32/compose.png'),
          color: Palette.white,
        ),
      ),
    );
  }
}
