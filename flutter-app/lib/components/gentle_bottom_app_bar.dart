import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/global_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

enum BottomNavTab {
  mailbox,
  requests,
  help,
}

class GentleBottomAppBar extends StatefulWidget {
  static const List<BottomNavTab> tabs = [
    BottomNavTab.mailbox,
    BottomNavTab.requests,
    BottomNavTab.help,
  ];
  static const Color selectedIconTheme = Palette.blue;
  static const Color unselectedIconTheme = Palette.grayPrimary;

  final ValueChanged<int> onTap;
  final int currentIndex;
  final List<ScrollController> scrollControllers;

  const GentleBottomAppBar({
    Key key,
    @required this.onTap,
    @required this.currentIndex,
    @required this.scrollControllers,
  })  : assert(onTap != null),
        assert(currentIndex != null),
        super(key: key);

  @override
  _GentleBottomAppBarState createState() => _GentleBottomAppBarState();
}

class _GentleBottomAppBarState extends State<GentleBottomAppBar>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = <AnimationController>[];
  List<CurvedAnimation> _animations;

  void _resetState() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    _controllers = List<AnimationController>.generate(
        GentleBottomAppBar.tabs.length, (int index) {
      return AnimationController(duration: kThemeAnimationDuration, vsync: this)
        ..addListener(_rebuild);
    });

    _animations = List<CurvedAnimation>.generate(GentleBottomAppBar.tabs.length,
        (int index) {
      return CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn.flipped,
      );
    });

    _controllers[widget.currentIndex].value = 1.0;
  }

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(GentleBottomAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentIndex != oldWidget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).padding.bottom + Constants.bottomBarHeight,
      child: Container(
        decoration: const BoxDecoration(
          color: Palette.white,
          boxShadow: [GentleShadow.basic],
          border: Border(
            top: BorderSide(
              color: Palette.grayTertiary,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _createTiles(
              context,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createTiles(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    assert(localizations != null);

    final tiles = <Widget>[];
    for (var i = 0; i < GentleBottomAppBar.tabs.length; i++) {
      tiles.add(
        _BottomNavTile(
          tab: GentleBottomAppBar.tabs[i],
          selected: i == widget.currentIndex,
          animation: _animations[i],
          onTap: () {
            // Scroll to the top of the current tab if possible
            if (widget.currentIndex == i &&
                widget.scrollControllers[i].hasClients &&
                widget.scrollControllers[i].offset > 0) {
              widget.scrollControllers[i].animateTo(0.0,
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 600));
            }
            widget.onTap(i);
          },
          indexLabel: localizations.tabLabel(
            tabIndex: i + 1,
            tabCount: GentleBottomAppBar.tabs.length,
          ),
        ),
      );
    }

    return tiles;
  }
}

class _BottomNavTile extends StatefulWidget {
  final BottomNavTab tab;
  final bool selected;
  final Animation<double> animation;
  final VoidCallback onTap;
  final String indexLabel;

  const _BottomNavTile({
    Key key,
    @required this.tab,
    @required this.selected,
    @required this.animation,
    @required this.onTap,
    @required this.indexLabel,
  })  : assert(tab != null),
        assert(selected != null),
        super(key: key);

  @override
  _BottomNavTileState createState() => _BottomNavTileState();
}

class _BottomNavTileState extends State<_BottomNavTile>
    with SingleTickerProviderStateMixin {
  AnimationController _scaleController;

  @override
  void initState() {
    _scaleController = AnimationController(
      duration: Constants.fastAnimDuration,
      vsync: this,
      value: 1.0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handlePointerDown(PointerDownEvent event) {
    setState(() {
      _scaleController.animateTo(0.95);
    });
  }

  void _handlePointerUp(PointerUpEvent event) {
    setState(() {
      _scaleController.animateTo(1.0);
    });
  }

  void _handleTapCancel() {
    setState(() {
      _scaleController.animateTo(1.0);
    });
  }

  void _onTap() {
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        container: true,
        selected: widget.selected,
        child: Listener(
          onPointerDown: _handlePointerDown,
          onPointerUp: _handlePointerUp,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            onTapCancel: _handleTapCancel,
            child: Stack(
              children: <Widget>[
                Center(
                  child: ScaleTransition(
                    scale: _scaleController,
                    child: _BottomNavTileIcon(
                      tab: widget.tab,
                      isActive: widget.selected,
                    ),
                  ),
                ),
                Semantics(
                  label: widget.indexLabel,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavTileIcon extends StatelessWidget {
  final BottomNavTab tab;
  final bool isActive;

  const _BottomNavTileIcon(
      {Key key, @required this.tab, @required this.isActive})
      : assert(tab != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);

    double rotation;
    AssetImage icon;
    AssetImage activeIcon;
    AssetImage emptyIcon;
    AssetImage activeEmptyIcon;

    switch (tab) {
      case BottomNavTab.mailbox:
        rotation = 5;
        icon = const AssetImage('assets/images/icons/56x56/mailbox.png');
        activeIcon =
            const AssetImage('assets/images/icons/56x56/mailbox_active.png');
        emptyIcon =
            const AssetImage('assets/images/icons/56x56/mailbox_empty.png');
        activeEmptyIcon = const AssetImage(
            'assets/images/icons/56x56/mailbox_empty_active.png');
        break;
      case BottomNavTab.requests:
        rotation = 0;
        icon = const AssetImage('assets/images/icons/56x56/reply.png');
        activeIcon =
            const AssetImage('assets/images/icons/56x56/reply_active.png');
        break;
      case BottomNavTab.help:
        rotation = -5;
        icon = const AssetImage('assets/images/icons/56x56/help.png');
        activeIcon =
            const AssetImage('assets/images/icons/56x56/help_active.png');
        break;
    }

    final emptyIconsVisible =
        !globalProvider.hasInboxItems && tab == BottomNavTab.mailbox;

    final iconVisible = !emptyIconsVisible && !isActive;
    final activeIconVisible = !emptyIconsVisible && isActive;
    final emptyIconVisible = emptyIconsVisible && !isActive;
    final activeEmptyIconVisible = emptyIconsVisible && isActive;

    return Transform.rotate(
      angle: rotation * pi / 180,
      child: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: iconVisible ? 1.0 : 0.0,
            duration: Constants.fastAnimDuration,
            child: Image(
              image: icon,
              height: 56,
              width: 56,
            ),
          ),
          AnimatedOpacity(
            opacity: activeIconVisible ? 1.0 : 0.0,
            duration: Constants.fastAnimDuration,
            child: Image(
              image: activeIcon,
              height: 56,
              width: 56,
            ),
          ),
          if (tab == BottomNavTab.mailbox) ...[
            AnimatedOpacity(
              opacity: emptyIconVisible ? 1.0 : 0.0,
              duration: Constants.fastAnimDuration,
              child: Image(
                image: emptyIcon,
                height: 56,
                width: 56,
              ),
            ),
            AnimatedOpacity(
              opacity: activeEmptyIconVisible ? 1.0 : 0.0,
              duration: Constants.fastAnimDuration,
              child: Image(
                image: activeEmptyIcon,
                height: 56,
                width: 56,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
