import 'package:gentle/components/Slivers/sliver_inbox_grid.dart';
import 'package:gentle/components/Slivers/tab_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:gentle/constants.dart';

class SliverInboxSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (_, __) {
        final verticalScreenHeight = MediaQuery.of(context).size.height;
        var tallScreenExtraSpace = 0.0;
        if (verticalScreenHeight > 640.0) {
          tallScreenExtraSpace += 20.0;
        }

        final horizontalScreenWidth = MediaQuery.of(context).size.width -
            (InboxGridSliver.horizontalPadding * 2.0);

        final sliverHeight = verticalScreenHeight -
            MediaQuery.of(context).padding.top -
            tallScreenExtraSpace -
            TabHeader.maxExtent -
            Constants.screenActionButtonAreaHeight -
            Constants.sliverDividerHeight -
            InboxGridSliver.topPadding -
            InboxGridSliver.bottomPadding -
            MediaQuery.of(context).padding.bottom;

        return InboxGridSliver(
          availableHeight: sliverHeight,
          availableWidth: horizontalScreenWidth,
        );
      },
    );
  }
}
