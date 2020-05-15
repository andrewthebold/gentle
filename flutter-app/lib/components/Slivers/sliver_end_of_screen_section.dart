import 'package:flutter/material.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';

class SliverEndOfScreenSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedOverflowBox(
        alignment: Alignment.topCenter,
        size: Size(
          double.infinity,
          MediaQuery.of(context).padding.bottom + Constants.sliverDividerHeight,
        ),
        child: Container(
          height: 1000,
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
              color: Palette.dividerBGBorder,
              width: 1,
            )),
            color: Palette.dividerBG,
          ),
        ),
      ),
    );
  }
}
