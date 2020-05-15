import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_header.dart';
import 'package:gentle/components/list_item_wrapper.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutBottomSheet extends StatefulWidget {
  static Future<void> show({@required BuildContext context}) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Palette.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      builder: (_) => AboutBottomSheet(),
    );
  }

  @override
  _AboutBottomSheetState createState() => _AboutBottomSheetState();
}

class _AboutBottomSheetState extends State<AboutBottomSheet> {
  Future<PackageInfo> _getPackageInfo() async {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const BottomSheetHeader(
            label: UIStrings.about,
          ),
          _AboutListItem(
            label: 'Gentle Homepage',
            icon: const AssetImage('assets/images/icons/40x40/gentle.png'),
            iconRotation: 4,
            onPressed: () async {
              if (await canLaunch(Constants.urlHomepage)) {
                await launch(Constants.urlHomepage, forceSafariVC: false);
              }
            },
          ),
          _AboutListItem(
            label: 'Terms',
            icon: const AssetImage('assets/images/icons/40x40/terms.png'),
            iconRotation: -4,
            onPressed: () async {
              if (await canLaunch(Constants.urlTerms)) {
                await launch(Constants.urlTerms, forceSafariVC: false);
              }
            },
          ),
          _AboutListItem(
            label: 'Privacy Policy',
            icon: const AssetImage(
                'assets/images/icons/40x40/privacy_policy.png'),
            iconRotation: 4,
            onPressed: () async {
              if (await canLaunch(Constants.urlPrivacy)) {
                await launch(Constants.urlPrivacy, forceSafariVC: false);
              }
            },
          ),
          FutureBuilder(
            future: _getPackageInfo(),
            builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                    'Gentle v${snapshot.data.version}+${snapshot.data.buildNumber}',
                    style: GentleText.wordCount),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AboutListItem extends StatelessWidget {
  final AssetImage icon;
  final double iconRotation;
  final String label;
  final String subLabel;
  final VoidCallback onPressed;

  const _AboutListItem({
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
              color: Palette.grayPrimary,
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
