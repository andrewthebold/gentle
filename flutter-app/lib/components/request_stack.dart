import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/Request/request_card.dart';
import 'package:gentle/components/request_stack_buttons.dart';
import 'package:gentle/components/screen_loading_indicator.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:gentle/providers/request_stack_provider.dart';
import 'package:gentle/route_generator.dart';
import 'package:gentle/screens/letter_compose_screen.dart';
import 'package:provider/provider.dart';

class RequestStack extends StatefulWidget {
  final double availableHeight;

  const RequestStack({
    Key key,
    @required this.availableHeight,
  })  : assert(availableHeight != null),
        super(key: key);

  @override
  _RequestStackState createState() => _RequestStackState();
}

class _RequestStackState extends State<RequestStack> {
  @override
  Widget build(BuildContext context) {
    final stackProvider = Provider.of<RequestStackProvider>(context);

    return RepaintBoundary(
      child: AnimatedCrossFade(
        duration: Constants.mediumAnimDuration,
        firstChild: ScreenLoadingIndicator(
          height: widget.availableHeight,
          enabled: stackProvider.status == RequestStackStatus.loading,
        ),
        secondChild: Container(
          height: widget.availableHeight,
          child: Builder(
            builder: (_) {
              final requests = stackProvider.requests;

              final stack = <_StackCard>[];
              for (var i = requests.length - 1; i >= 0; i--) {
                final cursor = stackProvider.cursor;
                // -1 indicates that the card has "popped" and animated out upwards
                final location = max(i - cursor, -1);

                // We don't need to render cards that aren't visible (or haven't just animated out)
                if (i - cursor <= -2 || i - cursor > 4) {
                  continue;
                }

                stack.add(_StackCard(
                  key: ValueKey(requests[i].hashCode),
                  location: location,
                  item: requests[i],
                  availableHeight: widget.availableHeight,
                ));
              }

              return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  ...stack,
                  RequestStackButtons(),
                ],
              );
            },
          ),
        ),
        crossFadeState: stackProvider.status == RequestStackStatus.loading
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
  }
}

class _StackCard extends StatefulWidget {
  final RequestItemModel item;
  final int location;
  final double availableHeight;

  const _StackCard({
    Key key,
    @required this.item,
    @required this.location,
    @required this.availableHeight,
  })  : assert(item != null),
        super(key: key);

  @override
  __StackCardState createState() => __StackCardState();
}

class __StackCardState extends State<_StackCard> {
  bool _initialized = false;
  bool _heldDown = false;
  Timer _staggeredSlideInTimer;

  @override
  void initState() {
    super.initState();

    _staggeredSlideInTimer =
        Timer.periodic(Duration(milliseconds: 100 * widget.location), (_) {
      _staggeredSlideInTimer.cancel();
      _staggeredSlideInTimer = null;

      setState(() {
        _initialized = true;
      });
    });
  }

  @override
  void dispose() {
    if (_staggeredSlideInTimer != null) {
      _staggeredSlideInTimer.cancel();
      _staggeredSlideInTimer = null;
    }
    super.dispose();
  }

  void _handlePointerDown(PointerDownEvent _) {
    setState(() {
      _heldDown = true;
    });
  }

  void _handlePointerUp(PointerUpEvent _) {
    setState(() {
      _heldDown = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _heldDown = false;
    });
  }

  double _calcYOffset() {
    const top = 8.0;
    const bottom = 8.0;

    if (widget.location < 0) {
      return -widget.availableHeight / 8;
    }

    final spaceAfterBottomOfFirstCard =
        widget.availableHeight - top - Constants.requestCardHeight - bottom;

    // 0%   ->  0 * 0.05
    // 10%  ->  1 * 0.10
    // 30%  ->  2 * 0.15
    // 60%  ->  3 * 0.20
    // 100% ->  4 * 0.25

    final multiplier = (widget.location + 1) * 0.05;
    final yOffset =
        top + (widget.location * multiplier * spaceAfterBottomOfFirstCard);

    if (!_initialized) {
      // For the staggered transition in, start with an extra offset (arbitrary #)
      return yOffset + (Constants.requestCardHeight / 2);
    }

    return yOffset;
  }

  double _calcOpacity() {
    // For staggered transition in, start at 0 opacity
    if (!_initialized) {
      return 0;
    }

    switch (widget.location) {
      case 0:
        return 1.0;
      case 1:
        return 0.5;
      case 2:
        return 0.25;
      case 3:
        return 0.125;
      case 4:
        return 0.0;
    }

    return 0;
  }

  double _calcRotation() {
    if (widget.location <= 0) {
      return 0.0;
    }

    return (Random(widget.item.hashCode).nextInt(6) - 3).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      width: MediaQuery.of(context).size.width - 12,
      duration: Constants.weightyAnimDuration,
      curve: Curves.fastOutSlowIn,
      top: _calcYOffset(),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: _calcRotation(), end: _calcRotation()),
        duration: Constants.fastAnimDuration,
        builder: (_, double angle, child) => Transform.rotate(
          angle: angle * pi / 180,
          child: child,
        ),
        child: AnimatedOpacity(
          duration: Constants.fastAnimDuration,
          opacity: _calcOpacity(),
          child: IgnorePointer(
            ignoring: widget.location != 0,
            child: Listener(
              onPointerDown: _handlePointerDown,
              onPointerUp: _handlePointerUp,
              child: GestureDetector(
                onTapCancel: _handleTapCancel,
                onTap: () {
                  if (widget.item == null) {
                    return;
                  }

                  Navigator.of(context).pushNamed(LetterComposeScreen.routeName,
                      arguments: LetterComposeScreenArguments(
                        requestItem: widget.item,
                      ));
                },
                child: TweenAnimationBuilder(
                  tween:
                      Tween<double>(begin: 0.0, end: !_heldDown ? 1.0 : 0.98),
                  duration: const Duration(milliseconds: 100),
                  builder: (_, double scale, Widget child) {
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: RequestCard(
                    text: widget.item.requestMessage,
                    avatarName: widget.item.requesterAvatar,
                    status: widget.location <= 1
                        ? RequestCardStatus.visible
                        : RequestCardStatus.hidden,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
