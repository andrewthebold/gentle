import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/components/reaction_icon.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/theme.dart';

class ReactionLabelButton extends StatelessWidget {
  const ReactionLabelButton({
    Key key,
    @required this.type,
    @required this.angle,
    @required this.onPressed,
    @required this.isActive,
  }) : super(key: key);

  final ReactionType type;
  final int angle;
  final VoidCallback onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (type == ReactionType.unknown) {
      return Container();
    }

    final label = ReactionIcon.getLabel(type);

    return Transform.rotate(
      angle: angle * pi / 180,
      child: ScaleButton(
        label: label,
        onPressed: onPressed,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            AnimatedOpacity(
              duration: Constants.fastAnimDuration,
              opacity: isActive ? 0.0 : 1.0,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Palette.white,
                  border: Border.all(
                    color: Palette.graySecondary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [GentleShadow.large],
                ),
                child: Row(
                  children: <Widget>[
                    ReactionIcon(
                      angle: -angle,
                      type: type,
                    ),
                    const SizedBox(width: 10),
                    Text(label, style: GentleText.reactionLabel),
                  ],
                ),
              ),
            ),
            if (isActive) ...[
              Positioned(
                left: -1,
                top: -1,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Palette.white,
                    border: Border.all(
                      color: Palette.green,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [GentleShadow.large],
                  ),
                  child: Row(
                    children: <Widget>[
                      ReactionIcon(
                        angle: -angle,
                        type: type,
                      ),
                      const SizedBox(width: 10),
                      Text(label, style: GentleText.reactionLabel),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  alignment: Alignment.center,
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: Palette.green,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [GentleShadow.basic],
                  ),
                  child: const Image(
                    image: AssetImage('assets/images/icons/24x24/check.png'),
                    height: 16,
                    width: 16,
                    color: Palette.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
