import 'dart:async';

import 'package:gentle/components/BottomSheet/tip_bottomsheet.dart';
import 'package:gentle/components/Buttons/tip_button.dart';
import 'package:gentle/components/TextEditing/character_count_pill.dart';
import 'package:gentle/components/TextEditing/custom_text_editor.dart';
import 'package:gentle/components/TextEditing/text_editor_utils.dart';
import 'package:gentle/components/overlay_header_loading_indicator.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/screens/letter_screen.dart';
import 'package:gentle/theme.dart';
import 'package:gentle/components/avatar.dart';
import 'package:gentle/components/Buttons/overlay_header_action_button.dart';
import 'package:gentle/components/Buttons/pill_button.dart';
import 'package:gentle/components/Letter/letter.dart';
import 'package:gentle/components/overlay_screen_wrapper.dart';
import 'package:gentle/components/Request/request_card.dart';
import 'package:gentle/components/Slivers/overlay_header_delegate.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:gentle/providers/letter_compose_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class LetterComposeScreen extends StatelessWidget {
  static const routeName = '/composeLetter';

  final RequestItemModel requestItem;

  const LetterComposeScreen({
    Key key,
    @required this.requestItem,
  })  : assert(requestItem != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserProvider,
        LetterComposeScreenProvider>(
      create: (context) => LetterComposeScreenProvider(
        requestItem: requestItem,
      ),
      update: (_, userProvider, screenProvider) =>
          screenProvider..handleUpdateUserModel(userProvider: userProvider),
      child: _LetterComposeScreenBody(
        requestItem: requestItem,
      ),
    );
  }
}

class _LetterComposeScreenBody extends StatefulWidget {
  final RequestItemModel requestItem;

  const _LetterComposeScreenBody({
    Key key,
    @required this.requestItem,
  })  : assert(requestItem != null),
        super(key: key);

  @override
  __LetterComposeScreenBodyState createState() =>
      __LetterComposeScreenBodyState();
}

class __LetterComposeScreenBodyState extends State<_LetterComposeScreenBody> {
  final GlobalKey _letterKey = GlobalKey();

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset:
          Constants.requestCardHeight + LetterScreen.requestCardTopPadding,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        final provider =
            Provider.of<LetterComposeScreenProvider>(context, listen: false);
        provider.markHeroAnimCompleted();
      }
    });
  }

  void _onTapBG() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Future<void> _handleClose() async {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    final provider =
        Provider.of<LetterComposeScreenProvider>(context, listen: false);
    if (provider.status == LetterComposeStatus.writing) {
      await provider.saveDraft();
    }

    provider.markAnimatingOut();

    Navigator.of(context).pop();
  }

  void _handleTapIndicator() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    _scrollController.animateTo(
      0,
      duration: Constants.mediumAnimDuration,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  Future<void> _sendRequest() async {
    final provider =
        Provider.of<LetterComposeScreenProvider>(context, listen: false);

    await _scrollController.animateTo(
      Constants.requestCardHeight + LetterScreen.requestCardTopPadding,
      duration: Constants.weightyAnimDuration,
      curve: Curves.fastLinearToSlowEaseIn,
    );

    _scrollController.jumpTo(0);
    provider.markSending();

    await provider.sendLetter(context, _scrollController);
  }

  Future<void> _cancelSendRequest() async {
    final model =
        Provider.of<LetterComposeScreenProvider>(context, listen: false);
    _scrollController.jumpTo(
        Constants.requestCardHeight + LetterScreen.requestCardTopPadding);
    model.cancelSend();
  }

  Future<void> _handleTipPressed() async {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    final provider =
        Provider.of<LetterComposeScreenProvider>(context, listen: false);

    final textEditingController = provider.textEditingController;

    await TipBottomSheet.show(
      context: context,
      textEditingController: textEditingController,
      type: TipBottomSheetType.letter,
    );

    await Future<void>.delayed(const Duration(milliseconds: 100));

    if (provider.focusNode != null && provider.focusNode.canRequestFocus) {
      provider.focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LetterComposeScreenProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final writing = provider.status == LetterComposeStatus.animatingIn ||
        provider.status == LetterComposeStatus.writing;

    final overlayHeaderVisible =
        provider.status == LetterComposeStatus.animatingIn ||
            provider.status == LetterComposeStatus.writing ||
            provider.status == LetterComposeStatus.delayBeforeSend ||
            provider.status == LetterComposeStatus.sending;

    final sending = provider.status == LetterComposeStatus.delayBeforeSend ||
        provider.status == LetterComposeStatus.sending;

    final requestCardVisible =
        provider.status == LetterComposeStatus.animatingIn ||
            provider.status == LetterComposeStatus.writing ||
            // To ensure the hero animation doesn't jump around
            provider.status == LetterComposeStatus.animatingOut;

    final canCancelSend =
        provider.status == LetterComposeStatus.delayBeforeSend;

    final sendSuccess = provider.status == LetterComposeStatus.sendSuccess;

    final animatedSentCardVisible =
        provider.status == LetterComposeStatus.sendSuccess;

    var letterAlignment = Alignment.topCenter;
    if (provider.status == LetterComposeStatus.delayBeforeSend ||
        provider.status == LetterComposeStatus.sending ||
        provider.status == LetterComposeStatus.sendSuccess) {
      letterAlignment = Alignment.center;
    }

    return GestureDetector(
      onTap: _onTapBG,
      child: Stack(
        children: <Widget>[
          OverlayScreenWrapper(
            onReleasePopTrigger: _handleClose,
            onReleasePopEnabled: writing,
            shouldUnfocusOnScroll: false,
            scrollController: _scrollController,
            slivers: <Widget>[
              OverlayHeader(
                visible: overlayHeaderVisible,
                canTriggerPop: !sending && !sendSuccess,
                actions: <Widget>[
                  if (sending || sendSuccess) ...[
                    AnimatedOpacity(
                      opacity: canCancelSend ? 1.0 : 0.0,
                      duration: Constants.fastAnimDuration,
                      child: OverlayHeaderActionButton.buildCancelButton(
                        onPressed: canCancelSend ? _cancelSendRequest : null,
                      ),
                    ),
                    OverlayHeaderLoadingIndicator()
                  ],
                  if (!sending && !sendSuccess) ...[
                    OverlayHeaderActionButton.buildCloseButton(
                      onPressed: overlayHeaderVisible ? _handleClose : null,
                    ),
                    OverlayHeaderActionButton.buildSendButton(
                      onPressed: overlayHeaderVisible ? _sendRequest : null,
                      enabled: overlayHeaderVisible && provider.sendingEnabled,
                    ),
                  ]
                ],
              ),
              if (requestCardVisible)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: LetterScreen.requestCardTopPadding,
                      left: 4.0,
                      right: 4.0,
                    ),
                    height: Constants.requestCardHeight +
                        LetterScreen.requestCardTopPadding,
                    child: RequestCard(
                      text: widget.requestItem.requestMessage,
                      avatarName: widget.requestItem.requesterAvatar,
                      status: RequestCardStatus.visible,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: AnimatedOpacity(
                  duration: Constants.fastAnimDuration,
                  opacity: requestCardVisible ? 1.0 : 0.0,
                  child: Container(
                    alignment: Alignment.center,
                    height: LetterScreen.requestIndicatorAreaHeight,
                    child: PillButton(
                      label: 'See the message',
                      icon: const AssetImage(
                        'assets/images/icons/16x16/arrowup.png',
                      ),
                      onPressed:
                          requestCardVisible ? _handleTapIndicator : null,
                    ),
                  ),
                ),
              ),
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  final verticalScreenHeight =
                      MediaQuery.of(context).size.height;
                  var letterSpaceHeight = verticalScreenHeight -
                      MediaQuery.of(context).padding.top -
                      OverlayHeader.height -
                      LetterScreen.requestIndicatorAreaHeight;

                  final availableHeight =
                      letterSpaceHeight - MediaQuery.of(context).padding.bottom;

                  const minimumHeight = Letter.height + 8.0;

                  if (availableHeight < minimumHeight) {
                    letterSpaceHeight += minimumHeight - availableHeight;
                  }

                  return SliverToBoxAdapter(
                    child: AnimatedContainer(
                      duration: Constants.mediumAnimDuration,
                      alignment: letterAlignment,
                      curve: Curves.fastOutSlowIn,
                      height: letterSpaceHeight,
                      padding: EdgeInsets.only(
                        left: 4.0,
                        right: 4.0,
                        bottom: requestCardVisible
                            ? 0.0
                            : LetterScreen.requestIndicatorAreaHeight,
                      ),
                      child: Stack(
                        children: <Widget>[
                          Builder(
                            builder: (_) {
                              // Show a static letter while we're waiting for sending
                              if (sending) {
                                return Letter(
                                  status: LetterStatus.visible,
                                  text: provider.textEditingController.text,
                                  recipientAvatar:
                                      widget.requestItem.requesterAvatar,
                                  senderAvatar: userProvider.userAvatar,
                                );
                              }

                              // We put a spacer placeholder here. In the parent stack,
                              // there's an animated [RequestCard] that visualized the sending
                              // of the card.
                              if (sendSuccess) {
                                return const SizedBox(height: Letter.height);
                              }

                              return Hero(
                                tag: HeroTags.composeReply,
                                child: _LetterComposeHero(
                                  recipientAvatar:
                                      widget.requestItem.requesterAvatar,
                                  status: provider.status,
                                  textEditingController:
                                      provider.textEditingController,
                                  focusNode: provider.focusNode,
                                ),
                              );
                            },
                          ),
                          if (animatedSentCardVisible)
                            _SendingLetter(
                              letterWidget: Letter(
                                status: LetterStatus.visible,
                                text: provider.textEditingController.text,
                                recipientAvatar:
                                    widget.requestItem.requesterAvatar,
                                senderAvatar: userProvider.userAvatar,
                              ),
                              onAnimateComplete: _handleClose,
                              letterKey: _letterKey,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastLinearToSlowEaseIn,
            left: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12.0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TipButton(
                      onPressed: _handleTipPressed,
                      visible: provider.focusNode != null &&
                          provider.focusNode.hasFocus,
                      type: TipBottomSheetType.letter,
                    ),
                    CharacterCountPill(
                      visible: provider.focusNode != null &&
                          provider.focusNode.hasFocus,
                      count: provider.characterCount,
                      maxCount: Constants.maxLetterLength,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LetterComposeHero extends StatefulWidget {
  final AvatarName recipientAvatar;
  final LetterComposeStatus status;
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  const _LetterComposeHero({
    Key key,
    @required this.recipientAvatar,
    @required this.status,
    @required this.textEditingController,
    @required this.focusNode,
  })  : assert(recipientAvatar != null),
        super(key: key);

  @override
  __LetterComposeHeroState createState() => __LetterComposeHeroState();
}

class __LetterComposeHeroState extends State<_LetterComposeHero> {
  bool _editorVisible = false;

  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted ||
          widget.focusNode == null ||
          widget.textEditingController == null ||
          widget.status != LetterComposeStatus.writing) {
        return;
      }

      setState(() {
        widget.focusNode.requestFocus();
        _editorVisible = true;
      });
    });
  }

  void _handleTap() {
    if (widget.focusNode != null && widget.focusNode.canRequestFocus) {
      widget.focusNode.requestFocus();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (editableTextKey == null ||
        editableTextKey.currentContext == null ||
        editableTextKey.currentState == null ||
        widget.textEditingController == null) {
      return;
    }

    TextEditorUtils.moveCursorOnParentTap(
      tapGlobalPos: details.globalPosition,
      editableTextContext: editableTextKey.currentContext,
      editableTextState: editableTextKey.currentState,
      textEditingController: widget.textEditingController,
    );
  }

  Widget _buildEditor(BuildContext context) {
    if (widget.textEditingController == null ||
        widget.focusNode == null ||
        widget.status != LetterComposeStatus.writing) {
      return null;
    }

    return CustomTextEditor(
      textController: widget.textEditingController,
      focusNode: widget.focusNode,
      textStyle: GentleText.letterBody,
      maxLength: Constants.maxLetterLength,
      maxNewLines: 6,
      placeholder: 'Write a kind and thoughtful message!',
      editableTextKey: editableTextKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: _handleTap,
      onTapUp: _handleTapUp,
      child: Letter(
        status: _editorVisible ? LetterStatus.visible : LetterStatus.hidden,
        recipientAvatar: widget.recipientAvatar,
        senderAvatar: userProvider.userAvatar,
        child: _buildEditor(context),
      ),
    );
  }
}

class _SendingLetter extends StatefulWidget {
  const _SendingLetter({
    Key key,
    @required this.letterWidget,
    @required this.onAnimateComplete,
    @required this.letterKey,
  }) : super(key: key);

  final Widget letterWidget;
  final Function onAnimateComplete;
  final GlobalKey letterKey;

  @override
  __SendingLetterState createState() => __SendingLetterState();
}

class __SendingLetterState extends State<_SendingLetter> {
  bool _isSent = false;

  Timer _isSentTimer;

  @override
  void initState() {
    super.initState();

    _isSentTimer = Timer(const Duration(milliseconds: 50), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSent = true;
      });
    });
  }

  @override
  void dispose() {
    if (_isSentTimer != null) {
      _isSentTimer.cancel();
      _isSentTimer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isSent ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 400),
      child: AnimatedAlign(
        alignment: _isSent ? const Alignment(0.0, -5.0) : Alignment.center,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        child: widget.letterWidget,
      ),
    );
  }
}
