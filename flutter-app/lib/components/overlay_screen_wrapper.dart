import 'package:gentle/components/Slivers/overlay_header_delegate.dart';
import 'package:gentle/effects.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';

class OverlayScreenWrapper extends StatefulWidget {
  final List<Widget> slivers;
  final ScrollController scrollController;
  final Widget overlayWidget;

  final Function onReleasePopTrigger;
  final bool onReleasePopEnabled;
  final bool shouldUnfocusOnScroll;

  const OverlayScreenWrapper({
    Key key,
    @required this.slivers,
    @required this.onReleasePopTrigger,
    this.shouldUnfocusOnScroll = true,
    this.onReleasePopEnabled = true,
    this.scrollController,
    this.overlayWidget,
  }) : super(key: key);

  @override
  _OverlayScreenWrapperState createState() => _OverlayScreenWrapperState();
}

class _OverlayScreenWrapperState extends State<OverlayScreenWrapper> {
  bool _reachedStretchTrigger = false;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _scrollController = ScrollController();
    } else {
      _scrollController = widget.scrollController;
    }
  }

  bool _handleUserScrollNotification(ScrollNotification notification) {
    final metrics = notification.metrics;

    if (!widget.onReleasePopEnabled) {
      return false;
    }

    if (notification is ScrollUpdateNotification &&
        notification.dragDetails != null) {
      // Dismiss keyboard on scroll up above screen extent
      if (widget.shouldUnfocusOnScroll) {
        _unfocusKeyboard();
      }

      final stretchOffset = metrics.outOfRange && metrics.pixels.isNegative
          ? metrics.pixels.abs()
          : 0.0;

      if (!_reachedStretchTrigger &&
          stretchOffset >= OverlayHeader.stretchTrigger) {
        Effects.playHapticTap();
        _reachedStretchTrigger = true;
      } else if (_reachedStretchTrigger &&
          stretchOffset < OverlayHeader.stretchTrigger) {
        Effects.playHapticTap();
        _reachedStretchTrigger = false;
      }
    }

    final releasedFinger = (notification is ScrollUpdateNotification &&
            notification.dragDetails == null) ||
        notification is ScrollEndNotification;

    if (releasedFinger && _reachedStretchTrigger) {
      _reachedStretchTrigger = false;

      widget.onReleasePopTrigger();
    }

    return false;
  }

  void _unfocusKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Palette.transparent,
      body: Stack(
        children: <Widget>[
          NotificationListener<ScrollNotification>(
            onNotification: _handleUserScrollNotification,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: widget.slivers,
            ),
          ),
          if (widget.overlayWidget != null) widget.overlayWidget,
        ],
      ),
    );
  }
}
