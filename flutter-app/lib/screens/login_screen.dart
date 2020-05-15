import 'dart:math';

import 'package:gentle/components/Buttons/intro_button.dart';
import 'package:gentle/components/Slivers/intro_header_delegate.dart';
import 'package:gentle/components/Slivers/sliver_divider.dart';
import 'package:gentle/components/tab_wrapper.dart';
import 'package:gentle/providers/auth_provider.dart';
import 'package:gentle/providers/intro_screen_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class IntroScreen extends StatefulWidget {
  static const routeName = '/intro';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider2<AuthProvider, UserProvider,
        IntroScreenProvider>(
      create: (_) => IntroScreenProvider(),
      update: (_, authProvider, userProvider, introProvider) => introProvider
        ..handleAuthProviderUpdate(
          authProvider: authProvider,
          userProvider: userProvider,
          context: context,
        ),
      child: Scaffold(
        backgroundColor: Palette.white,
        body: Stack(
          children: <Widget>[
            TabWrapper(
              scrollController: _scrollController,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  const IntroHeader(),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 48),
                        const Center(
                          child: _SectionHeaderLabel(
                            label: 'Write a request for kindness',
                            icon: AssetImage(
                                'assets/images/icons/24x24/airplane.png'),
                            angle: -2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 280,
                          width: MediaQuery.of(context).size.width,
                          child: SizedOverflowBox(
                            size: const Size.fromHeight(220),
                            child: LoopAnimation<double>(
                              tween: Tween(begin: 0.0, end: 771.0),
                              duration: const Duration(milliseconds: 60000),
                              builder: (context, child, value) => Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: -value,
                                    child: child,
                                  ),
                                ],
                              ),
                              child: const Image(
                                height: 220,
                                width: 1293,
                                image: AssetImage(
                                  'assets/images/illustrations/rotating_cards.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverDivider(),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 48),
                        const Center(
                          child: _SectionHeaderLabel(
                            label: 'Send and receive kind replies',
                            icon: AssetImage(
                                'assets/images/icons/24x24/reply.png'),
                            angle: 2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: SizedOverflowBox(
                            size: const Size.fromHeight(160),
                            child: LoopAnimation<double>(
                              tween: Tween(begin: 0.0, end: 576.0),
                              duration: const Duration(milliseconds: 60000),
                              builder: (context, child, value) => Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: -value,
                                    child: child,
                                  ),
                                ],
                              ),
                              child: const Image(
                                height: 127,
                                width: 960,
                                image: AssetImage(
                                  'assets/images/illustrations/rotating_envelopes.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverDivider(),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 48),
                        const Center(
                          child: _SectionHeaderLabel(
                            label: 'Moderated and anonymous',
                            icon: AssetImage(
                                'assets/images/icons/24x24/shield.png'),
                            angle: -2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            _SubListItem(
                              text: 'Spam and bad word filters',
                              icon: AssetImage(
                                  'assets/images/icons/24x24/stamp.png'),
                              iconColor: Palette.blue,
                            ),
                            _SubListItem(
                              text: 'Reporting and moderation',
                              icon: AssetImage(
                                  'assets/images/icons/24x24/rabbit.png'),
                              iconColor: Palette.yellow,
                            ),
                            _SubListItem(
                              text: 'No ads or data selling',
                              icon: AssetImage(
                                  'assets/images/icons/24x24/lock.png'),
                              iconColor: Palette.green,
                            ),
                            _SubListItem(
                              text: 'Delete everything, anytime',
                              icon: AssetImage(
                                  'assets/images/icons/24x24/trash.png'),
                              iconColor: Palette.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedOverflowBox(
                      alignment: Alignment.topCenter,
                      size: Size(
                        double.infinity,
                        MediaQuery.of(context).padding.bottom + 136,
                      ),
                      child: Container(
                        height: 1000,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                            color: Palette.dividerBGBorder,
                            width: 1,
                          )),
                          color: Palette.dividerBG,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              child: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: IntroButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeaderLabel extends StatelessWidget {
  final String label;
  final AssetImage icon;
  final int angle;

  const _SectionHeaderLabel({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.angle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * pi / 180,
      child: DecoratedBox(
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Palette.blueTertiary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                height: 24,
                width: 24,
                image: icon,
                color: Palette.blue,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GentleText.sectionLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubListItem extends StatelessWidget {
  final AssetImage icon;
  final String text;
  final Color iconColor;

  const _SubListItem({
    Key key,
    @required this.icon,
    @required this.text,
    this.iconColor = Palette.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 304,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            image: icon,
            height: 24,
            width: 24,
            color: iconColor,
          ),
          const SizedBox(width: 14),
          Flexible(
            fit: FlexFit.loose,
            child: Text(text, style: GentleText.listLabel),
          )
        ],
      ),
    );
  }
}
