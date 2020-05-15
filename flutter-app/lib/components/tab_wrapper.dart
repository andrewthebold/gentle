import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gentle/components/gradient_bg.dart';

// Basic layout wrapper for a primary tab (those that are persistent).
//
// Provides:
// - Gradient background that scrolls with the child scroll view
// - Scrollbar
class TabWrapper extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  const TabWrapper({@required this.child, @required this.scrollController});

  @override
  _TabWrapperState createState() => _TabWrapperState();
}

class _TabWrapperState extends State<TabWrapper> {
  // Offset in order to make the gradient visible on iOS's scroll bounce area
  double _scrollPos = -GradientBG.paddingTop;

  bool _handleNotification(ScrollUpdateNotification notification) {
    setState(() {
      _scrollPos = -notification.metrics.pixels - GradientBG.paddingTop;
    });
    // Return false to let notification continue to bubble up tree
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: _scrollPos,
          width: MediaQuery.of(context).size.width,
          child: GradientBG(),
        ),
        Scrollbar(
          controller: widget.scrollController,
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: _handleNotification,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
