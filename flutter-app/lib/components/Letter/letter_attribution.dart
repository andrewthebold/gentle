import 'dart:math';

import 'package:gentle/components/avatar.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/widgets.dart';

enum LetterAttributionType {
  to,
  from,
}

class LetterAttribution extends StatelessWidget {
  final LetterAttributionType type;
  final AvatarName avatarName;

  const LetterAttribution({
    Key key,
    @required this.type,
    @required this.avatarName,
  }) : super(key: key);

  String _getStem() {
    switch (type) {
      case LetterAttributionType.to:
        return 'Dear';
      case LetterAttributionType.from:
        return 'From';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -7 * pi / 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(_getStem(), style: GentleText.letterAttribution),
          Avatar(
            avatarName: avatarName,
          ),
        ],
      ),
    );
  }
}
