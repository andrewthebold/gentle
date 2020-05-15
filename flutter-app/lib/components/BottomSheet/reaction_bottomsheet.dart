import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_header.dart';
import 'package:gentle/components/Buttons/reaction_label_button.dart';
import 'package:gentle/components/floating_loading_indicator.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/providers/letter_screen_provider.dart';
import 'package:gentle/providers/local_reaction_provider.dart';
import 'package:gentle/providers/reaction_bottomsheet_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/theme.dart';
import 'package:gentle/time.dart';
import 'package:provider/provider.dart';

class ReactionBottomsheet extends StatelessWidget {
  static Future<void> show({
    @required BuildContext context,
    @required UserProvider userProvider,
    @required LetterScreenProvider letterScreenProvider,
    @required LocalReactionProvider localReactionProvider,
  }) async {
    // Build the bottomsheet content prior to the route transition to improve
    // performance of trying to do both at the same time
    // https://github.com/flutter/flutter/issues/31059#issuecomment-500961641
    final bottomsheetBody = await Future.microtask(() {
      return ChangeNotifierProvider(
        create: (_) => ReactionBottomsheetProvider(
          userProvider: userProvider,
          letterScreenProvider: letterScreenProvider,
          localReactionProvider: localReactionProvider,
        ),
        child: ReactionBottomsheet(),
      );
    });

    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Palette.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      builder: (_) => bottomsheetBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReactionBottomsheetProvider>(context);
    final currentReaction = provider.currentReaction;

    return Stack(
      children: <Widget>[
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Consumer<UserProvider>(builder: (context, userProvider, __) {
                String label = "Send a reaction";
                if (currentReaction != null) {
                  if (userProvider.user.id == provider.letter?.letterSenderID) {
                    label = 'You got a reaction!';
                  } else {
                    label = 'You sent a reaction!';
                  }
                }

                return BottomSheetHeader(
                  label: label,
                );
              }),
              const _ReactionButtons(),
              const SizedBox(height: 24),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: _BottomInfo(),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastLinearToSlowEaseIn,
          bottom: provider.isLoading
              ? (24 + MediaQuery.of(context).padding.bottom)
              : -80,
          right: 40,
          child: const FloatingLoadingIndicator(),
        ),
      ],
    );
  }
}

class _ReactionButtons extends StatelessWidget {
  const _ReactionButtons({
    Key key,
  }) : super(key: key);

  void _handlePressed(BuildContext context, ReactionType type) {
    final provider =
        Provider.of<ReactionBottomsheetProvider>(context, listen: false);
    provider.sendReaction(context: context, type: type);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReactionBottomsheetProvider>(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: provider.userCanSelectReactions || provider.loveActive
                  ? 1.0
                  : 0.5,
              child: IgnorePointer(
                ignoring: !provider.userCanSelectReactions,
                child: ReactionLabelButton(
                  type: ReactionType.love,
                  angle: -3,
                  onPressed: () => _handlePressed(
                    context,
                    ReactionType.love,
                  ),
                  isActive: provider.loveActive,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Opacity(
              opacity: provider.userCanSelectReactions || provider.inspireActive
                  ? 1.0
                  : 0.5,
              child: IgnorePointer(
                ignoring: !provider.userCanSelectReactions,
                child: ReactionLabelButton(
                  type: ReactionType.inspire,
                  angle: 2,
                  onPressed: () => _handlePressed(
                    context,
                    ReactionType.inspire,
                  ),
                  isActive: provider.inspireActive,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Opacity(
              opacity: provider.userCanSelectReactions || provider.thanksActive
                  ? 1.0
                  : 0.5,
              child: IgnorePointer(
                ignoring: !provider.userCanSelectReactions,
                child: ReactionLabelButton(
                  type: ReactionType.thanks,
                  angle: 2,
                  onPressed: () => _handlePressed(
                    context,
                    ReactionType.thanks,
                  ),
                  isActive: provider.thanksActive,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BottomInfo extends StatelessWidget {
  const _BottomInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReactionBottomsheetProvider>(context);

    String label = '${provider.reactionsLeftToday} left today';
    AssetImage icon = const AssetImage('assets/images/icons/24x24/smile.png');

    if (provider.currentReaction != null) {
      label = '${getTimeString(provider.currentReactionTime)}';
      icon = const AssetImage('assets/images/icons/24x24/time.png');
    } else if (provider.reactionsLeftToday == null ||
        provider.reactionsLeftToday <= 0) {
      label = 'No reactions left today';
      icon = const AssetImage('assets/images/icons/24x24/sparkle.png');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Transform.rotate(
          angle: -10 * pi / 180,
          child: Image(
            image: icon,
            height: 24,
            width: 24,
          ),
        ),
        const SizedBox(width: 8),
        Builder(
          builder: (context) {
            return Text(
              label,
              style: GentleText.editorButtonLabel,
            );
          },
        ),
      ],
    );
  }
}
