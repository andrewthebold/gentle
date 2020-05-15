import 'package:gentle/components/avatar.dart';
import 'package:gentle/components/Buttons/floating_done_button.dart';
import 'package:gentle/components/Buttons/overlay_header_action_button.dart';
import 'package:gentle/components/Slivers/overlay_header_delegate.dart';
import 'package:gentle/components/overlay_screen_wrapper.dart';
import 'package:gentle/components/Request/request_card.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/request_screen_provider.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatelessWidget {
  static const routeName = '/request';

  final String requestID;

  const RequestScreen({
    Key key,
    @required this.requestID,
  })  : assert(requestID != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestScreenProvider>(
      create: (_) => RequestScreenProvider(requestID, context),
      child: _RequestScreenBody(requestID: requestID),
    );
  }
}

class _RequestScreenBody extends StatefulWidget {
  final String requestID;

  const _RequestScreenBody({
    Key key,
    @required this.requestID,
  }) : super(key: key);

  @override
  __RequestScreenBodyState createState() => __RequestScreenBodyState();
}

class __RequestScreenBodyState extends State<_RequestScreenBody> {
  void _handleClose() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayScreenWrapper(
      onReleasePopTrigger: _handleClose,
      slivers: <Widget>[
        OverlayHeader(
          visible: true,
          actions: <Widget>[
            OverlayHeaderActionButton(
              icon: const AssetImage('assets/images/icons/24x24/cross.png'),
              iconColor: Palette.grayPrimary,
              text: UIStrings.close,
              textStyle: GentleText.appBarDefaultButtonLabel,
              onPressed: _handleClose,
            ),
          ],
        ),
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final verticalScreenHeight = MediaQuery.of(context).size.height;
            final requestSpaceHeight = verticalScreenHeight -
                MediaQuery.of(context).padding.top -
                OverlayHeader.height;

            return SliverToBoxAdapter(
                child: Container(
              height: requestSpaceHeight,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(
                  bottom: OverlayHeader.height,
                  left: 4.0,
                  right: 4.0,
                  top: 8.0),
              child: Consumer<RequestScreenProvider>(
                builder: (_, provider, __) {
                  RequestCardStatus status = RequestCardStatus.hidden;
                  if (provider.shouldShowLoadingIndicator) {
                    status = RequestCardStatus.loading;
                  }

                  if (provider.request != null) {
                    status = RequestCardStatus.visible;
                  }

                  switch (provider.errorStatus) {
                    case RequestScreenErrorStatus.none:
                      break;
                    case RequestScreenErrorStatus.deleted:
                      status = RequestCardStatus.deleted;
                      break;
                    case RequestScreenErrorStatus.offline:
                      status = RequestCardStatus.offline;
                      break;
                  }

                  return RequestCard(
                    status: status,
                    text: provider.request?.requestMessage ?? '',
                    avatarName:
                        provider.request?.requesterAvatar ?? AvatarName.unknown,
                    onPressedRefetch: () => provider.refetch(
                        context: context, requestID: widget.requestID),
                  );
                },
              ),
            ));
          },
        ),
      ],
      overlayWidget: Positioned(
        bottom: 24 + MediaQuery.of(context).padding.bottom,
        right: 24,
        child: FloatingDoneButton(
          label: UIStrings.done,
          icon: const AssetImage('assets/images/icons/24x24/check.png'),
          onPressed: _handleClose,
        ),
      ),
    );
  }
}
