import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/theme.dart';

enum ReactionIconSize {
  small, // 10px radius
  large, // 16px radius
}

class ReactionIcon extends StatelessWidget {
  static const double smallDiameter = 20;
  static const double largeDiameter = 32;

  const ReactionIcon({
    Key key,
    @required this.type,
    this.angle,
    this.size = ReactionIconSize.small,
    this.hasShadow = false,
  }) : super(key: key);

  final int angle;
  final bool hasShadow;
  final ReactionIconSize size;
  final ReactionType type;

  Color _getColor() {
    switch (type) {
      case ReactionType.love:
        return Palette.red;
      case ReactionType.inspire:
        return Palette.yellow;
      case ReactionType.thanks:
        return Palette.green;
      case ReactionType.unknown:
        break;
    }
    return Palette.grayPrimary;
  }

  AssetImage _getAssetImage() {
    final isLarge = size == ReactionIconSize.large;

    switch (type) {
      case ReactionType.love:
        return isLarge
            ? const AssetImage("assets/images/icons/24x24/reaction_love.png")
            : const AssetImage("assets/images/icons/16x16/reaction_love.png");
      case ReactionType.inspire:
        return isLarge
            ? const AssetImage("assets/images/icons/24x24/reaction_inspire.png")
            : const AssetImage(
                "assets/images/icons/16x16/reaction_inspire.png");
      case ReactionType.thanks:
        return isLarge
            ? const AssetImage("assets/images/icons/24x24/reaction_thanks.png")
            : const AssetImage("assets/images/icons/16x16/reaction_thanks.png");
      case ReactionType.unknown:
        break;
    }
    return const AssetImage("assets/images/icons/16x16/questionmark.png");
  }

  static String getLabel(ReactionType type) {
    switch (type) {
      case ReactionType.love:
        return 'Love it';
      case ReactionType.inspire:
        return 'Inspired me';
      case ReactionType.thanks:
        return 'Thank you';
      case ReactionType.unknown:
        break;
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = size == ReactionIconSize.large;
    final diameter =
        isLarge ? ReactionIcon.largeDiameter : ReactionIcon.smallDiameter;

    Widget icon = Image(
      image: _getAssetImage(),
      height: isLarge ? 24 : 16,
      width: isLarge ? 24 : 16,
    );

    if (angle != null) {
      icon = Transform.rotate(
        angle: angle * pi / 180,
        child: icon,
      );
    }

    final child = Container(
      alignment: Alignment.center,
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(diameter / 2),
        boxShadow: hasShadow ? [GentleShadow.basic] : null,
        color: _getColor(),
      ),
      child: icon,
    );

    return child;
  }
}
