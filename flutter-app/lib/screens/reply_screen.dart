import 'package:gentle/components/Slivers/sliver_divider.dart';
import 'package:gentle/components/Slivers/sliver_end_of_screen_section.dart';
import 'package:gentle/components/Slivers/sliver_reply_activity_log_section.dart';
import 'package:gentle/components/Slivers/sliver_request_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/components/Slivers/tab_header_delegate.dart';
import 'package:gentle/components/reaction_stack.dart';
import 'package:gentle/components/tab_wrapper.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class ReplyScreen extends StatelessWidget {
  final ScrollController scrollController;

  const ReplyScreen({Key key, @required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabWrapper(
      scrollController: scrollController,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          TabHeader(
            title: Text(UIStrings.reply, style: GentleText.headlineText),
            actionChild: ReactionStack(),
          ),
          ChangeNotifierProvider<ScrollController>.value(
            value: scrollController,
            child: SliverRequestSection(),
          ),
          SliverDivider(),
          const SliverPadding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
            sliver: SliverToBoxAdapter(
              child: Text(UIStrings.history, style: GentleText.subHeadlineText),
            ),
          ),
          SliverReplyActivityLogSection(
            scrollController: scrollController,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverEndOfScreenSection(),
        ],
      ),
    );
  }
}
