import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_header.dart';
import 'package:gentle/components/list_item_wrapper.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/export_bottomsheet_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class ExportBottomsheet extends StatelessWidget {
  static Future<void> show({
    @required BuildContext context,
  }) async {
    // Build the bottomsheet content prior to the route transition to improve
    // performance of trying to do both at the same time
    // https://github.com/flutter/flutter/issues/31059#issuecomment-500961641
    final bottomsheetBody = await Future.microtask(() {
      return ChangeNotifierProxyProvider<UserProvider,
          ExportBottomsheetProvider>(
        create: (_) => ExportBottomsheetProvider(),
        update: (_, userProvider, exportProvider) => exportProvider
          ..handleUserProviderUpdate(userProvider: userProvider),
        child: ExportBottomsheet(),
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
  Widget build(BuildContext context) {
    final provider = Provider.of<ExportBottomsheetProvider>(context);
    return Stack(
      children: <Widget>[
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const BottomSheetHeader(label: 'Export your data?'),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: Text(
                    'You have until May 15th, 5PM PST to export your messages.',
                    style: GentleText.introBody),
              ),
              AnimatedCrossFade(
                duration: Constants.fastAnimDuration,
                firstChild: Column(
                  children: <Widget>[
                    _ExportListItem(
                      label: 'Send an email',
                      icon: const AssetImage(
                          'assets/images/icons/24x24/airplane.png'),
                      iconRotation: 0,
                      onPressed: () {
                        provider.sendMail();
                      },
                    ),
                    _ExportListItem(
                      label: 'Copy to clipboard',
                      icon: const AssetImage(
                          'assets/images/icons/24x24/copy.png'),
                      iconRotation: 0,
                      onPressed: () async {
                        await provider.copyToClipboard();
                      },
                    ),
                  ],
                ),
                secondChild: Column(
                  children: <Widget>[
                    IgnorePointer(
                      ignoring: provider.loading,
                      child: AnimatedOpacity(
                        duration: Constants.fastAnimDuration,
                        opacity: provider.loading ? 0.5 : 1.0,
                        child: _ExportListItem(
                          label: 'Load data for export',
                          icon: const AssetImage(
                              'assets/images/icons/24x24/download.png'),
                          iconRotation: 0,
                          onPressed: () {
                            provider.fetchData();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                crossFadeState: provider.dataFetched
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExportListItem extends StatelessWidget {
  final AssetImage icon;
  final double iconRotation;
  final String label;
  final String subLabel;
  final VoidCallback onPressed;

  const _ExportListItem({
    Key key,
    @required this.icon,
    @required this.iconRotation,
    @required this.label,
    this.subLabel,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListItemWrapper(
      height: subLabel != null ? 64 : 48,
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Transform.rotate(
            angle: iconRotation * pi / 180,
            child: Image(
              image: icon,
              height: 40,
              width: 40,
              color: Palette.blue,
            ),
          ),
          Container(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: GentleText.listLabel),
              if (subLabel != null)
                Text(subLabel, style: GentleText.listSecondaryLabel),
            ],
          )
        ],
      ),
    );
  }
}
