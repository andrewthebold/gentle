import 'package:gentle/components/Slivers/sliver_compose_button_section.dart';
import 'package:gentle/components/Slivers/sliver_divider.dart';
import 'package:gentle/components/Slivers/sliver_end_of_screen_section.dart';
import 'package:gentle/components/Slivers/sliver_inbox_section.dart';
import 'package:gentle/components/Slivers/sliver_mailbox_activity_log_section.dart';
import 'package:gentle/components/Slivers/tab_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/components/tab_wrapper.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class MailboxScreen extends StatefulWidget {
  final ScrollController scrollController;

  const MailboxScreen({Key key, @required this.scrollController})
      : super(key: key);

  @override
  _MailboxScreenState createState() => _MailboxScreenState();
}

class _MailboxScreenState extends State<MailboxScreen> {
  @override
  Widget build(BuildContext context) {
    return TabWrapper(
      scrollController: widget.scrollController,
      child: CustomScrollView(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          const TabHeader(
            title: Text(UIStrings.mailbox, style: GentleText.headlineText),
          ),
          ChangeNotifierProvider<ScrollController>.value(
            value: widget.scrollController,
            child: SliverInboxSection(),
          ),
          SliverComposeButtonSection(),
          SliverDivider(),
          const SliverPadding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
            sliver: SliverToBoxAdapter(
              child: Text(UIStrings.history, style: GentleText.subHeadlineText),
            ),
          ),
          SliverMailboxActivityLogSection(
            scrollController: widget.scrollController,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          // DividerSliver(),
          SliverEndOfScreenSection(),
        ],
      ),
    );
  }
}
