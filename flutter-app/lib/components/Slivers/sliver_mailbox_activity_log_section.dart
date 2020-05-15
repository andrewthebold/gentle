import 'package:gentle/components/Slivers/sliver_activity_log.dart';
import 'package:gentle/models/activity_log_item_model.dart';
import 'package:gentle/providers/activity_log_provider.dart';
import 'package:flutter/material.dart';
import 'package:gentle/providers/local_reaction_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SliverMailboxActivityLogSection extends StatefulWidget {
  final ScrollController scrollController;

  const SliverMailboxActivityLogSection({
    Key key,
    @required this.scrollController,
  }) : super(key: key);

  @override
  _SliverMailboxActivityLogSectionState createState() =>
      _SliverMailboxActivityLogSectionState();
}

class _SliverMailboxActivityLogSectionState
    extends State<SliverMailboxActivityLogSection> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider2<UserProvider, LocalReactionProvider,
        ActivityLogProvider>(
      create: (_) => ActivityLogProvider(
        listKey: _listKey,
        itemTypes: [
          ActivityLogItemType.openedMail,
          ActivityLogItemType.sentRequest,
        ],
      ),
      update: (_, userProvider, localReactionProvider, logProvider) =>
          logProvider
            ..handleProviderUpdates(
                user: userProvider.user,
                newLocalReactions: localReactionProvider.localReactions,
                context: context),
      child: SliverActivityLog(
        listKey: _listKey,
        scrollController: widget.scrollController,
      ),
    );
  }
}
