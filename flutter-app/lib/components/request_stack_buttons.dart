import 'package:flutter/material.dart';
import 'package:gentle/app.dart';
import 'package:gentle/components/Buttons/reply_button.dart';
import 'package:gentle/components/Buttons/small_button.dart';
import 'package:gentle/components/Buttons/small_red_button.dart';
import 'package:gentle/components/Particles/circle_particle.dart';
import 'package:gentle/components/Particles/dot_particle.dart';
import 'package:gentle/components/Particles/plus_particle.dart';
import 'package:gentle/components/Particles/rect_particle.dart';
import 'package:gentle/components/report_bottomsheet.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/models/report_model.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:gentle/providers/request_stack_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class RequestStackButtons extends StatefulWidget {
  @override
  _RequestStackButtonsState createState() => _RequestStackButtonsState();
}

class _RequestStackButtonsState extends State<RequestStackButtons>
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

  void _handleReportPressed() {
    final stackProvider =
        Provider.of<RequestStackProvider>(context, listen: false);
    final currentRequest = stackProvider.currentRequest;

    ReportBottomSheet.show(
      context: context,
      contentToReportID: stackProvider.currentRequest.id,
      contentToReportCreatorID: stackProvider.currentRequest.requesterID,
      contentToReportType: ContentType.request,
      contentToReportExcerpt: currentRequest.requestMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final stackProvider = Provider.of<RequestStackProvider>(context);

    final isActive = stackProvider.status == RequestStackStatus.active;
    return Positioned(
      bottom: 0.0,
      child: RepaintBoundary(
        child: IgnorePointer(
          ignoring: !isActive,
          child: TweenAnimationBuilder(
            tween: Tween(begin: 0.8, end: isActive ? 1.0 : 0.8),
            duration: isActive
                ? Constants.weightyAnimDuration
                : Constants.fastAnimDuration,
            curve: isActive ? Curves.fastLinearToSlowEaseIn : Curves.easeIn,
            builder: (_, double scale, child) => Transform(
              transform: Matrix4.identity()..scale(scale, scale, 1.0),
              alignment: FractionalOffset.center,
              child: child,
            ),
            child: AnimatedOpacity(
              curve: isActive ? Curves.fastLinearToSlowEaseIn : Curves.easeIn,
              duration: isActive
                  ? Constants.weightyAnimDuration
                  : Constants.fastAnimDuration,
              opacity: isActive ? 1.0 : 0.0,
              child: SizedBox(
                height: Constants.screenActionButtonAreaHeight,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SmallRedButton(
                      icon: const AssetImage(
                          'assets/images/icons/32x32/flag.png'),
                      label: UIStrings.reportRequest,
                      onPressed: _handleReportPressed,
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    TickerMode(
                      enabled: isActive,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          if (_isActiveRoute) _buildBehindParticles(),
                          _buildHero(stackProvider.currentRequest),
                          if (_isActiveRoute) _buildInFrontParticles(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    Stack(
                      children: <Widget>[
                        SmallButton(
                          icon: const AssetImage(
                              'assets/images/icons/32x32/skip.png'),
                          label: UIStrings.skipRequest,
                          onPressed: stackProvider.popRequest,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Hero _buildHero(RequestItemModel item) {
    return Hero(
      tag: HeroTags.composeReply,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
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
      child: ReplyButton(
        requestItem: item,
      ),
    );
  }

  Widget _buildBehindParticles() {
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
                  offset: Offset(90.0, 10.0),
                  delay: Duration(seconds: 2),
                ),
                CircleParticle(
                  offset: Offset(15.0, 35.0),
                ),
                PlusParticle(
                  offset: Offset(100.0, 80.0),
                  delay: Duration(seconds: 3),
                ),
                DotParticle(
                  offset: Offset(15.0, 25.0),
                  delay: Duration(seconds: 8),
                ),
              ],
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
                  offset: Offset(14.0, 90.0),
                  horizontal: true,
                ),
                CircleParticle(
                  offset: Offset(70.0, 100.0),
                  delay: Duration(seconds: 5),
                ),
                PlusParticle(
                  offset: Offset(10.0, 55.0),
                ),
                DotParticle(
                  offset: Offset(110.0, 72.0),
                ),
                DotParticle(
                  offset: Offset(88.0, 110.0),
                  delay: Duration(seconds: 8),
                ),
                DotParticle(
                  offset: Offset(50.0, 5.0),
                  delay: Duration(seconds: 2),
                ),
                DotParticle(
                  offset: Offset(110.0, 32.0),
                  delay: Duration(seconds: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
