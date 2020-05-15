import 'package:flutter/widgets.dart';

class ScaleButton extends StatefulWidget {
  final bool enabled;
  final GestureTapCallback onPressed;
  final Widget child;
  final String label;

  const ScaleButton({
    Key key,
    this.enabled = true,
    @required this.onPressed,
    @required this.child,
    @required this.label,
  }) : super(key: key);

  @override
  _ScaleButtonState createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton>
    with TickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);

  final Tween<double> _opacityTween = Tween<double>(begin: 1.0, end: 0.5);
  AnimationController _opacityAnimController;
  Animation<double> _opacityAnim;

  final Tween<double> _scaleTween = Tween<double>(begin: 1.0, end: 0.98);
  AnimationController _scaleAnimController;
  Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _opacityAnimController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnim = _opacityAnimController
        .drive(CurveTween(curve: Curves.fastLinearToSlowEaseIn))
        .drive(_opacityTween);

    _scaleAnimController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _scaleAnim = _scaleAnimController
        .drive(CurveTween(curve: Curves.fastLinearToSlowEaseIn))
        .drive(_scaleTween);
  }

  @override
  void dispose() {
    _opacityAnimController.dispose();
    _opacityAnimController = null;
    _scaleAnimController.dispose();
    _scaleAnimController = null;
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handlePointerDown(PointerDownEvent event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_opacityAnimController.isAnimating) return;
    final wasHeldDown = _buttonHeldDown;

    final futures = <Future<void>>[];

    if (_buttonHeldDown) {
      futures.add(
          _opacityAnimController.animateTo(1.0, duration: kFadeOutDuration));
      futures
          .add(_scaleAnimController.animateTo(1.0, duration: kFadeOutDuration));
    } else {
      futures.add(
          _opacityAnimController.animateTo(0.0, duration: kFadeInDuration));
      futures
          .add(_scaleAnimController.animateTo(0.0, duration: kFadeInDuration));
    }

    Future.wait(futures).then(
        (value) => {if (mounted && wasHeldDown != _buttonHeldDown) _animate()});
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: widget.enabled ? _handlePointerDown : null,
      onPointerUp: widget.enabled ? _handlePointerUp : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapCancel: widget.enabled ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: Semantics(
          button: true,
          label: widget.label,
          child: FadeTransition(
            opacity: _opacityAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              alignment: Alignment.center,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
