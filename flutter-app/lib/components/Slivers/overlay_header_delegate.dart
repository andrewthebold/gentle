import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gentle/theme.dart';

class OverlayHeader extends StatelessWidget {
  static const double stretchTrigger = 75.0;
  static const double height = 44.0;

  final List<Widget> actions;
  final bool visible;
  final bool canTriggerPop;

  const OverlayHeader({
    Key key,
    @required this.actions,
    this.visible = true,
    this.canTriggerPop = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: SliverPersistentHeader(
        pinned: true,
        delegate: _OverlayHeaderDelegate(
          actions: actions,
          topPadding: topPadding,
          visible: visible,
          canTriggerPop: canTriggerPop,
        ),
      ),
    );
  }
}

class _OverlayHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double topPadding;
  final List<Widget> actions;
  final bool visible;
  final bool canTriggerPop;

  _OverlayHeaderDelegate({
    @required this.actions,
    @required this.topPadding,
    @required this.visible,
    @required this.canTriggerPop,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final currentExtent = max(minExtent, maxExtent - shrinkOffset);
      final stretchDelta = constraints.maxHeight - currentExtent;

      final opacityT = ((stretchDelta - OverlayHeader.stretchTrigger + 40.0) /
              OverlayHeader.stretchTrigger)
          .clamp(0.0, 1.0)
          .toDouble();

      final reachedStretchTrigger =
          stretchDelta >= OverlayHeader.stretchTrigger;

      return AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Stack(children: <Widget>[
          const DecoratedBox(
            decoration: BoxDecoration(
                color: Palette.white,
                border: Border(
                    bottom: BorderSide(
                  color: Palette.grayTertiary,
                  width: 1,
                )),
                boxShadow: [GentleShadow.basicReverse]),
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: reachedStretchTrigger && canTriggerPop ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: Opacity(
                  opacity: canTriggerPop ? 1.0 - opacityT : 1.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: actions,
                  ),
                ),
              ),
            ),
          ),
          if (canTriggerPop)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity: reachedStretchTrigger ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 100),
                    child: const Text(
                      'Release to close',
                      style: GentleText.appBarDefaultButtonLabel,
                    ),
                  ),
                ),
              ),
            ),
        ]),
      );
    });
  }

  @override
  final OverScrollHeaderStretchConfiguration stretchConfiguration =
      OverScrollHeaderStretchConfiguration();

  @override
  double get maxExtent => minExtent;

  @override
  double get minExtent => topPadding + OverlayHeader.height;

  @override
  bool shouldRebuild(_OverlayHeaderDelegate oldDelegate) {
    if (oldDelegate.visible != visible) {
      return true;
    }

    if (!listEquals(oldDelegate.actions, actions)) {
      return true;
    }

    return false;
  }
}
