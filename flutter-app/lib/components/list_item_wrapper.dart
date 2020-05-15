import 'package:flutter/material.dart';
import 'package:gentle/theme.dart';

class ListItemWrapper extends StatefulWidget {
  final GestureTapCallback onPressed;
  final Widget child;
  final double height;

  const ListItemWrapper({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.height = 60.0,
  }) : super(key: key);

  @override
  _ListItemWrapperState createState() => _ListItemWrapperState();
}

class _ListItemWrapperState extends State<ListItemWrapper> {
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);

  bool _buttonHeldDown = false;

  void _handlePointerDown(PointerDownEvent _) {
    if (!_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = true;
      });
    }
  }

  void _handlePointerUp(PointerUpEvent _) {
    if (_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = false;
      });
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      child: GestureDetector(
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed,
        child: Semantics(
          button: true,
          child: AnimatedContainer(
            duration: _buttonHeldDown ? kFadeOutDuration : kFadeInDuration,
            constraints: BoxConstraints(minHeight: widget.height),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: _buttonHeldDown
                  ? Palette.dividerBG
                  : Palette.dividerBGTransparent,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
