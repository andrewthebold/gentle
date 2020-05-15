import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/Buttons/pill_button.dart';
import 'package:gentle/theme.dart';

class ErrorStateOffline extends StatelessWidget {
  final VoidCallback onPressedRefetch;

  const ErrorStateOffline({
    Key key,
    @required this.onPressedRefetch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We wrap in a scrollview to allow the envelope hero animation to not cause
    // an overflow of this content
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage(
                  'assets/images/illustrations/emptystates/offline.png'),
              width: 200,
              height: 100,
            ),
            const SizedBox(height: 8),
            const Text(
              'Oh no!',
              style: GentleText.subHeadlineText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const SizedBox(
              width: 240,
              child: Text(
                'It looks like you’re offline, so we couldn’t get this message.',
                style: GentleText.errorStateDescription,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Transform.rotate(
              angle: 3 * pi / 180,
              child: PillButton(
                icon: const AssetImage('assets/images/icons/16x16/redo.png'),
                label: 'Try again',
                onPressed: onPressedRefetch,
              ),
            )
          ],
        ),
      ),
    );
  }
}
