import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_checkbox_list_item.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_header.dart';
import 'package:gentle/components/Buttons/floating_done_button.dart';
import 'package:gentle/components/floating_loading_indicator.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/intro_screen_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class IntroBottomSheet extends StatelessWidget {
  static Future<void> show({
    @required BuildContext context,
    @required IntroScreenProvider provider,
  }) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Palette.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      builder: (_) => ChangeNotifierProvider<IntroScreenProvider>.value(
        value: provider,
        child: IntroBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final introProvider = Provider.of<IntroScreenProvider>(context);

    return Stack(
      children: <Widget>[
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const BottomSheetHeader(label: 'Rules'),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 32.0, bottom: 16.0),
                child: Text(
                    'Agree to these rules to help make Gentle a safe and special place.',
                    style: GentleText.introBody),
              ),
              AnimatedOpacity(
                duration: Constants.fastAnimDuration,
                opacity: introProvider.status == IntroScreenStatus.loading
                    ? 0.5
                    : 1.0,
                child: IgnorePointer(
                  ignoring: introProvider.status == IntroScreenStatus.loading,
                  child: Column(
                    children: <Widget>[
                      BottomSheetCheckboxListItem(
                        label: 'I won’t reveal personal information',
                        enabled: introProvider.checked.elementAt(0),
                        onChanged: (bool value) {
                          introProvider.toggleCheckbox(
                              index: 0, newValue: value);
                        },
                      ),
                      const SizedBox(height: 2),
                      BottomSheetCheckboxListItem(
                        label: 'I’ll report content that worries me',
                        enabled: introProvider.checked.elementAt(1),
                        onChanged: (bool value) {
                          introProvider.toggleCheckbox(
                              index: 1, newValue: value);
                        },
                      ),
                      const SizedBox(height: 2),
                      BottomSheetCheckboxListItem(
                        label:
                            'I know I can’t fix other’s problems, but I can share kindness',
                        enabled: introProvider.checked.elementAt(2),
                        onChanged: (bool value) {
                          introProvider.toggleCheckbox(
                              index: 2, newValue: value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
                height: introProvider.showContinue || introProvider.showLoading
                    ? 88
                    : 24,
              ),
            ],
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastLinearToSlowEaseIn,
          bottom: introProvider.showContinue
              ? (24 + MediaQuery.of(context).padding.bottom)
              : -80,
          right: 24,
          child: FloatingDoneButton(
            label: UIStrings.continueStep,
            icon: const AssetImage('assets/images/icons/24x24/check.png'),
            onPressed: () {
              introProvider.createAccount();
            },
            bgColor: Palette.blue,
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastLinearToSlowEaseIn,
          bottom: introProvider.showLoading
              ? (24 + MediaQuery.of(context).padding.bottom)
              : -80,
          right: 40,
          child: const FloatingLoadingIndicator(
            isDestructive: false,
          ),
        ),
      ],
    );
  }
}
