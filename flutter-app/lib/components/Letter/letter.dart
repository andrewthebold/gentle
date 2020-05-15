import 'dart:math';

import 'package:gentle/components/avatar.dart';
import 'package:gentle/components/Letter/letter_attribution.dart';
import 'package:gentle/components/error_state_deleted.dart';
import 'package:gentle/components/error_state_offline.dart';
import 'package:gentle/components/loading_shimmer_builder.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

enum LetterStatus { hidden, loading, visible, offline, deleted }

class Letter extends StatelessWidget {
  static const double height = 508.0;

  final Widget child;
  final String text;
  final AvatarName recipientAvatar;
  final AvatarName senderAvatar;
  final LetterStatus status;

  final VoidCallback onPressedRefetch;

  const Letter({
    Key key,
    this.child,
    this.text,
    @required this.recipientAvatar,
    @required this.senderAvatar,
    @required this.status,
    this.onPressedRefetch,
  }) : super(key: key);

  Widget _buildText(BuildContext context) {
    if (status == LetterStatus.hidden ||
        status == LetterStatus.loading ||
        text == null) {
      return null;
    }

    return AutoSizeText(
      text,
      style: GentleText.requestBody,
      minFontSize: 12.0,
    );
  }

  Widget _buildLoadingName(Color bgColor) {
    return Transform.rotate(
      angle: -7 * pi / 180,
      child: Container(
        height: 24,
        width: 64,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return LoadingShimmerBuilder(
      builder: (context, bgColor) {
        return Stack(
          children: <Widget>[
            // Receipient Name
            Positioned(
              top: 36,
              left: 24,
              child: _buildLoadingName(bgColor),
            ),

            // Content
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Sender Name
            Positioned(
              bottom: 32,
              right: 32,
              child: _buildLoadingName(bgColor),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadedContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Receipient Name
        Positioned(
          top: 32,
          left: 24,
          child: LetterAttribution(
            type: LetterAttributionType.to,
            avatarName: recipientAvatar,
          ),
        ),

        // Content
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 88),
            child: child ?? _buildText(context),
          ),
        ),
        Positioned(
          bottom: 32,
          right: 24,
          child: LetterAttribution(
            type: LetterAttributionType.from,
            avatarName: senderAvatar,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (status) {
      case LetterStatus.hidden:
        child = Container(
          width: MediaQuery.of(context).size.width,
        );
        break;
      case LetterStatus.loading:
        child = _buildLoadingContent(context);
        break;
      case LetterStatus.visible:
        child = _buildLoadedContent(context);
        break;
      case LetterStatus.offline:
        child = ErrorStateOffline(
          onPressedRefetch: onPressedRefetch,
        );
        break;
      case LetterStatus.deleted:
        child = ErrorStateDeleted();
        break;
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Palette.white,
        border: Border.all(
          color: Palette.graySecondary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: const [
          GentleShadow.basic,
        ],
      ),
      child: AnimatedSwitcher(
        duration: Constants.fastAnimDuration,
        child: child,
      ),
    );
  }
}
