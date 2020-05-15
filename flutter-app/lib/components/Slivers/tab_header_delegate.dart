import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/theme.dart';

class TabHeader extends StatelessWidget {
  static const maxExtent = TabHeader.minExtent + 24.0;
  static const minExtent = 44.0;

  final Widget title;
  final Widget actionChild;

  const TabHeader({Key key, @required this.title, this.actionChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final verticalScreenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    var tallScreenExtraSpace = 0.0;
    if (verticalScreenHeight > 650.0) {
      tallScreenExtraSpace += 20.0;
    }

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: SliverPersistentHeader(
        pinned: true,
        delegate: _TabHeaderDelegate(
          title: title,
          topPadding: topPadding,
          tallScreenExtraSpace: tallScreenExtraSpace,
          actionChild: actionChild,
        ),
      ),
    );
  }
}

class _TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget title;
  final double topPadding;
  final double tallScreenExtraSpace;
  final Widget actionChild;

  _TabHeaderDelegate({
    @required this.title,
    @required this.topPadding,
    @required this.tallScreenExtraSpace,
    this.actionChild,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final currentExtent = max(minExtent, maxExtent - shrinkOffset);
        final deltaExtent = maxExtent - minExtent;

        final opacityT = (1.0 - (currentExtent - minExtent) / deltaExtent)
            .clamp(0, 1.0)
            .toDouble();
        final bgOpacity =
            Tween<double>(begin: 0.0, end: 1.0).transform(opacityT);

        // Make the stretched value go towards a limit.
        // Square-root feels good enough.
        final stretchDelta = constraints.maxHeight - currentExtent;
        final flattenedStretchDelta = sqrt(stretchDelta);

        final scaleT = (1.0 -
                (currentExtent + flattenedStretchDelta - minExtent) /
                    deltaExtent)
            .clamp(-1.0, 1.0)
            .toDouble();
        final scaleValue =
            Tween<double>(begin: 1.0, end: 0.5).transform(scaleT);
        final scaleTransform = Matrix4.identity()
          ..scale(scaleValue, scaleValue, 1.0);

        return Stack(
          children: <Widget>[
            Opacity(
                opacity: bgOpacity,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                      color: Palette.white,
                      border: Border(
                          bottom: BorderSide(
                        color: Palette.grayTertiary,
                        width: 1,
                      )),
                      boxShadow: [GentleShadow.basicReverse]),
                  child: SizedBox.expand(),
                )),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                  child: Transform(
                    alignment: Alignment.centerLeft,
                    transform: scaleTransform,
                    child: title,
                  ),
                ),
              ),
            ),
            if (actionChild != null)
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 16,
                    ),
                    height: 44,
                    width: 100,
                    child: actionChild,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  final OverScrollHeaderStretchConfiguration stretchConfiguration =
      OverScrollHeaderStretchConfiguration();

  @override
  double get maxExtent =>
      topPadding + tallScreenExtraSpace + TabHeader.maxExtent;

  @override
  double get minExtent => topPadding + TabHeader.minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
