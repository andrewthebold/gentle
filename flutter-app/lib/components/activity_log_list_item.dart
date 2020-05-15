import 'dart:math';

import 'package:gentle/components/list_item_wrapper.dart';
import 'package:gentle/components/reaction_icon.dart';
import 'package:gentle/screens/letter_screen.dart';
import 'package:gentle/screens/request_screen.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/route_generator.dart';
import 'package:gentle/theme.dart';
import 'package:gentle/components/avatar.dart';
import 'package:gentle/components/Envelope/mini_envelope.dart';
import 'package:gentle/components/Request/mini_request_card.dart';
import 'package:gentle/models/activity_log_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gentle/time.dart';

class ActivityLogListItem extends StatelessWidget {
  final ActivityLogItemModel item;

  const ActivityLogListItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  void _handlePressed(BuildContext context) {
    switch (item.type) {
      case ActivityLogItemType.sentRequest:
        Navigator.of(context).pushNamed(
          RequestScreen.routeName,
          arguments: RequestScreenArguments(
            requestID: item.linkedContentID,
          ),
        );
        break;
      case ActivityLogItemType.openedMail:
        Navigator.of(context).pushNamed(
          LetterScreen.routeName,
          arguments: LetterScreenArguments(
            letterIDs: [item.linkedContentID],
            shouldAnimateHero: false,
            shouldShowRequest: item.linkedContentAvatar != AvatarName.gentle,
          ),
        );
        return;
      case ActivityLogItemType.sentReply:
        Navigator.of(context).pushNamed(
          LetterScreen.routeName,
          arguments: LetterScreenArguments(
            letterIDs: [item.linkedContentID],
            shouldAnimateHero: false,
            shouldShowRequest: item.linkedContentAvatar != AvatarName.gentle,
          ),
        );
        break;
      case ActivityLogItemType.unknown:
        // noop
        break;
    }

    if (item.type == ActivityLogItemType.openedMail) {
      Navigator.of(context).pushNamed(
        LetterScreen.routeName,
        arguments: LetterScreenArguments(
          letterIDs: [item.linkedContentID],
          shouldShowRequest: item.linkedContentAvatar != AvatarName.gentle,
        ),
      );
      return;
    }
  }

  Widget _buildHeader(BuildContext context) {
    String stem;

    switch (item.type) {
      case ActivityLogItemType.sentRequest:
        stem = UIStrings.activityLogStemSentRequest;
        break;
      case ActivityLogItemType.openedMail:
        stem = UIStrings.activityLogStemOpenMail;
        break;
      case ActivityLogItemType.sentReply:
        stem = UIStrings.activityLogStemSentReply;
        break;
      case ActivityLogItemType.unknown:
        // noop
        break;
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: stem,
            style: GentleText.listLabel,
          ),
          const WidgetSpan(
            child: SizedBox(width: 8.0),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedOverflowBox(
              size: const Size.square(16.0),
              child: Avatar(
                avatarName: item.linkedContentAvatar,
              ),
            ),
            style: GentleText.listLabel,
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    switch (item.type) {
      case ActivityLogItemType.sentRequest:
        return MiniRequestCard(item: item);
        break;
      case ActivityLogItemType.openedMail:
      case ActivityLogItemType.sentReply:
        return MiniEnvelope(item: item);
        break;
      case ActivityLogItemType.unknown:
        // noop
        break;
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // Show nothing if we don't know how to render this item type
    if (item.type == ActivityLogItemType.unknown) {
      return Container();
    }

    final reactionType = item.reactionType;
    final reactionAngle = Random(item.hashCode).nextInt(10) - 5;

    return ListItemWrapper(
      onPressed: () => _handlePressed(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              _buildPreview(context),
              if (reactionType != null)
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: ReactionIcon(
                    angle: reactionAngle,
                    type: reactionType,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(context),
                const SizedBox(height: 2),
                Text(
                  item.linkedContentExcerpt,
                  style: GentleText.listSecondaryLabel,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60),
            child: Text(
              getTimeString(item.creationDate),
              style: GentleText.listSecondaryLabel,
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }
}
