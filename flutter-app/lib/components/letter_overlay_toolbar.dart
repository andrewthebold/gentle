import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/reaction_bottomsheet.dart';
import 'package:gentle/components/Buttons/floating_done_button.dart';
import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/components/avatar.dart';
import 'package:gentle/components/reaction_chip.dart';
import 'package:gentle/components/reaction_icon.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/providers/letter_screen_provider.dart';
import 'package:gentle/providers/local_reaction_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class LetterOverlayToolbar extends StatefulWidget {
  const LetterOverlayToolbar({
    Key key,
    @required this.onPressedDone,
    @required this.readyToShowContent,
  }) : super(key: key);

  final VoidCallback onPressedDone;
  final bool readyToShowContent;

  @override
  _LetterOverlayToolbarState createState() => _LetterOverlayToolbarState();
}

class _LetterOverlayToolbarState extends State<LetterOverlayToolbar> {
  void _handleReactionPressed() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final letterScreenProvider =
        Provider.of<LetterScreenProvider>(context, listen: false);
    final localReactionProvider =
        Provider.of<LocalReactionProvider>(context, listen: false);

    if (letterScreenProvider.letter != null &&
        letterScreenProvider.letter.letterSenderAvatar == AvatarName.gentle) {
      debugPrint('Attempted to open reaction sheet for official mail.');
      return;
    }

    ReactionBottomsheet.show(
      context: context,
      userProvider: userProvider,
      letterScreenProvider: letterScreenProvider,
      localReactionProvider: localReactionProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LetterScreenProvider>(context);

    final letter = provider.letter;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Positioned(
            left: 16,
            bottom: 0,
            child: IgnorePointer(
              ignoring: !provider.letterAllowsReactions ||
                  provider.letterHasReaction ||
                  !provider.userCanReactToLetter,
              child: AnimatedOpacity(
                duration: Constants.fastAnimDuration,
                opacity: widget.readyToShowContent &&
                        provider.letterAllowsReactions &&
                        !provider.letterHasReaction &&
                        provider.userCanReactToLetter
                    ? 1.0
                    : 0.0,
                child: _ReactButton(
                  onPressed: _handleReactionPressed,
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 0,
            child: IgnorePointer(
              ignoring: !provider.letterAllowsReactions ||
                  !provider.letterHasReaction,
              child: AnimatedOpacity(
                duration: Constants.fastAnimDuration,
                opacity: widget.readyToShowContent &&
                        provider.letterAllowsReactions &&
                        provider.letterHasReaction
                    ? 1.0
                    : 0.0,
                child: _ReactionCircle(
                  type: letter?.reactionType ?? ReactionType.unknown,
                  onPressed: _handleReactionPressed,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 0,
            child: IgnorePointer(
              ignoring: !provider.hasMoreLetters,
              child: AnimatedOpacity(
                duration: Constants.fastAnimDuration,
                opacity: provider.hasMoreLetters ? 1.0 : 0.0,
                child: _NextReactionButton(
                  onPressed: () => provider.onPressedNext(context),
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 0,
            child: IgnorePointer(
              ignoring: provider.hasMoreLetters,
              child: AnimatedOpacity(
                duration: Constants.fastAnimDuration,
                opacity: !provider.hasMoreLetters ? 1.0 : 0.0,
                child: FloatingDoneButton(
                  label: UIStrings.done,
                  icon: const AssetImage('assets/images/icons/24x24/check.png'),
                  onPressed: widget.onPressedDone,
                ),
              ),
            ),
          ),
          if (provider.nextLetterReaction != null)
            Positioned(
              right: 12,
              bottom: -8,
              child: IgnorePointer(
                ignoring: true,
                child: ReactionChip(
                  type: provider.nextLetterReaction,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReactButton extends StatelessWidget {
  const _ReactButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      label: 'React',
      onPressed: onPressed,
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: Palette.white,
          border: Border.all(
            color: Palette.graySecondary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [GentleShadow.basic],
        ),
        child: Center(
          child: Transform.rotate(
            angle: 5 * pi / 180,
            child: const Image(
              image: AssetImage('assets/images/icons/48x48/add_reaction.png'),
              height: 48,
              width: 48,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReactionCircle extends StatelessWidget {
  const _ReactionCircle({
    Key key,
    @required this.onPressed,
    @required this.type,
  }) : super(key: key);

  final VoidCallback onPressed;
  final ReactionType type;

  @override
  Widget build(BuildContext context) {
    if (type == ReactionType.unknown) {
      return Container();
    }

    return ScaleButton(
      onPressed: onPressed,
      label: ReactionIcon.getLabel(type),
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: Palette.white,
          border: Border.all(
            color: Palette.graySecondary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [GentleShadow.basic],
        ),
        child: Consumer<LetterScreenProvider>(
          builder: (context, letterProvider, __) => Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              if (type != null)
                ReactionIcon(
                  angle: 5,
                  type: type,
                  size: ReactionIconSize.large,
                ),
              Positioned(
                right: -12,
                bottom: -12,
                child: Container(
                  alignment: Alignment.center,
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Palette.white,
                    border: Border.all(
                      color: Palette.graySecondary,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [GentleShadow.basic],
                  ),
                  child: Transform.rotate(
                    angle: 5 * pi / 180,
                    child: Avatar(
                      avatarName: letterProvider.letter?.requestCreatorAvatar,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextReactionButton extends StatelessWidget {
  final GestureTapCallback onPressed;

  const _NextReactionButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: ScaleButton(
        onPressed: onPressed,
        label: UIStrings.done,
        child: Container(
          padding: const EdgeInsets.only(
            left: 24,
            right: 16,
          ),
          height: 52,
          decoration: BoxDecoration(
            color: Palette.white,
            border: Border.all(
              color: Palette.graySecondary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [GentleShadow.large],
          ),
          child: Row(
            children: <Widget>[
              Text('Next', style: GentleText.floatingNextButton),
              const SizedBox(width: 8),
              const Image(
                image: AssetImage('assets/images/icons/24x24/arrow_right.png'),
                height: 24,
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
