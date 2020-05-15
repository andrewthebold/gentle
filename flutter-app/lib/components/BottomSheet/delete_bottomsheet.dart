import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_header.dart';
import 'package:gentle/components/Buttons/floating_done_button.dart';
import 'package:gentle/components/floating_loading_indicator.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/auth_provider.dart';
import 'package:gentle/providers/delete_bottomsheet_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class DeleteBottomSheet extends StatelessWidget {
  static Future<void> show({
    @required BuildContext context,
  }) async {
    await showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        backgroundColor: Palette.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        builder: (_) => ChangeNotifierProxyProvider2<AuthProvider, UserProvider,
                DeleteBottomsheetProvider>(
              create: (_) => DeleteBottomsheetProvider(),
              update: (_, authProvider, userProvider, deleteProvider) =>
                  deleteProvider
                    ..handleAuthProviderUpdate(
                        authProvider: authProvider, userProvider: userProvider),
              child: DeleteBottomSheet(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final deleteProvider = Provider.of<DeleteBottomsheetProvider>(context);

    return Stack(
      children: <Widget>[
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              BottomSheetHeader(label: UIStrings.deleteAccountHeader),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: Text(UIStrings.deleteAccountDescription,
                    style: GentleText.introBody),
              ),
              _SubListItem(
                text: UIStrings.deleteAccountExplanation1,
                icon: AssetImage('assets/images/icons/24x24/trash.png'),
                iconColor: Palette.grayPrimary,
              ),
              // _SubListItem(
              //   text: UIStrings.deleteAccountExplanation2,
              //   icon: AssetImage('assets/images/icons/24x24/copy.png'),
              //   iconColor: Palette.grayPrimary,
              // ),
              _SubListItem(
                text: UIStrings.deleteAccountExplanation3,
                icon: AssetImage('assets/images/icons/24x24/warning.png'),
                iconColor: Palette.grayPrimary,
              ),
              SizedBox(
                height: 88,
              ),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastLinearToSlowEaseIn,
          bottom: deleteProvider.status == DeleteBottomsheetStatus.ready
              ? (24 + MediaQuery.of(context).padding.bottom)
              : -80,
          right: 24,
          child: FloatingDoneButton(
            label: UIStrings.delete,
            icon: const AssetImage('assets/images/icons/24x24/trash.png'),
            onPressed: () => deleteProvider.handleDelete(context: context),
            bgColor: Palette.red,
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastLinearToSlowEaseIn,
          bottom: deleteProvider.status == DeleteBottomsheetStatus.loading
              ? (24 + MediaQuery.of(context).padding.bottom)
              : -80,
          right: 40,
          child: const FloatingLoadingIndicator(
            isDestructive: true,
          ),
        ),
      ],
    );
  }
}

class _SubListItem extends StatelessWidget {
  final AssetImage icon;
  final String text;
  final Color iconColor;

  const _SubListItem({
    Key key,
    @required this.icon,
    @required this.text,
    this.iconColor = Palette.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 40,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            image: icon,
            height: 24,
            width: 24,
            color: iconColor,
          ),
          const SizedBox(width: 14),
          Flexible(
            fit: FlexFit.loose,
            child: Text(text, style: GentleText.listLabel),
          )
        ],
      ),
    );
  }
}
