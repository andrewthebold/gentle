import 'dart:math';

import 'package:gentle/components/Buttons/pill_button.dart';
import 'package:flutter/material.dart';
import 'package:gentle/components/Buttons/small_button.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/global_provider.dart';
import 'package:gentle/providers/request_stack_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class RequestStackEmptyState extends StatelessWidget {
  const RequestStackEmptyState({
    Key key,
    @required this.availableHeight,
  })  : assert(availableHeight > 0.0),
        super(key: key);

  final double availableHeight;

  @override
  Widget build(BuildContext context) {
    final stackProvider = Provider.of<RequestStackProvider>(context);

    return Container(
      height: availableHeight,
      alignment: Alignment.center,
      child: Consumer<GlobalProvider>(
        builder: (_, provider, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Spacer(),
              const Image(
                image: AssetImage(
                    'assets/images/illustrations/emptystates/love.png'),
                width: 200,
                height: 140,
              ),
              const SizedBox(height: 8),
              Text(
                  stackProvider.status == RequestStackStatus.empty
                      ? UIStrings.noMoreRequests
                      : UIStrings.endOfStack,
                  style: GentleText.emptyStateTitle),
              const Spacer(),
              Opacity(
                opacity: stackProvider.queuedRequestCount > 0 ? 1.0 : 0.0,
                child: Stack(
                  children: <Widget>[
                    IgnorePointer(
                      ignoring: stackProvider.queuedRequestCount <= 0,
                      child: SmallButton(
                        icon: const AssetImage(
                            'assets/images/icons/32x32/redo.png'),
                        label: UIStrings.restart,
                        onPressed: stackProvider.loadQueuedRequests,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Transform.rotate(
                angle: -3 * pi / 180,
                child: PillButton(
                  icon: stackProvider.status == RequestStackStatus.empty
                      ? const AssetImage('assets/images/icons/16x16/redo.png')
                      : const AssetImage(
                          'assets/images/icons/16x16/download.png'),
                  onPressed: () =>
                      stackProvider.loadNewRequests(context: context),
                  label: stackProvider.status == RequestStackStatus.empty
                      ? UIStrings.startRequestsAgain
                      : UIStrings.getNewRequests,
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}
