import 'dart:async';

import 'package:gentle/components/BottomSheet/tip_bottomsheet.dart';
import 'package:gentle/components/Buttons/tip_button.dart';
import 'package:gentle/components/TextEditing/character_count_pill.dart';
import 'package:gentle/components/TextEditing/custom_text_editor.dart';
import 'package:gentle/components/Buttons/overlay_header_action_button.dart';
import 'package:gentle/components/Slivers/overlay_header_delegate.dart';
import 'package:gentle/components/TextEditing/text_editor_utils.dart';
import 'package:gentle/components/overlay_header_loading_indicator.dart';
import 'package:gentle/components/overlay_screen_wrapper.dart';
import 'package:gentle/components/Request/request_card.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/global_provider.dart';
import 'package:gentle/providers/request_compose_screen_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RequestComposeScreen extends StatelessWidget {
  static const routeName = '/composeRequest';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserProvider,
        RequestComposeScreenProvider>(
      create: (context) => RequestComposeScreenProvider(),
      update: (_, userProvider, screenProvider) =>
          screenProvider..handleUpdateUserModel(userProvider),
      child: _RequestComposeScreenBody(),
    );
  }
}

class _RequestComposeScreenBody extends StatefulWidget {
  @override
  __RequestComposeScreenBodyState createState() =>
      __RequestComposeScreenBodyState();
}

class __RequestComposeScreenBodyState extends State<_RequestComposeScreenBody> {
  @override
  void initState() {
    super.initState();

    // Run after this screen loads
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        final provider =
            Provider.of<RequestComposeScreenProvider>(context, listen: false);
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
        Provider.of<RequestComposeScreenProvider>(context, listen: false);

    if (provider.status == RequestComposeStatus.writing) {
      await provider.saveDraft();
    }

    provider.markAnimatingOut();
    Navigator.of(context).pop();
  }

  Future<void> _sendRequest() async {
    final provider =
        Provider.of<RequestComposeScreenProvider>(context, listen: false);
    provider.markSending();
    await provider.sendRequest(context);

    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    globalProvider.markSentMail();
  }

  Future<void> _cancelSendRequest() async {
    final provider =
        Provider.of<RequestComposeScreenProvider>(context, listen: false);
    await provider.cancelSend();
  }

  Future<void> _handleTipPressed() async {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }

    final provider =
        Provider.of<RequestComposeScreenProvider>(context, listen: false);

    final textEditingController = provider.textEditingController;

    await TipBottomSheet.show(
      context: context,
      textEditingController: textEditingController,
      type: TipBottomSheetType.request,
    );

    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (provider.focusNode != null && provider.focusNode.canRequestFocus) {
      provider.focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestComposeScreenProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final writing = provider.status == RequestComposeStatus.animatingIn ||
        provider.status == RequestComposeStatus.writing;

    final overlayHeaderVisible =
        provider.status == RequestComposeStatus.animatingIn ||
            provider.status == RequestComposeStatus.writing ||
            provider.status == RequestComposeStatus.delayBeforeSend ||
            provider.status == RequestComposeStatus.sending;

    final sending = provider.status == RequestComposeStatus.delayBeforeSend ||
        provider.status == RequestComposeStatus.sending;

    final canCancelSend =
        provider.status == RequestComposeStatus.delayBeforeSend;

    final sendSuccess = provider.status == RequestComposeStatus.sendSuccess;

    var requestAlignment = Alignment.topCenter;
    if (provider.status == RequestComposeStatus.delayBeforeSend ||
        provider.status == RequestComposeStatus.sending ||
        provider.status == RequestComposeStatus.sendSuccess) {
      requestAlignment = Alignment.center;
    }

    return GestureDetector(
      onTap: _onTapBG,
      child: Stack(
        children: <Widget>[
          OverlayScreenWrapper(
            onReleasePopTrigger: _handleClose,
            onReleasePopEnabled: writing,
            shouldUnfocusOnScroll: false,
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
                  ],
                ],
              ),
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  var composeAreaHeight = MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      OverlayHeader.height;

                  final availableHeight = composeAreaHeight -
                      MediaQuery.of(context).viewInsets.bottom;

                  const minimumHeight = Constants.requestCardHeight + 8.0;

                  if (availableHeight < minimumHeight) {
                    composeAreaHeight += minimumHeight - availableHeight;
                  }

                  return SliverToBoxAdapter(
                    child: Container(
                      height: composeAreaHeight,
                      padding: const EdgeInsets.only(
                        left: 4.0,
                        right: 4.0,
                        top: 4.0,
                        bottom: OverlayHeader.height,
                      ),
                      child: Stack(
                        children: <Widget>[
                          AnimatedAlign(
                            alignment: requestAlignment,
                            duration: Constants.mediumAnimDuration,
                            curve: Curves.fastOutSlowIn,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Builder(
                                  builder: (_) {
                                    // Show a static card while we're waiting for sending
                                    if (sending) {
                                      return RequestCard(
                                        status: RequestCardStatus.visible,
                                        text:
                                            provider.textEditingController.text,
                                        avatarName: userProvider.userAvatar,
                                      );
                                    }

                                    // We put a spacer placeholder here. In the parent stack,
                                    // there's an animated [RequestCard] that visualized the sending
                                    // of the card.
                                    if (sendSuccess) {
                                      return const SizedBox(
                                          height: Constants.requestCardHeight);
                                    }

                                    return Hero(
                                      tag: HeroTags.composeRequest,
                                      child: _ComposeCardHero(
                                        status: provider.status,
                                        textEditingController:
                                            provider.textEditingController,
                                        focusNode: provider.focusNode,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (sendSuccess)
                            _SendingCard(
                              model: provider,
                              onAnimateComplete: _handleClose,
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
                      type: TipBottomSheetType.request,
                    ),
                    CharacterCountPill(
                      visible: provider.focusNode != null &&
                          provider.focusNode.hasFocus,
                      count: provider.characterCount,
                      maxCount: Constants.maxRequestLength,
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

class _SendingCard extends StatefulWidget {
  const _SendingCard({
    Key key,
    @required this.model,
    @required this.onAnimateComplete,
  }) : super(key: key);

  final RequestComposeScreenProvider model;
  final Function onAnimateComplete;

  @override
  __SendingCardState createState() => __SendingCardState();
}

class __SendingCardState extends State<_SendingCard> {
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
    final userProvider = Provider.of<UserProvider>(context);
    return AnimatedOpacity(
      opacity: _isSent ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 400),
      child: AnimatedAlign(
        alignment: _isSent ? const Alignment(0.0, -5.0) : Alignment.center,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        child: RequestCard(
          status: RequestCardStatus.visible,
          text: widget.model.textEditingController.text,
          avatarName: userProvider.userAvatar,
        ),
      ),
    );
  }
}

class _ComposeCardHero extends StatefulWidget {
  final RequestComposeStatus status;
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  const _ComposeCardHero({
    Key key,
    @required this.status,
    @required this.textEditingController,
    @required this.focusNode,
  }) : super(key: key);

  @override
  __ComposeCardHeroState createState() => __ComposeCardHeroState();
}

class __ComposeCardHeroState extends State<_ComposeCardHero> {
  bool _editorVisible = false;

  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  void initState() {
    super.initState();

    // Run after the hero animation finishes
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted ||
          widget.focusNode == null ||
          widget.textEditingController == null ||
          widget.status != RequestComposeStatus.writing) {
        return;
      }
      setState(() {
        widget.focusNode.requestFocus();
        _editorVisible = true;
      });
    });
  }

  Widget _buildEditor(BuildContext context) {
    if (widget.textEditingController == null ||
        widget.focusNode == null ||
        widget.status != RequestComposeStatus.writing) {
      return null;
    }

    return CustomTextEditor(
      textController: widget.textEditingController,
      focusNode: widget.focusNode,
      textStyle: GentleText.requestBody,
      maxLength: Constants.maxRequestLength,
      maxNewLines: 3,
      placeholder: 'What would you like kindness about?',
      editableTextKey: editableTextKey,
    );
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: _handleTap,
      onTapUp: _handleTapUp,
      child: RequestCard(
        status: _editorVisible
            ? RequestCardStatus.visible
            : RequestCardStatus.hidden,
        avatarName: userProvider.userAvatar,
        child: _buildEditor(context),
      ),
    );
  }
}
