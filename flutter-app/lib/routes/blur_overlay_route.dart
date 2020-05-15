import 'dart:ui' as ui;

import 'package:gentle/constants.dart';
import 'package:gentle/services/device_info_service.dart';
import 'package:gentle/services/service_locator.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BlurOverlayRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  BlurOverlayRoute({@required this.builder});

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    assert(result != null);

    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final isPop = animation.status == AnimationStatus.reverse;

    final isLowPowered = sl<DeviceInfoService>().isLowPowerDevice;

    return RepaintBoundary(
      child: Stack(
        children: <Widget>[
          // Frosted BG
          if (!isLowPowered)
            FrostTransition(
              animation: Tween(begin: 0.0, end: 20.0)
                  .chain(
                      CurveTween(curve: isPop ? Curves.easeIn : Curves.linear))
                  .animate(animation),
            ),

          // The new route, wrapped with animations and a bg
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, isPop ? 0.01 : 0.5),
              end: Offset.zero,
            )
                .chain(CurveTween(
                    curve: isPop
                        ? Curves.decelerate
                        : Curves.fastLinearToSlowEaseIn))
                .animate(animation),
            child: FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0)
                  .chain(CurveTween(
                      curve: isPop
                          ? isLowPowered
                              ? Curves.fastOutSlowIn
                              : Curves.easeInExpo
                          : Curves.linear))
                  .animate(animation),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isLowPowered ? Palette.white : Palette.blurBG,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Constants.routeChangeDuration;
}

class FrostTransition extends AnimatedWidget {
  final Animation<double> animation;

  const FrostTransition({@required this.animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
              sigmaX: animation.value, sigmaY: animation.value),
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Palette.transparent,
            ),
            child: SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
