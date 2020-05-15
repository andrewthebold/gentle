import 'package:gentle/components/avatar.dart';
import 'package:gentle/components/error_state_deleted.dart';
import 'package:gentle/components/error_state_offline.dart';
import 'package:gentle/components/loading_shimmer_builder.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

enum RequestCardStatus { hidden, loading, visible, offline, deleted }

class RequestCard extends StatelessWidget {
  final Widget child;
  final String text;
  final AvatarName avatarName;
  final RequestCardStatus status;

  final VoidCallback onPressedRefetch;

  const RequestCard({
    Key key,
    this.child,
    this.text,
    @required this.avatarName,
    @required this.status,
    this.onPressedRefetch,
  }) : super(key: key);

  Widget _buildText(BuildContext context) {
    if (status == RequestCardStatus.hidden ||
        status == RequestCardStatus.loading ||
        text == null) {
      return null;
    }

    return AutoSizeText(
      text,
      style: GentleText.requestBody,
      minFontSize: 0.0,
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return LoadingShimmerBuilder(
      builder: (context, bgColor) {
        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                // height: 100,
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadedContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: child ?? _buildText(context),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Avatar(avatarName: avatarName),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (status) {
      case RequestCardStatus.hidden:
        child = Container(
          width: MediaQuery.of(context).size.width,
        );
        break;
      case RequestCardStatus.loading:
        child = _buildLoadingContent(context);
        break;
      case RequestCardStatus.visible:
        child = _buildLoadedContent(context);
        break;
      case RequestCardStatus.offline:
        child = ErrorStateOffline(
          onPressedRefetch: onPressedRefetch,
        );
        break;
      case RequestCardStatus.deleted:
        child = ErrorStateDeleted();
        break;
    }

    return Container(
      height: Constants.requestCardHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: Palette.graySecondary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [GentleShadow.basic],
        color: Palette.white,
      ),
      child: AnimatedSwitcher(
        duration: Constants.fastAnimDuration,
        child: child,
      ),
    );
  }
}
