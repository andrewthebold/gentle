import 'package:flutter/material.dart';
import 'package:gentle/components/reaction_icon.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/theme.dart';

class ReactionChip extends StatelessWidget {
  const ReactionChip({
    Key key,
    @required this.type,
  }) : super(key: key);

  final ReactionType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Palette.white,
        border: Border.all(
          color: Palette.graySecondary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [GentleShadow.basic],
      ),
      child: ReactionIcon(
        type: type,
      ),
    );
  }
}
