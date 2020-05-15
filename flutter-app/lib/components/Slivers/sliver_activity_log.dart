import 'package:gentle/components/ActivityLog/activity_log_list_item_shimmer.dart';
import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/components/activity_log_list_item.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/providers/activity_log_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class SliverActivityLog extends StatefulWidget {
  final GlobalKey<SliverAnimatedListState> listKey;
  final ScrollController scrollController;

  const SliverActivityLog({
    Key key,
    @required this.listKey,
    @required this.scrollController,
  }) : super(key: key);

  @override
  _SliverActivityLogState createState() => _SliverActivityLogState();
}

class _SliverActivityLogState extends State<SliverActivityLog> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  Future<void> _handleScroll() async {
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final scrollPos = widget.scrollController.position.pixels;

    if (maxScroll - scrollPos <= Constants.infiniteScrollThreshold) {
      final provider = Provider.of<ActivityLogProvider>(context, listen: false);

      if (provider.status == ActivityLogStatus.endOfList) {
        return;
      }

      try {
        provider.dangerousPaginateData();
      } on Exception catch (exception, stackTrace) {
        await ErrorBottomSheet.reportAndShow(
          context,
          ActivityLogPaginationException(capturedException: exception),
          stackTrace,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityLogProvider>(context);

    return SliverAnimatedList(
      key: widget.listKey,
      initialItemCount: provider.items.length,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        final isLastItem = index == provider.items.length - 1;

        if (isLastItem) {
          assert(provider.items[index] == null);

          if (provider.status == ActivityLogStatus.paginating) {
            return Column(
              children: <Widget>[
                ActivityLogListItemShimmer(),
                ActivityLogListItemShimmer(),
              ],
            );
          }

          if (provider.status == ActivityLogStatus.endOfList &&
              provider.items.length > 1) {
            return const _ActivityLogListItemEndOfList();
          }

          return const _ActivityLogListItemEmpty();
        }

        return ActivityLogListItem(
          item: provider.items[index],
        );
      },
    );
  }
}

class _ActivityLogListItemEndOfList extends StatelessWidget {
  const _ActivityLogListItemEndOfList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Image(
            image: AssetImage('assets/images/icons/24x24/check.png'),
            height: 24,
            width: 24,
          ),
          SizedBox(height: 4),
          Text(UIStrings.endOfList, style: GentleText.endOfListTitle),
        ],
      ),
    );
  }
}

class _ActivityLogListItemEmpty extends StatelessWidget {
  const _ActivityLogListItemEmpty({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Image(
            image: AssetImage('assets/images/icons/24x24/sparkle.png'),
            height: 24,
            width: 24,
          ),
          SizedBox(height: 4),
          Text(UIStrings.listEmpty, style: GentleText.endOfListTitle),
        ],
      ),
    );
  }
}
