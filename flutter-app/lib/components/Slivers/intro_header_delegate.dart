import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/components/Particles/circle_particle.dart';
import 'package:gentle/components/Particles/dot_particle.dart';
import 'package:gentle/components/Particles/plus_particle.dart';
import 'package:gentle/components/Particles/rect_particle.dart';
import 'package:gentle/theme.dart';

class IntroHeader extends StatelessWidget {
  static const maxExtent = 240.0;
  static const minExtent = 44.0;

  const IntroHeader({Key key}) : super(key: key);

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
        delegate: _IntroHeaderDelegate(
          topPadding: topPadding,
          tallScreenExtraSpace: tallScreenExtraSpace,
        ),
      ),
    );
  }
}

class _IntroHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double topPadding;
  final double tallScreenExtraSpace;

  _IntroHeaderDelegate(
      {@required this.topPadding, @required this.tallScreenExtraSpace});

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

        final illustrationOpacityT =
            (1.0 - (deltaExtent - (currentExtent - minExtent)) / 80)
                .clamp(0, 1.0)
                .toDouble();
        final illustrationOpacity =
            Tween<double>(begin: 0.0, end: 1.0).transform(illustrationOpacityT);

        final centerX = MediaQuery.of(context).size.width / 2;

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
                      ),
                    ),
                    boxShadow: [GentleShadow.basicReverse]),
                child: SizedBox.expand(),
              ),
            ),
            if (illustrationOpacity > 0.0)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 48),
                child: Opacity(
                  opacity: illustrationOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            RectParticle(
                              horizontal: true,
                              offset: Offset(centerX - 90, 40),
                            ),
                            RectParticle(
                              offset: Offset(centerX + 60, 30),
                              delay: const Duration(seconds: 3),
                            ),
                            CircleParticle(
                              offset: Offset(centerX - 80.0, 15.0),
                            ),
                            CircleParticle(
                              offset: Offset(centerX + 12.0, 85.0),
                              delay: const Duration(seconds: 3),
                            ),
                            PlusParticle(
                              offset: Offset(centerX - 30.0, 0),
                              delay: const Duration(seconds: 3),
                            ),
                            PlusParticle(
                              offset: Offset(centerX + 70.0, 80),
                              delay: const Duration(seconds: 7),
                            ),
                            DotParticle(
                              offset: Offset(centerX + 100.0, 60.0),
                              delay: const Duration(seconds: 3),
                            ),
                            DotParticle(
                              offset: Offset(centerX - 120.0, 60.0),
                              delay: const Duration(seconds: 7),
                            ),
                            DotParticle(
                              offset: Offset(centerX + 40.0, 20.0),
                            ),
                            DotParticle(
                              offset: Offset(centerX - 20.0, 90.0),
                              delay: const Duration(seconds: 5),
                            ),
                            const Image(
                              height: 80,
                              width: 80,
                              image: AssetImage(
                                  'assets/images/illustrations/intro_logo.png'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: scaleTransform,
                    child:
                        const Text('Welcome', style: GentleText.headlineText),
                  ),
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
      topPadding + tallScreenExtraSpace + IntroHeader.maxExtent;

  @override
  double get minExtent => topPadding + IntroHeader.minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
