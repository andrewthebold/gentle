import 'dart:async';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gentle/theme.dart';
import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/components/reaction_chip.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/providers/local_reaction_provider.dart';
import 'package:gentle/providers/reaction_stack_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ReactionStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider2<UserProvider, LocalReactionProvider,
        ReactionStackProvider>(
      create: (_) => ReactionStackProvider(),
      update: (_, userProvider, localReactionProvider, reactionStackProvider) =>
          reactionStackProvider
            ..updateDependentData(
              user: userProvider.user,
              localReactionProvider: localReactionProvider,
            ),
      child: const _ReactionStackBody(),
    );
  }
}

class _ReactionStackBody extends StatelessWidget {
  const _ReactionStackBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stackProvider = Provider.of<ReactionStackProvider>(context);

    return ScaleButton(
      label: 'View Reactions',
      onPressed: () {
        stackProvider.openStack(context);
      },
      child: RepaintBoundary(
        child: Builder(builder: (_) {
          final reactions = stackProvider.reactions;

          if (reactions.isEmpty) {
            return Container();
          }

          final stack = <_AnimatedChip>[];

          // We only care about the first 4 reactions
          final count =
              min(reactions.length, Constants.reactionStackMaxVisibleSize + 1);
          for (var i = count - 1; i >= 0; i--) {
            // Location order (x-axis): 3, 2, 1, 0
            final location = count - 1 - i;

            stack.add(_AnimatedChip(
              key: ValueKey(reactions[i].hashCode),
              location: location,
              index: i,
              stackHasEllipsis: count > Constants.reactionStackMaxVisibleSize,
              reaction: reactions[i],
            ));
          }

          return Stack(
            overflow: Overflow.visible,
            alignment: Alignment.centerRight,
            children: stack,
          );
        }),
      ),
    );
  }
}

class _AnimatedChip extends StatefulWidget {
  const _AnimatedChip({
    Key key,
    @required this.location,
    @required this.index,
    @required this.stackHasEllipsis,
    @required this.reaction,
  }) : super(key: key);

  final int location;
  final int index;
  final bool stackHasEllipsis;
  final ReactionInboxItemModel reaction;

  @override
  __AnimatedChipState createState() => __AnimatedChipState();
}

class __AnimatedChipState extends State<_AnimatedChip> {
  bool _initialized = false;
  Timer _staggeredSlideInTimer;

  @override
  void initState() {
    super.initState();

    _staggeredSlideInTimer =
        Timer.periodic(Duration(milliseconds: 100 * widget.index), (timer) {
      if (!mounted) {
        return;
      }
      if (_staggeredSlideInTimer != null) {
        _staggeredSlideInTimer.cancel();
        _staggeredSlideInTimer = null;
      }
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

  double _getPosX() {
    double posX = 0;

    // If we're showing an ellipsis chip, we offset the actual chips by a
    // bit to make it more visible.
    switch (widget.location) {
      case 3:
        posX = widget.stackHasEllipsis ? 52 : 48;
        break;
      case 2:
        posX = widget.stackHasEllipsis ? 36 : 32;
        break;
      case 1:
        posX = widget.stackHasEllipsis ? 20 : 16;
        break;
      case 0:
        posX = 0;
        break;
    }

    if (!_initialized) {
      return posX - 24;
    }

    return posX;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (widget.stackHasEllipsis && widget.location == 0) {
      child = _EllipsisChip();
    } else {
      child = ReactionChip(type: widget.reaction.type);
    }

    final posX = _getPosX();
    return AnimatedPositioned(
      curve: Curves.fastOutSlowIn,
      duration: Constants.weightyAnimDuration,
      right: posX,
      bottom: 8,
      child: AnimatedOpacity(
        duration: Constants.fastAnimDuration,
        opacity: _initialized ? 1.0 : 0.0,
        child: child,
      ),
    );
  }
}

class _EllipsisChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: DottedBorder(
        borderType: BorderType.Circle,
        color: Palette.grayTertiary,
        dashPattern: const [4, 6],
        padding: const EdgeInsets.all(0),
        radius: const Radius.circular(16),
        strokeCap: StrokeCap.round,
        strokeWidth: 1,
        child: Container(
          padding: const EdgeInsets.only(left: 2),
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Palette.envelopePlaceholderBG,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Image(
            image: AssetImage('assets/images/icons/16x16/ellipsis.png'),
            height: 16,
            width: 16,
          ),
        ),
      ),
    );
  }
}
