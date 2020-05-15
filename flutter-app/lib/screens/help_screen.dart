import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:gentle/components/BottomSheet/about_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/components/BottomSheet/delete_bottomsheet.dart';
import 'package:gentle/components/BottomSheet/export_bottomsheet.dart';
import 'package:gentle/components/Slivers/sliver_end_of_screen_section.dart';
import 'package:gentle/components/Slivers/tab_header_delegate.dart';
import 'package:gentle/components/list_item_wrapper.dart';
import 'package:gentle/components/tab_wrapper.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  final ScrollController scrollController;

  const HelpScreen({Key key, @required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaled by a magic number that looks good
    // final cardContainerHeight = MediaQuery.of(context).size.width / 1.85;

    return TabWrapper(
      scrollController: scrollController,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          const TabHeader(
            title: Text(UIStrings.help, style: GentleText.headlineText),
          ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 16),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: <Widget>[
          //         ScaleButton(
          //           onPressed: () {},
          //           label: UIStrings.cardHowGentleWorks,
          //           child: SizedBox(
          //             height: cardContainerHeight,
          //             child: Align(
          //               alignment: Alignment.topLeft,
          //               child: Transform.rotate(
          //                 angle: -2 * pi / 180,
          //                 child: const _HelpCard(
          //                   title: UIStrings.cardHowGentleWorks,
          //                   tint: Palette.blueTertiary,
          //                   illustration: AssetImage(
          //                       'assets/images/illustrations/Guide.png'),
          //                   illustrationRotation: 5 * pi / 180,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         ScaleButton(
          //           onPressed: () {},
          //           label: UIStrings.cardMentalHealth,
          //           child: SizedBox(
          //             height: cardContainerHeight,
          //             child: Align(
          //               alignment: Alignment.bottomRight,
          //               child: Transform.rotate(
          //                 angle: 2 * pi / 180,
          //                 child: const _HelpCard(
          //                   title: UIStrings.cardMentalHealth,
          //                   tint: Palette.redTertiary,
          //                   illustration: AssetImage(
          //                       'assets/images/illustrations/LoveEnvelope.png'),
          //                   illustrationRotation: -5 * pi / 180,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),
          _SliverHelpScreenContent(
            bottomPadding: MediaQuery.of(context).padding.bottom,
            child: Column(
              children: <Widget>[
                // _HelpListItem(
                //   icon: const AssetImage(
                //       'assets/images/icons/40x40/sparkles.png'),
                //   iconRotation: 10,
                //   label: UIStrings.helpWhatsNew,
                //   onPressed: () {},
                //   disabled: true,
                // ),
                _HelpListItem(
                  icon:
                      const AssetImage('assets/images/icons/40x40/gentle.png'),
                  iconRotation: 6,
                  label: UIStrings.helpContact,
                  onPressed: () async {
                    // TODO (Low): Move mailing into a util function (also in [ErrorBottomSheetProvider])
                    // https://stackoverflow.com/questions/32114455/open-gmail-app-from-my-app
                    var gmailURL = 'googlegmail:///co?to=<REDACTED>';
                    gmailURL = Uri.encodeFull(gmailURL);

                    if (await canLaunch(gmailURL)) {
                      await launch(gmailURL);
                      return;
                    }

                    var mailURL = 'mailto:<REDACTED>';
                    mailURL = Uri.encodeFull(mailURL);

                    if (await canLaunch(mailURL)) {
                      await launch(mailURL);
                    }
                  },
                ),
                // _HelpListItem(
                //   icon: const AssetImage('assets/images/icons/40x40/gift.png'),
                //   iconRotation: -3,
                //   label: UIStrings.helpTip,
                // ),
                _HelpListItem(
                  icon: const AssetImage(
                      'assets/images/icons/40x40/notifications.png'),
                  iconRotation: -3,
                  label: 'Notifications',
                  onPressed: () {},
                  disabled: true,
                ),
                _HelpListItem(
                  icon: const AssetImage('assets/images/icons/40x40/trash.png'),
                  iconRotation: -4,
                  label: UIStrings.helpDelete,
                  onPressed: () {
                    DeleteBottomSheet.show(context: context);
                  },
                ),
                _HelpListItem(
                  icon:
                      const AssetImage('assets/images/icons/40x40/export.png'),
                  iconRotation: 0,
                  label: 'Export Data (Until May 15!)',
                  onPressed: () async {
                    await ExportBottomsheet.show(context: context);
                  },
                ),
                const Spacer(),
                _HelpListItem(
                  icon: const AssetImage(
                      'assets/images/icons/40x40/question.png'),
                  iconRotation: 3,
                  label: UIStrings.about,
                  onPressed: () {
                    AboutBottomSheet.show(context: context);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SliverEndOfScreenSection(),
        ],
      ),
    );
  }
}

class _SliverHelpScreenContent extends SingleChildRenderObjectWidget {
  final double bottomPadding;

  const _SliverHelpScreenContent({
    Key key,
    Widget child,
    @required this.bottomPadding,
  }) : super(key: key, child: child);

  @override
  _RenderSliverCustomRemaining createRenderObject(BuildContext context) =>
      _RenderSliverCustomRemaining(bottomPadding: bottomPadding);
}

class _RenderSliverCustomRemaining extends RenderSliverSingleBoxAdapter {
  final double bottomPadding;

  _RenderSliverCustomRemaining({RenderBox child, @required this.bottomPadding})
      : super(child: child);

  @override
  void performLayout() {
    final constraints = this.constraints;
    var extent = constraints.viewportMainAxisExtent -
        constraints.precedingScrollExtent -
        Constants.sliverDividerHeight -
        bottomPadding;

    if (child != null) {
      final childExtent =
          child.getMaxIntrinsicHeight(constraints.crossAxisExtent);

      extent = max(extent, childExtent);
      child.layout(constraints.asBoxConstraints(
        minExtent: extent,
        maxExtent: extent,
      ));
    }

    assert(
      extent.isFinite,
      'The calculated extent for the child of SliverFillRemaining is not finite. '
      'This can happen if the child is a scrollable, in which case, the '
      'hasScrollBody property of SliverFillRemaining should not be set to '
      'false.',
    );
    final paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: extent);
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: extent,
      paintExtent: paintedChildSize,
      maxPaintExtent: paintedChildSize,
      hasVisualOverflow: extent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    if (child != null) {
      setChildParentData(child, constraints, geometry);
    }
  }
}

// class _HelpCard extends StatelessWidget {
//   final String title;
//   final Color tint;
//   final AssetImage illustration;
//   final double illustrationRotation;

//   const _HelpCard(
//       {Key key,
//       @required this.title,
//       @required this.tint,
//       @required this.illustration,
//       @required this.illustrationRotation})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: screenWidth / 2 - 16,
//         maxWidth: screenWidth / 2 - 16,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Palette.white,
//         border: Border.all(color: Palette.graySecondary, width: 1),
//         boxShadow: const [GentleShadow.basic],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Stack(
//           children: <Widget>[
//             // Blue Circle
//             Positioned(
//               top: -72,
//               right: -24,
//               child: Container(
//                   height: 165,
//                   width: 165,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(80),
//                     color: tint,
//                   )),
//             ),

//             // Illustration
//             Positioned(
//                 top: 16,
//                 left: 16,
//                 child: Transform.rotate(
//                     angle: illustrationRotation,
//                     child: Image(
//                       height: 72,
//                       width: 72,
//                       image: illustration,
//                     ))),

//             Positioned(
//               left: 20,
//               bottom: 16,
//               width: 120,
//               child: Text(title,
//                   style: MediaQuery.of(context).size.width > 350
//                       ? GentleText.cardLabel
//                       : GentleText.cardLabelSmall),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _HelpListItem extends StatelessWidget {
  final AssetImage icon;
  final double iconRotation;
  final String label;
  final VoidCallback onPressed;
  final bool disabled;

  const _HelpListItem({
    Key key,
    @required this.icon,
    @required this.iconRotation,
    @required this.label,
    @required this.onPressed,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = ListItemWrapper(
      height: 48,
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Transform.rotate(
            angle: iconRotation * pi / 180,
            child: Image(
              image: icon,
              height: 40,
              width: 40,
            ),
          ),
          Container(width: 8),
          Text(label, style: GentleText.listLabel),
          if (disabled) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Palette.graySecondary,
                  width: 1,
                ),
              ),
              child: const Text('Soon!', style: GentleText.endOfListTitle),
            ),
          ],
        ],
      ),
    );

    if (disabled) {
      return IgnorePointer(
        ignoring: true,
        child: Opacity(
          opacity: 0.5,
          child: child,
        ),
      );
    }

    return child;
  }
}
