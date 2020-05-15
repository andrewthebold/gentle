import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_header.dart';
import 'package:gentle/components/tip_stack.dart';
import 'package:gentle/theme.dart';

enum TipBottomSheetType {
  request,
  letter,
}

class TipBottomSheet extends StatefulWidget {
  final TextEditingController textEditingController;
  final TipBottomSheetType type;

  const TipBottomSheet({
    Key key,
    @required this.textEditingController,
    @required this.type,
  }) : super(key: key);

  static Future<void> show({
    @required BuildContext context,
    @required TextEditingController textEditingController,
    @required TipBottomSheetType type,
  }) async {
    // Build the bottomsheet content prior to the route transition to improve
    // performance of trying to do both at the same time
    // https://github.com/flutter/flutter/issues/31059#issuecomment-500961641
    final bottomsheetBody = await Future.microtask(() {
      return TipBottomSheet(
        textEditingController: textEditingController,
        type: type,
      );
    });

    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Palette.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      builder: (_) => bottomsheetBody,
    );
  }

  @override
  _TipBottomSheetState createState() => _TipBottomSheetState();
}

class _TipBottomSheetState extends State<TipBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const BottomSheetHeader(
            label: 'Writing Tips',
          ),
          if (widget.type == TipBottomSheetType.request)
            const _TipListItem(
              iconAngle: 5,
              icon: AssetImage('assets/images/icons/48x48/expectations.png'),
              label: "Don't expect solutions",
            )
          else
            const _TipListItem(
              iconAngle: 5,
              icon: AssetImage('assets/images/icons/48x48/no_solutions.png'),
              label:
                  'It\'s okay to not solve their problem — kindness is enough',
            ),
          const _TipListItem(
            iconAngle: -5,
            icon: AssetImage('assets/images/icons/48x48/full_sentences.png'),
            label: 'Write full sentences',
          ),
          const _TipListItem(
            iconAngle: 5,
            icon: AssetImage('assets/images/icons/48x48/rules.png'),
            label: 'No personal info, ads, or links',
          ),
          const SizedBox(height: 24),
          Container(
            height: 240 + MediaQuery.of(context).padding.bottom,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Palette.dividerBGBorder,
                  width: 1,
                ),
              ),
              color: Palette.dividerBG,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                left: 8.0,
                right: 8.0,
              ),
              child: TipStack(
                textEditingController: widget.textEditingController,
                type: widget.type,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipListItem extends StatelessWidget {
  const _TipListItem({
    Key key,
    @required this.iconAngle,
    @required this.icon,
    @required this.label,
  }) : super(key: key);

  final int iconAngle;
  final AssetImage icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Row(
        children: <Widget>[
          Transform.rotate(
            angle: iconAngle * pi / 180,
            child: Image(
              image: icon,
              height: 48,
              width: 48,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: GentleText.listLabel),
          ),
        ],
      ),
    );
  }
}
