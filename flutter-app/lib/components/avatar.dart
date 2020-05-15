import 'dart:math';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:gentle/theme.dart';

enum AvatarName {
  cat,
  fish,
  icecream,
  leaf,
  pizza,

  // Non-public
  gentle,

  // Fallback
  unknown,
}

class Avatar extends StatelessWidget {
  static const List<AvatarName> unavailableAvatars = [
    AvatarName.gentle,
    AvatarName.unknown,
  ];

  final AvatarName avatarName;

  const Avatar({
    Key key,
    @required this.avatarName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarNameString =
        EnumToString.parse(avatarName ?? AvatarName.unknown);
    return SizedBox(
      height: 32,
      width: 32,
      child: Image(
        image: AssetImage('assets/images/avatars/$avatarNameString.png'),
        width: 32,
        height: 32,
        color: avatarName == AvatarName.gentle
            ? Palette.blue
            : Palette.grayPrimary,
      ),
    );
  }

  static AvatarName getAvatarNameFromString(String avatarName) {
    return EnumToString.fromString(AvatarName.values, avatarName) ??
        AvatarName.unknown;
  }

  static AvatarName getAvatarNameFromUID(String uid) {
    final random = Random(uid.hashCode);
    final availableAvatars = AvatarName.values
        .where((avatar) => !Avatar.unavailableAvatars.contains(avatar))
        .toList();

    final index = random.nextInt(availableAvatars.length);
    return availableAvatars[index];
  }
}
