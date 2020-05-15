import 'package:gentle/components/gentle_bottom_app_bar.dart';
import 'package:gentle/providers/global_provider.dart';
import 'package:gentle/screens/help_screen.dart';
import 'package:gentle/screens/mailbox_screen.dart';
import 'package:gentle/screens/reply_screen.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tabs extends StatefulWidget {
  final int tabIndex;

  const Tabs({
    Key key,
    @required this.tabIndex,
  }) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this,
        length: GentleBottomAppBar.tabs.length,
        initialIndex: widget.tabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Tabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_tabController.index != widget.tabIndex) {
      _tabController.animateTo(widget.tabIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: Palette.white,
      bottomNavigationBar: GentleBottomAppBar(
        currentIndex: _tabController.index,
        scrollControllers: _scrollControllers,
        onTap: (int index) {
          setState(
            () {
              final provider =
                  Provider.of<GlobalProvider>(context, listen: false);
              provider.setTab(index);
            },
          );
        },
      ),
      body: _TabSwitchingView(
        currentTabIndex: _tabController.index,
        tabCount: _tabController.length,
        tabs: <Widget>[
          MailboxScreen(
            scrollController: _scrollControllers[0],
          ),
          ReplyScreen(
            scrollController: _scrollControllers[1],
          ),
          HelpScreen(
            scrollController: _scrollControllers[2],
          ),
        ],
      ),
    );
  }
}

class _TabSwitchingView extends StatefulWidget {
  final int currentTabIndex;
  final int tabCount;
  final List<Widget> tabs;

  const _TabSwitchingView({
    Key key,
    @required this.currentTabIndex,
    @required this.tabCount,
    @required this.tabs,
  }) : super(key: key);

  @override
  __TabSwitchingViewState createState() => __TabSwitchingViewState();
}

class __TabSwitchingViewState extends State<_TabSwitchingView>
    with TickerProviderStateMixin {
  final List<_ChildEntry> _entries = <_ChildEntry>[];

  final List<bool> shouldBuildTab = <bool>[];
  final List<bool> hasBuiltTab = <bool>[];
  final List<FocusScopeNode> tabFocusNodes = <FocusScopeNode>[];
  final List<FocusScopeNode> discardedNodes = <FocusScopeNode>[];

  int _transitioningToIndex;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.tabs.length; i++) {
      final tab = widget.tabs[i];

      final primaryController = AnimationController(
        duration: const Duration(milliseconds: 175),
        vsync: this,
        value: 0.0,
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _focusActiveTab();
          } else if (status == AnimationStatus.dismissed) {
            final newEntry = _entries[_transitioningToIndex];
            setState(() {
              if (i != _transitioningToIndex) {
                shouldBuildTab[i] = false;
              }
              _transitioningToIndex = null;
            });
            newEntry.primaryController.forward();
          }
        });

      _entries.add(_ChildEntry(
        child: tab,
        primaryController: primaryController,
      ));
    }

    shouldBuildTab.addAll(List<bool>.filled(widget.tabCount, false));
    shouldBuildTab[widget.currentTabIndex] = true;
    hasBuiltTab.addAll(List<bool>.filled(widget.tabCount, false));
    tabFocusNodes.addAll(List<FocusScopeNode>.generate(
        widget.tabCount,
        (int index) => FocusScopeNode(
            debugLabel: '$Tabs Tab ${index + tabFocusNodes.length}')));

    _entries[widget.currentTabIndex].primaryController.forward();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentTabIndex == widget.currentTabIndex) {
      return;
    }

    final oldEntry = _entries[oldWidget.currentTabIndex];

    if (_transitioningToIndex != null) {
      setState(() {
        shouldBuildTab[widget.currentTabIndex] = true;
        _transitioningToIndex = widget.currentTabIndex;
      });
      return;
    }

    setState(() {
      shouldBuildTab[widget.currentTabIndex] = true;
      _transitioningToIndex = widget.currentTabIndex;
    });

    oldEntry.primaryController.reverse();
  }

  @override
  void dispose() {
    for (final focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    for (final focusScopeNode in discardedNodes) {
      focusScopeNode.dispose();
    }
    for (final entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _focusActiveTab() {
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTabIndex]);
  }

  static final CurveTween _inCurve = CurveTween(
    curve: Curves.decelerate,
  );

  static final TweenSequence<double> _scaleIn = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.995),
        weight: 6 / 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.99, end: 1.0).chain(_inCurve),
        weight: 14 / 20,
      ),
    ],
  );

  static final TweenSequence<double> _fadeInOpacity = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.0),
        weight: 6 / 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(_inCurve),
        weight: 14 / 20,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List<Widget>.generate(
        widget.tabCount,
        (int index) {
          final isActiveTab = index == widget.currentTabIndex;
          hasBuiltTab[index] = isActiveTab || hasBuiltTab[index];
          final entry = _entries[index];

          return FadeTransition(
            opacity: _fadeInOpacity.animate(entry.primaryController),
            child: ScaleTransition(
              scale: _scaleIn.animate(entry.primaryController),
              child: Offstage(
                offstage: !shouldBuildTab[index],
                child: TickerMode(
                  enabled: isActiveTab,
                  child: FocusScope(
                    node: tabFocusNodes[index],
                    child: IgnorePointer(
                      ignoring: _transitioningToIndex != null,
                      child: hasBuiltTab[index] ? entry.child : Container(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChildEntry {
  final Widget child;
  final AnimationController primaryController;

  _ChildEntry({
    @required this.child,
    @required this.primaryController,
  });

  void dispose() {
    primaryController.dispose();
  }
}
