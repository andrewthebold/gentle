import 'package:gentle/app.dart';
import 'package:gentle/components/Buttons/compose_button.dart';
import 'package:flutter/material.dart';
import 'package:gentle/components/Particles/circle_particle.dart';
import 'package:gentle/components/Particles/dot_particle.dart';
import 'package:gentle/components/Particles/plus_particle.dart';
import 'package:gentle/components/Particles/rect_particle.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';

class SliverComposeButtonSection extends StatefulWidget {
  @override
  _SliverComposeButtonSectionState createState() =>
      _SliverComposeButtonSectionState();
}

class _SliverComposeButtonSectionState extends State<SliverComposeButtonSection>
    with RouteAware {
  bool _isActiveRoute = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    // Route was pushed onto navigator and is now topmost route.
    setState(() {
      _isActiveRoute = false;
    });
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    setState(() {
      _isActiveRoute = true;
    });
  }

  Widget _buildBehindParticles() {
    return RepaintBoundary(
      child: AnimatedOpacity(
        opacity: _isActiveRoute ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        child: TickerMode(
          enabled: _isActiveRoute,
          child: SizedOverflowBox(
            alignment: Alignment.center,
            size: const Size.square(Constants.floatingButtonDiameter),
            child: SizedBox(
              height: Constants.floatingButtonDiameter + 40,
              width: Constants.floatingButtonDiameter + 40,
              child: Stack(
                children: const <Widget>[
                  RectParticle(
                    offset: Offset(80.0, 90.0),
                    delay: Duration(seconds: 2),
                  ),
                  CircleParticle(
                    offset: Offset(12.0, 85.0),
                  ),
                  PlusParticle(
                    offset: Offset(6.0, 60.0),
                    delay: Duration(seconds: 3),
                  ),
                  DotParticle(
                    offset: Offset(5.0, 75.0),
                    delay: Duration(seconds: 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInFrontParticles() {
    return AnimatedOpacity(
      opacity: _isActiveRoute ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: TickerMode(
        enabled: _isActiveRoute,
        child: SizedOverflowBox(
          alignment: Alignment.center,
          size: const Size.square(Constants.floatingButtonDiameter),
          child: SizedBox(
            height: Constants.floatingButtonDiameter + 40,
            width: Constants.floatingButtonDiameter + 40,
            child: Stack(
              children: const <Widget>[
                RectParticle(
                  offset: Offset(14.0, 36.0),
                  horizontal: true,
                ),
                CircleParticle(
                  offset: Offset(102.0, 46.0),
                  delay: Duration(seconds: 5),
                ),
                PlusParticle(
                  offset: Offset(104.0, 104.0),
                ),
                DotParticle(
                  offset: Offset(110.0, 72.0),
                ),
                DotParticle(
                  offset: Offset(88.0, 110.0),
                  delay: Duration(seconds: 5),
                ),
                DotParticle(
                  offset: Offset(28.0, 27.0),
                  delay: Duration(seconds: 1),
                ),
                DotParticle(
                  offset: Offset(110.0, 32.0),
                  delay: Duration(seconds: 9),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero({Widget child}) {
    return Hero(
      tag: HeroTags.composeRequest,
      flightShuttleBuilder: (BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext) {
        final fromHero = fromHeroContext.widget as Hero;
        final toHero = toHeroContext.widget as Hero;

        final reverseAnimation = animation.drive(Tween(begin: 1.0, end: 0.0));

        final isPush = flightDirection == HeroFlightDirection.push;

        final fromHeroAnimation = CurvedAnimation(
          parent: isPush ? reverseAnimation : animation,
          curve: Curves.easeInExpo,
        );

        final toHeroAnimation = CurvedAnimation(
          parent: isPush ? animation : reverseAnimation,
          curve: Curves.easeInExpo,
        );

        final decorationAnimation = animation.drive(
          DecorationTween(
            begin: BoxDecoration(
              color: Palette.blue,
              borderRadius: BorderRadius.circular(
                Constants.floatingButtonDiameter / 2,
              ),
              border: Border.all(
                color: Palette.transparent,
                width: 1,
              ),
            ),
            end: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Palette.graySecondary,
                width: 1,
              ),
            ),
          ),
        );

        return Material(
          color: Palette.transparent,
          child: DecoratedBoxTransition(
            decoration: decorationAnimation,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                FadeTransition(
                    opacity: fromHeroAnimation, child: fromHero.child),
                FadeTransition(
                  opacity: toHeroAnimation,
                  child: toHero.child,
                ),
              ],
            ),
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: Constants.screenActionButtonAreaHeight,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (_isActiveRoute) _buildBehindParticles(),
            _buildHero(child: ComposeButton()),
            if (_isActiveRoute) _buildInFrontParticles(),
          ],
        ),
      ),
    );
  }
}
