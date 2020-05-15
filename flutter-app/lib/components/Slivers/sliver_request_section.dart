import 'package:gentle/components/request_stack.dart';
import 'package:gentle/components/Slivers/tab_header_delegate.dart';
import 'package:gentle/components/request_stack_empty_state.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/request_stack_provider.dart';
import 'package:flutter/material.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SliverRequestSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final verticalScreenHeight = MediaQuery.of(context).size.height;
        var tallScreenExtraSpace = 0.0;
        if (verticalScreenHeight > 640.0) {
          tallScreenExtraSpace += 20.0;
        }

        final availableHeight = constraints.viewportMainAxisExtent -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom -
            tallScreenExtraSpace -
            TabHeader.maxExtent -
            Constants.sliverDividerHeight;

        final scrollController =
            Provider.of<ScrollController>(context, listen: false);

        return SliverToBoxAdapter(
          child: Container(
            height: availableHeight,
            child:
                ChangeNotifierProxyProvider<UserProvider, RequestStackProvider>(
              create: (_) =>
                  RequestStackProvider(scrollController: scrollController),
              update: (_, userProvider, requestStackModel) => requestStackModel
                ..handleUserProviderUpdate(
                  user: userProvider.user,
                  context: context,
                ),
              child: Consumer<RequestStackProvider>(
                builder: (_, stackProvider, __) => AnimatedCrossFade(
                  duration: Constants.mediumAnimDuration,
                  firstChild: RequestStack(
                    availableHeight: availableHeight,
                  ),
                  secondChild: RequestStackEmptyState(
                    availableHeight: availableHeight,
                  ),
                  crossFadeState:
                      stackProvider.status == RequestStackStatus.finished ||
                              stackProvider.status == RequestStackStatus.empty
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
