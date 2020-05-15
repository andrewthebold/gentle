import 'package:flutter/material.dart';
import 'package:gentle/theme.dart';

class ErrorStateDeleted extends StatelessWidget {
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
          children: const <Widget>[
            Image(
              image: AssetImage(
                  'assets/images/illustrations/emptystates/deleted.png'),
              width: 200,
              height: 100,
            ),
            SizedBox(height: 8),
            Text(
              'Oh no!',
              style: GentleText.subHeadlineText,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 240,
              child: Text(
                'It looks like this message was deleted.',
                style: GentleText.errorStateDescription,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
