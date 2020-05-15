import 'package:gentle/components/avatar.dart';
import 'package:gentle/components/Buttons/overlay_header_action_button.dart';
import 'package:gentle/components/Letter/letter.dart';
import 'package:gentle/components/Slivers/overlay_header_delegate.dart';
import 'package:gentle/components/letter_overlay_toolbar.dart';
import 'package:gentle/components/overlay_screen_wrapper.dart';
import 'package:gentle/components/Buttons/pill_button.dart';
import 'package:gentle/components/Request/request_card.dart';
import 'package:gentle/components/report_bottomsheet.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/models/report_model.dart';
import 'package:gentle/providers/letter_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LetterScreen extends StatelessWidget {
  static const routeName = '/letter';

  static const double requestCardTopPadding = 8.0;
  static const double requestIndicatorAreaHeight = 56.0;

  final List<String> letterIDs;
  final List<ReactionType> letterReactions;
  final bool shouldAnimateHero;
  final bool shouldShowRequest;

  const LetterScreen({
    Key key,
    @required this.letterIDs,
    @required this.letterReactions,
    @required this.shouldAnimateHero,
    @required this.shouldShowRequest,
  }) : super(key: key);

  static String heroTagGenerator(String letterID) => 'letter-hero-$letterID';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserProvider, LetterScreenProvider>(
      create: (_) => LetterScreenProvider(
        context: context,
        letterIDs: letterIDs,
        letterReactions: letterReactions,
      ),
      update: (_, userProvider, letterProvider) =>
          letterProvider..handleUserProviderUpdate(user: userProvider.user),
      child: _LetterScreenBody(
        shouldAnimateHero: shouldAnimateHero,
        shouldShowRequest: shouldShowRequest,
      ),
    );
  }
}

class _LetterScreenBody extends StatefulWidget {
  final bool shouldAnimateHero;
  final bool shouldShowRequest;

  const _LetterScreenBody({
    Key key,
    @required this.shouldAnimateHero,
    @required this.shouldShowRequest,
  }) : super(key: key);

  @override
  __LetterScreenBodyState createState() => __LetterScreenBodyState();
}

class __LetterScreenBodyState extends State<_LetterScreenBody> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: widget.shouldShowRequest
          ? Constants.requestCardHeight + LetterScreen.requestCardTopPadding
          : 0.0,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        final provider =
            Provider.of<LetterScreenProvider>(context, listen: false);
        provider.markHeroAnimationCompleted();
      }
    });
  }

  void _handleClose() {
    final provider = Provider.of<LetterScreenProvider>(context, listen: false);
    Navigator.of(context).pop(provider.letter?.id);
  }

  void _handleTapIndicator() {
    _scrollController.animateTo(
      0,
      duration: Constants.mediumAnimDuration,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  Future<void> _handleReportPressed() async {
    final provider = Provider.of<LetterScreenProvider>(context, listen: false);
    if (!provider.canReportLetter) {
      return;
    }

    await ReportBottomSheet.show(
      context: context,
      contentToReportID: provider.letter.id,
      contentToReportCreatorID: provider.letter.letterSenderID,
      contentToReportType: ContentType.letter,
      contentToReportExcerpt: '''
        [REQUEST BODY]
        ${provider.letter.requestMessage}

        [LETTER BODY]
        ${provider.letter.letterMessage}
      ''',
    );

    provider.handleReportingEnded(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LetterScreenProvider>(context);

    return OverlayScreenWrapper(
      onReleasePopTrigger: _handleClose,
      scrollController: _scrollController,
      slivers: <Widget>[
        OverlayHeader(
          visible: true,
          actions: <Widget>[
            OverlayHeaderActionButton.buildCloseButton(
              onPressed: _handleClose,
            ),
            if (provider.canReportLetter)
              AnimatedOpacity(
                duration: Constants.fastAnimDuration,
                opacity: provider.isReadyToShowLetter && provider.letter != null
                    ? 1.0
                    : 0.0,
                child: OverlayHeaderActionButton.buildReportButton(
                    onPressed: _handleReportPressed),
              ),
          ],
        ),
        if (widget.shouldShowRequest)
          SliverToBoxAdapter(
            child: AnimatedOpacity(
              duration: Constants.fastAnimDuration,
              opacity: provider.errorStatus == LetterScreenErrorStatus.none
                  ? 1.0
                  : 0.0,
              child: Container(
                padding: const EdgeInsets.only(
                  top: LetterScreen.requestCardTopPadding,
                  left: 4.0,
                  right: 4.0,
                ),
                height: Constants.requestCardHeight +
                    LetterScreen.requestCardTopPadding,
                child: Builder(
                  builder: (_) {
                    var status = RequestCardStatus.hidden;
                    if (provider.shouldShowLetterLoading) {
                      status = RequestCardStatus.loading;
                    }

                    if (provider.isReadyToShowLetter &&
                        provider.letter != null) {
                      status = RequestCardStatus.visible;
                    }

                    return RequestCard(
                      text: provider?.letter?.requestMessage ?? '',
                      avatarName: provider?.letter?.requestCreatorAvatar ??
                          AvatarName.unknown,
                      status: status,
                    );
                  },
                ),
              ),
            ),
          ),
        if (widget.shouldShowRequest)
          SliverToBoxAdapter(
            child: AnimatedOpacity(
              duration: Constants.fastAnimDuration,
              opacity: provider.isReadyToShowLetter && provider.letter != null
                  ? 1.0
                  : 0.0,
              child: Container(
                alignment: Alignment.center,
                height: LetterScreen.requestIndicatorAreaHeight,
                child: PillButton(
                  label: 'See the message',
                  icon: const AssetImage(
                    'assets/images/icons/16x16/arrowup.png',
                  ),
                  onPressed: _handleTapIndicator,
                ),
              ),
            ),
          ),
        if (!widget.shouldShowRequest)
          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final verticalScreenHeight = MediaQuery.of(context).size.height;
            var letterSpaceHeight = verticalScreenHeight -
                MediaQuery.of(context).padding.top -
                OverlayHeader.height -
                LetterScreen.requestIndicatorAreaHeight;

            // Ensure there's enough clearance at the bottom of the screen for the floating button
            if (letterSpaceHeight - 96.0 < Letter.height) {
              letterSpaceHeight = Letter.height + 96.0;
            }

            return SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.topCenter,
                height: letterSpaceHeight,
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Consumer<UserProvider>(
                  builder: (BuildContext _, UserProvider userProvider,
                      Widget child) {
                    LetterStatus status = LetterStatus.hidden;

                    if (provider.shouldShowLetterLoading) {
                      status = LetterStatus.loading;
                    }

                    if (provider.isReadyToShowLetter) {
                      switch (provider.errorStatus) {
                        case LetterScreenErrorStatus.none:
                          if (provider.letter != null) {
                            status = LetterStatus.visible;
                          }
                          break;
                        case LetterScreenErrorStatus.deleted:
                          status = LetterStatus.deleted;
                          break;
                        case LetterScreenErrorStatus.offline:
                          status = LetterStatus.offline;
                          break;
                      }
                    }

                    AvatarName recipientAvatar =
                        provider?.letter?.requestCreatorAvatar ??
                            AvatarName.unknown;

                    final senderAvatar = provider?.letter?.letterSenderAvatar ??
                        AvatarName.unknown;

                    if (senderAvatar == AvatarName.gentle) {
                      recipientAvatar = userProvider.userAvatar;
                    }

                    return Hero(
                      tag: widget.shouldAnimateHero
                          ? LetterScreen.heroTagGenerator(provider.letter?.id)
                          : 'INVALID_LETTER_HERO',
                      child: Letter(
                        text: provider?.letter?.letterMessage ?? '',
                        recipientAvatar: recipientAvatar,
                        senderAvatar: senderAvatar,
                        status: status,
                        onPressedRefetch: () => provider.refetch(
                          context: context,
                          letterID: provider.letter?.id,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
      overlayWidget: LetterOverlayToolbar(
        onPressedDone: _handleClose,
        readyToShowContent: provider.isReadyToShowLetter,
      ),
    );
  }
}
