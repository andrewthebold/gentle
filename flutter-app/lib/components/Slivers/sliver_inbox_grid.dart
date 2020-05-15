import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/components/inbox_empty_state.dart';
import 'package:gentle/components/inbox_slot.dart';
import 'package:gentle/components/screen_loading_indicator.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/providers/global_provider.dart';
import 'package:gentle/providers/local_reaction_provider.dart';
import 'package:gentle/providers/sliver_inbox_section_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:provider/provider.dart';

class InboxGridSliver extends StatefulWidget {
  static const double horizontalSpace = 12.0;
  static const double verticalSpace = 12.0;
  static const double minAspectRatio = 160.0 / 95.0;
  static const double horizontalPadding = 16.0;
  static const double topPadding = 8.0;
  static const double bottomPadding = 8.0;

  final double availableHeight;
  final double availableWidth;

  const InboxGridSliver({
    Key key,
    @required this.availableHeight,
    @required this.availableWidth,
  })  : assert(availableHeight != null && availableHeight > 0.0),
        assert(availableWidth != null && availableWidth > 0.0),
        super(key: key);

  @override
  _InboxGridSliverState createState() => _InboxGridSliverState();
}

class _InboxGridSliverState extends State<InboxGridSliver> {
  int _slotCount;
  double _slotHeight;
  double _slotWidth;

  @override
  void initState() {
    super.initState();

    _calcDimensions(
      availableHeight: widget.availableHeight,
      availableWidth: widget.availableWidth,
    );
  }

  void _calcDimensions({double availableHeight, double availableWidth}) {
    var slotCount = 8;
    var verticalSpaceCount = 3;
    var gridFits = false;

    const totalHorizontalSpacing = InboxGridSliver.horizontalSpace;
    final envelopeWidth = (availableWidth - totalHorizontalSpacing) / 2.0;

    // Attempt to find the right number of rows in a two column layout,
    // based on the available vertical space.
    while (!gridFits) {
      final envelopeHeight = envelopeWidth / InboxGridSliver.minAspectRatio;
      final potentialTotalHeight = (envelopeHeight * (slotCount / 2.0)) +
          (InboxGridSliver.verticalSpace * verticalSpaceCount);

      if (potentialTotalHeight <= availableHeight) {
        // Success!
        gridFits = true;
      } else {
        slotCount -= 2;
        verticalSpaceCount -= 1;

        if (slotCount == 0) {
          ErrorBottomSheet.reportAndShow(
            context,
            InboxLayoutException(
              message:
                  'Failed to layout envelope grid. Available height: $availableHeight. Attempted last height: $potentialTotalHeight.',
            ),
            null,
          );
        }
      }
    }

    final totalVerticalSpacing =
        verticalSpaceCount * InboxGridSliver.verticalSpace;
    final envelopeHeight =
        (availableHeight - totalVerticalSpacing) / (slotCount / 2.0);

    _slotCount = slotCount;
    _slotHeight = envelopeHeight;
    _slotWidth = envelopeWidth;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider3<UserProvider, GlobalProvider,
        LocalReactionProvider, SliverInboxSectionProvider>(
      create: (_) => SliverInboxSectionProvider(
        slotCount: _slotCount,
      ),
      update: (_, userProvider, globalProvider, localReactionProvider,
              inboxProvider) =>
          inboxProvider
            ..updateDependentProviders(
              user: userProvider.user,
              globalProvider: globalProvider,
              localReactionProvider: localReactionProvider,
              context: context,
            ),
      child: SliverToBoxAdapter(
        child: RepaintBoundary(
          child: Consumer<SliverInboxSectionProvider>(
            builder: (_, provider, __) {
              return AnimatedCrossFade(
                duration: Constants.fastAnimDuration,
                firstChild: AnimatedCrossFade(
                  duration: Constants.fastAnimDuration,
                  firstChild: Padding(
                    padding: const EdgeInsets.only(
                      left: InboxGridSliver.horizontalPadding,
                      right: InboxGridSliver.horizontalPadding,
                      top: InboxGridSliver.topPadding,
                      bottom: InboxGridSliver.bottomPadding,
                    ),
                    child: _Grid(
                      availableHeight: widget.availableHeight,
                      slotCount: _slotCount,
                      slotHeight: _slotHeight,
                      slotWidth: _slotWidth,
                    ),
                  ),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(
                      left: InboxGridSliver.horizontalPadding,
                      right: InboxGridSliver.horizontalPadding,
                      top: InboxGridSliver.topPadding +
                          Constants.screenActionButtonAreaHeight,
                      bottom: InboxGridSliver.bottomPadding,
                    ),
                    child: ScreenLoadingIndicator(
                      height: widget.availableHeight -
                          Constants.screenActionButtonAreaHeight,
                      enabled: provider.status == InboxStatus.loading,
                    ),
                  ),
                  crossFadeState: provider.status == InboxStatus.loading
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
                secondChild: Padding(
                    padding: const EdgeInsets.only(
                      left: InboxGridSliver.horizontalPadding,
                      right: InboxGridSliver.horizontalPadding,
                      top: InboxGridSliver.topPadding,
                      bottom: InboxGridSliver.bottomPadding,
                    ),
                    child: InboxEmptyState(
                      availableHeight: widget.availableHeight,
                    )),
                crossFadeState:
                    provider.status == InboxStatus.ready && provider.isEmpty
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    Key key,
    @required this.availableHeight,
    @required this.slotCount,
    @required this.slotHeight,
    @required this.slotWidth,
  })  : assert(availableHeight > 0.0),
        assert(slotCount > 0 && slotCount % 2 == 0),
        assert(slotHeight > 0),
        assert(slotWidth > 0),
        super(key: key);

  final double availableHeight;
  final int slotCount;
  final double slotHeight;
  final double slotWidth;

  Widget _buildSlot(BuildContext context, int slotIndex) {
    return SizedBox(
      height: slotHeight,
      width: slotWidth,
      child: AnimationConfiguration.staggeredGrid(
        position: slotIndex,
        columnCount: 2,
        duration: const Duration(milliseconds: 400),
        child: ScaleAnimation(
          child: FadeInAnimation(
            child: InboxSlot(
              slotIndex: slotIndex,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridRow(
      BuildContext context, int rowIndex, Widget slot1, Widget slot2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        slot1,
        slot2,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final slots = <Widget>[];
    for (var i = 0; i < slotCount; i++) {
      slots.add(_buildSlot(context, i));
    }

    final rows = <Widget>[];
    for (var i = 0; i < slotCount / 2; i++) {
      final slot1Index = i * 2;
      final slot2Index = slot1Index + 1;
      rows.add(_buildGridRow(context, i, slots.elementAt(slot1Index),
          slots.elementAt(slot2Index)));

      final isLastRow = i == ((slotCount / 2) - 1);
      if (!isLastRow) {
        rows.add(const SizedBox(height: InboxGridSliver.verticalSpace));
      }
    }

    return Column(
      children: rows,
    );
  }
}
