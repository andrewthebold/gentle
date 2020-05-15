import 'dart:math';

import 'package:gentle/components/avatar.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/route_generator.dart';
import 'package:gentle/components/Envelope/envelope_full.dart';
import 'package:gentle/components/Envelope/envelope_placeholder.dart';
import 'package:gentle/models/inbox_item_model.dart';
import 'package:gentle/providers/inbox_slot_provider.dart';
import 'package:gentle/providers/sliver_inbox_section_provider.dart';
import 'package:gentle/screens/letter_screen.dart';
import 'package:flutter/material.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InboxSlot extends StatefulWidget {
  static const int maxRotation = 3;

  final int slotIndex;

  const InboxSlot({
    Key key,
    @required this.slotIndex,
  })  : assert(slotIndex != null && slotIndex >= 0),
        super(key: key);

  @override
  _InboxSlotState createState() => _InboxSlotState();
}

class _InboxSlotState extends State<InboxSlot> {
  @override
  Widget build(BuildContext context) {
    final random = Random(widget.slotIndex);
    final rotationAngle =
        random.nextInt(InboxSlot.maxRotation * 2) - InboxSlot.maxRotation;

    final inboxProvider = Provider.of<SliverInboxSectionProvider>(context);
    final slotProvider = inboxProvider.getSlotProvider(widget.slotIndex);

    return ChangeNotifierProvider<InboxSlotProvider>.value(
      key: ValueKey(widget.slotIndex),
      value: slotProvider,
      child: Consumer<InboxSlotProvider>(
        builder: (_, provider, __) {
          final currentItem = provider.currentItem;
          final envelopeVisible = provider.envelopeVisible;

          return Stack(
            children: <Widget>[
              AnimatedOpacity(
                opacity: envelopeVisible ? 0.0 : 1.0,
                duration: Constants.envelopeAppearDuration,
                child: Transform.rotate(
                  angle: rotationAngle * pi / 180,
                  child: EnvelopePlaceholder(),
                ),
              ),
              TweenAnimationBuilder(
                tween:
                    Tween<double>(begin: 0.0, end: envelopeVisible ? 1.0 : 0.8),
                curve:
                    !envelopeVisible ? Curves.easeInExpo : Curves.easeOutExpo,
                duration: Constants.envelopeAppearDuration,
                builder: (_, double scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: AnimatedOpacity(
                  opacity: envelopeVisible ? 1.0 : 0.0,
                  duration: Constants.envelopeAppearDuration,
                  child: _EnvelopeWrapper(
                    item: currentItem,
                    rotationAngle: rotationAngle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EnvelopeWrapper extends StatefulWidget {
  final InboxItemModel item;
  final int rotationAngle;

  const _EnvelopeWrapper({
    Key key,
    @required this.item,
    @required this.rotationAngle,
  }) : super(key: key);

  @override
  __EnvelopeWrapperState createState() => __EnvelopeWrapperState();
}

class __EnvelopeWrapperState extends State<_EnvelopeWrapper> {
  bool _heldDown = false;

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

  Future<void> _handleTap() async {
    await Navigator.of(context).pushNamed(
      LetterScreen.routeName,
      arguments: LetterScreenArguments(
        letterIDs: [widget.item.linkedContentID],
        shouldShowRequest: widget.item.linkedContentAvatar != AvatarName.gentle,
      ),
    );

    final scrollController =
        Provider.of<ScrollController>(context, listen: false);

    // After closing the route...
    final slotProvider = Provider.of<InboxSlotProvider>(context, listen: false);
    if (!slotProvider.markingRead && !slotProvider.isEmpty) {
      await slotProvider.markRead(context: context);
    }

    final prefs = await SharedPreferences.getInstance();
    final hasSeenMailboxHistory =
        prefs.getBool(SharedPreferenceKeys.hasSeenMailboxHistory) ?? false;

    if (hasSeenMailboxHistory) {
      return;
    }

    // Animate to reveal the history section if this is the first time you've
    // opened mail — teaching moment. May be too "clever" so it'll need testing.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await scrollController.animateTo(
      200, // Magic number — feels good enough
      duration: Constants.heaviestAnimDuration,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    await scrollController.animateTo(
      0,
      duration: Constants.heaviestAnimDuration,
      curve: Curves.fastLinearToSlowEaseIn,
    );

    prefs.setBool(SharedPreferenceKeys.hasSeenMailboxHistory, true);
  }

  Widget _buildHero() {
    if (widget.item == null) {
      return Container();
    }

    return Hero(
      tag: LetterScreen.heroTagGenerator(widget.item.linkedContentID),
      flightShuttleBuilder: (BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext) {
        final Hero fromHero = fromHeroContext.widget as Hero;
        final Hero toHero = toHeroContext.widget as Hero;

        final reverseAnimation = animation.drive(Tween(begin: 1.0, end: 0.0));

        final bool isPush = flightDirection == HeroFlightDirection.push;

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
              color: Palette.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Palette.grayPrimary,
                width: 1,
              ),
            ),
            end: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Palette.graySecondary,
                width: 1,
              ),
            ),
          ),
        );

        final rotationAnimation = animation
            .drive(Tween(begin: widget.rotationAngle * pi / 180, end: 0.0));

        Widget fromHeroChild = fromHero.child;
        Widget toHeroChild = toHero.child;

        // Cancel out the rotation of the inbox item so we
        // don't double the rotation in the flight shuttle.
        if (isPush) {
          fromHeroChild = Transform.rotate(
            angle: -widget.rotationAngle * pi / 180,
            child: fromHeroChild,
          );
        } else {
          toHeroChild = Transform.rotate(
            angle: -widget.rotationAngle * pi / 180,
            child: toHeroChild,
          );
        }

        return Material(
          color: Palette.transparent,
          child: AnimatedBuilder(
            animation: rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: rotationAnimation.value.toDouble(),
                child: DecoratedBoxTransition(
                  decoration: decorationAnimation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      FadeTransition(
                        opacity: fromHeroAnimation,
                        child: fromHeroChild,
                      ),
                      FadeTransition(
                        opacity: toHeroAnimation,
                        child: toHeroChild,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      child: Transform.rotate(
        angle: widget.rotationAngle * pi / 180,
        child: Envelope(inboxItem: widget.item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slotProvider = Provider.of<InboxSlotProvider>(context, listen: false);
    final interactable = slotProvider.interactable;

    return Listener(
      onPointerDown: interactable ? _handlePointerDown : null,
      onPointerUp: interactable ? _handlePointerUp : null,
      child: GestureDetector(
        onTapCancel: interactable ? _handleTapCancel : null,
        onTap: interactable ? _handleTap : null,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: !_heldDown ? 1.0 : 0.95),
          duration: const Duration(milliseconds: 100),
          builder: (_, double scale, Widget child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: _buildHero(),
        ),
      ),
    );
  }
}
