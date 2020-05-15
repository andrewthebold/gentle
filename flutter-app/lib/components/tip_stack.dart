import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/tip_bottomsheet.dart';
import 'package:gentle/components/Buttons/pill_button.dart';
import 'package:gentle/components/Buttons/small_button.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/tip_stack_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class TipStack extends StatefulWidget {
  final TextEditingController textEditingController;
  final TipBottomSheetType type;

  const TipStack({
    Key key,
    @required this.textEditingController,
    @required this.type,
  }) : super(key: key);

  @override
  _TipStackState createState() => _TipStackState();
}

class _TipStackState extends State<TipStack> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ChangeNotifierProvider<TipStackProvider>(
        create: (_) => TipStackProvider(type: widget.type),
        child: Consumer<TipStackProvider>(
          builder: (_, stackProvider, __) => Container(
            height: 228,
            child: Stack(
              children: <Widget>[
                Builder(builder: (BuildContext context) {
                  final tips = stackProvider.tips;

                  final stack = <Widget>[];
                  for (var i = tips.length - 1; i >= 0; i--) {
                    final cursor = stackProvider.cursor;
                    // -1 indicates that the card has "popped" and animated out upwards
                    final location = max(i - cursor, -1);

                    // We don't need to render cards that aren't visible (or haven't just animated out)
                    if (i - cursor <= -2 || i - cursor > 4) {
                      continue;
                    }

                    stack.add(
                      _TipCard(
                        key: ValueKey(i),
                        location: location,
                        tip: tips[i],
                        textEditingController: widget.textEditingController,
                      ),
                    );
                  }

                  return Stack(
                    overflow: Overflow.visible,
                    alignment: Alignment.center,
                    children: stack,
                  );
                }),
                Positioned(
                  right: 8,
                  top: 148,
                  child: SmallButton(
                    icon:
                        const AssetImage('assets/images/icons/32x32/skip.png'),
                    label: UIStrings.skipRequest,
                    onPressed: stackProvider.popTip,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatefulWidget {
  final TipModel tip;
  final int location;
  final TextEditingController textEditingController;

  const _TipCard({
    Key key,
    @required this.tip,
    @required this.location,
    @required this.textEditingController,
  })  : assert(tip != null),
        super(key: key);

  @override
  __TipCardState createState() => __TipCardState();
}

class __TipCardState extends State<_TipCard> {
  double _calcYOffset() {
    const top = 8.0;
    const bottom = 8.0;

    const availableHeight = 228;

    if (widget.location < 0) {
      return -availableHeight / 8;
    }

    const spaceAfterBottomOfFirstCard = availableHeight - top - 172 - bottom;

    // 0%   ->  0 * 0.15
    // 10%  ->  1 * 0.30
    // 30%  ->  2 * 0.45
    // 60%  ->  3 * 0.60
    // 100% ->  4 * 0.75

    final multiplier = (widget.location + 1) * 0.15;
    final yOffset =
        top + (widget.location * multiplier * spaceAfterBottomOfFirstCard);

    return yOffset;
  }

  double _calcOpacity() {
    switch (widget.location) {
      case 0:
        return 1.0;
      case 1:
        return 0.5;
      case 2:
        return 0.25;
      case 3:
        return 0.125;
      case 4:
        return 0.0;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      width: MediaQuery.of(context).size.width - 12,
      duration: Constants.weightyAnimDuration,
      curve: Curves.fastOutSlowIn,
      top: _calcYOffset(),
      child: AnimatedOpacity(
        duration: Constants.fastAnimDuration,
        opacity: _calcOpacity(),
        child: _TipCardWrapper(
          child: widget.location == 0
              ? (widget.tip.type == TipType.quote
                  ? _TipCardQuote(
                      tip: widget.tip,
                    )
                  : _TipCardStem(
                      tip: widget.tip,
                      textEditingController: widget.textEditingController,
                    ))
              : Container(),
        ),
      ),
    );
  }
}

class _TipCardWrapper extends StatelessWidget {
  const _TipCardWrapper({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Palette.graySecondary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [GentleShadow.basic],
        color: Palette.white,
      ),
      height: 172,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: child,
      ),
    );
  }
}

class _TipCardQuote extends StatelessWidget {
  final TipModel tip;

  const _TipCardQuote({
    Key key,
    @required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: const <Widget>[
            Image(
              image: AssetImage("assets/images/icons/16x16/quote.png"),
              height: 16,
              width: 16,
              color: Palette.blue,
            ),
            SizedBox(width: 8),
            Text('Quote', style: GentleText.tipCardTitle),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 2,
          child: AutoSizeText(
            tip.quote,
            style: GentleText.listLabel,
            minFontSize: 10,
          ),
        ),
        // const Spacer(),
        const SizedBox(height: 8),
        Text(
          tip.attribution,
          style: GentleText.tipCardAttribution,
        ),
      ],
    );
  }
}

class _TipCardStem extends StatelessWidget {
  final TipModel tip;
  final TextEditingController textEditingController;

  const _TipCardStem({
    Key key,
    @required this.tip,
    @required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final random = Random(tip.stem.hashCode);
    final angle = random.nextInt(6) - 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(
              image: AssetImage("assets/images/icons/16x16/pencil.png"),
              height: 16,
              width: 16,
              color: Palette.blue,
            ),
            SizedBox(width: 8),
            Text(
              'Writing Stem',
              style: GentleText.tipCardTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 2,
          child: AutoSizeText(
            '${tip.stem}  _______________',
            style: GentleText.listLabel,
            minFontSize: 10,
            textAlign: TextAlign.center,
          ),
        ),
        Transform.rotate(
          angle: angle * pi / 180,
          child: PillButton(
            icon: const AssetImage(
              "assets/images/icons/16x16/pencil_stroke.png",
            ),
            label: 'Write with this!',
            onPressed: () {
              textEditingController.text = '${tip.stem} ';
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}
