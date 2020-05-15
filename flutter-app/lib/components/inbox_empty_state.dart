import 'dart:math';

import 'package:gentle/components/Buttons/pill_button.dart';
import 'package:flutter/material.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/global_provider.dart';
import 'package:gentle/screens/request_compose_screen.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class InboxEmptyState extends StatelessWidget {
  const InboxEmptyState({
    Key key,
    @required this.availableHeight,
  })  : assert(availableHeight > 0.0),
        super(key: key);

  final double availableHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: availableHeight),
      alignment: Alignment.center,
      child: Consumer<GlobalProvider>(
        builder: (_, provider, __) {
          final didSendLetterThisSession = provider.sentMail;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                image: didSendLetterThisSession
                    ? const AssetImage(
                        'assets/images/illustrations/emptystates/sleeping.png')
                    : const AssetImage(
                        'assets/images/illustrations/emptystates/mailbox.png'),
                width: 320,
                height: 140,
              ),
              const SizedBox(height: 8),
              Text(
                  didSendLetterThisSession
                      ? UIStrings.waitingForMail
                      : UIStrings.noMail,
                  style: GentleText.emptyStateTitle),
              const SizedBox(height: 16),
              Transform.rotate(
                angle: -3 * pi / 180,
                child: PillButton(
                  icon: didSendLetterThisSession
                      ? const AssetImage('assets/images/icons/16x16/reply.png')
                      : const AssetImage(
                          'assets/images/icons/16x16/airplane.png'),
                  onPressed: () {
                    if (didSendLetterThisSession) {
                      final globalProvider =
                          Provider.of<GlobalProvider>(context, listen: false);
                      globalProvider.setTab(1);
                      return;
                    }

                    Navigator.of(context)
                        .pushNamed(RequestComposeScreen.routeName);
                  },
                  label: didSendLetterThisSession
                      ? UIStrings.tryAReply
                      : UIStrings.writeRequest,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
