import 'dart:math';

import 'package:gentle/constants.dart';
import 'package:gentle/route_generator.dart';
import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:gentle/screens/letter_compose_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/theme.dart';

class ReplyButton extends StatelessWidget {
  static const double iconRotationAngle = 5;

  final RequestItemModel requestItem;

  const ReplyButton({
    Key key,
    @required this.requestItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onPressed: () {
        if (requestItem == null) {
          return;
        }

        Navigator.of(context).pushNamed(
          LetterComposeScreen.routeName,
          arguments: LetterComposeScreenArguments(
            requestItem: requestItem,
          ),
        );
      },
      label: UIStrings.replyRequest,
      child: Container(
        height: Constants.floatingButtonDiameter,
        width: Constants.floatingButtonDiameter,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Constants.floatingButtonDiameter / 2),
          boxShadow: const [GentleShadow.basic],
          color: Palette.blue,
        ),
        child: Transform.rotate(
          angle: ReplyButton.iconRotationAngle * pi / 180,
          child: const Image(
            height: 32,
            width: 32,
            image: AssetImage('assets/images/icons/32x32/reply.png'),
            color: Palette.white,
          ),
        ),
      ),
    );
  }
}
