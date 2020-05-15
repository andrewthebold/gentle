import 'package:flutter/material.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';

class SliverDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
            color: Palette.dividerBGBorder,
            width: 1,
          )),
          color: Palette.dividerBG,
        ),
        child: const SizedBox(
          width: double.infinity,
          height:
              Constants.sliverDividerHeight - 1.0, // Subtract 1 for the width
        ),
      ),
    );
  }
}
