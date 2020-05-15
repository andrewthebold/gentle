import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_header.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_radio_list_item.dart';
import 'package:gentle/components/Buttons/floating_done_button.dart';
import 'package:gentle/components/floating_loading_indicator.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/models/report_model.dart';
import 'package:gentle/providers/report_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class ReportBottomSheet extends StatefulWidget {
  static const reportItems = <ReportItem>[
    ReportItem(
        label: UIStrings.reportLabelSpam,
        option: ReportOption.spam,
        subitems: [
          ReportSubItem(
            text: 'This content will be hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We\'ll moderate spammy behavior',
            icon: AssetImage('assets/images/icons/24x24/shield.png'),
          ),
        ],
        successTitle: 'Thank you',
        successSubItems: [
          ReportSubItem(
            text: 'Your report was submitted',
            icon: AssetImage('assets/images/icons/24x24/checkcircle.png'),
            color: Palette.green,
          ),
          ReportSubItem(
            text: 'This content was hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We\'ll investigate ASAP',
            icon: AssetImage('assets/images/icons/24x24/rabbit.png'),
          ),
        ]),
    ReportItem(
        label: UIStrings.reportLabelAbuse,
        option: ReportOption.abuse,
        subitems: [
          ReportSubItem(
            text: 'This content will be hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We\'ll moderate abusive behavior',
            icon: AssetImage('assets/images/icons/24x24/shield.png'),
          ),
        ],
        successTitle: 'Thank you',
        successSubItems: [
          ReportSubItem(
            text: 'Your report was submitted',
            icon: AssetImage('assets/images/icons/24x24/checkcircle.png'),
            color: Palette.green,
          ),
          ReportSubItem(
            text: 'This content was hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We\'ll investigate ASAP',
            icon: AssetImage('assets/images/icons/24x24/rabbit.png'),
          ),
        ]),
    ReportItem(
        label: UIStrings.reportLabelConcern,
        option: ReportOption.concern,
        subitems: [
          ReportSubItem(
            text: 'This content will be hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We may reach out with support',
            icon: AssetImage('assets/images/icons/24x24/lifering.png'),
          ),
        ],
        successTitle: 'Thank you',
        successSubItems: [
          ReportSubItem(
            text: 'Your report was submitted',
            icon: AssetImage('assets/images/icons/24x24/checkcircle.png'),
            color: Palette.green,
          ),
          ReportSubItem(
            text: 'This content was hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We\'ll investigate ASAP',
            icon: AssetImage('assets/images/icons/24x24/rabbit.png'),
          ),
        ]),
    ReportItem(
        label: UIStrings.reportLabelPII,
        option: ReportOption.pii,
        subitems: [
          ReportSubItem(
            text: 'This content will be hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We\'ll remove identifying info',
            icon: AssetImage('assets/images/icons/24x24/shield.png'),
          ),
        ],
        successTitle: 'Thank you',
        successSubItems: [
          ReportSubItem(
            text: 'Your report was submitted',
            icon: AssetImage('assets/images/icons/24x24/checkcircle.png'),
            color: Palette.green,
          ),
          ReportSubItem(
            text: 'This content was hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We\'ll investigate ASAP',
            icon: AssetImage('assets/images/icons/24x24/rabbit.png'),
          ),
        ]),
    ReportItem(
        label: 'Block this person',
        option: ReportOption.block,
        subitems: [
          ReportSubItem(
            text: 'You will no longer see their content',
            icon: AssetImage('assets/images/icons/24x24/cross.png'),
          ),
          ReportSubItem(
            text: 'They will not know you did this',
            icon: AssetImage('assets/images/icons/24x24/lock.png'),
          ),
          ReportSubItem(
            text: 'You can\'t undo this',
            icon: AssetImage('assets/images/icons/24x24/warning.png'),
          ),
        ],
        isDestructive: true,
        successTitle: 'Block success',
        successSubItems: [
          ReportSubItem(
            text: 'This person was blocked',
            icon: AssetImage('assets/images/icons/24x24/checkcircle.png'),
            color: Palette.green,
          ),
          ReportSubItem(
            text: 'Their content was hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'They will not know you did this',
            icon: AssetImage('assets/images/icons/24x24/lock.png'),
          ),
        ]),
    ReportItem(
        label: UIStrings.reportLabelOther,
        option: ReportOption.other,
        subitems: [
          ReportSubItem(
            text: 'This content will be hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We\'ll investigate this content ASAP',
            icon: AssetImage('assets/images/icons/24x24/rabbit.png'),
          ),
        ],
        successTitle: 'Thank you',
        successSubItems: [
          ReportSubItem(
            text: 'Your report was submitted',
            icon: AssetImage('assets/images/icons/24x24/checkcircle.png'),
            color: Palette.green,
          ),
          ReportSubItem(
            text: 'This content will be hidden for you',
            icon: AssetImage('assets/images/icons/24x24/hideeye.png'),
          ),
          ReportSubItem(
            text: 'We\'ll investigate ASAP',
            icon: AssetImage('assets/images/icons/24x24/rabbit.png'),
          ),
        ]),
  ];

  static Future<void> show({
    @required BuildContext context,
    @required String contentToReportID,
    @required String contentToReportCreatorID,
    @required ContentType contentToReportType,
    @required String contentToReportExcerpt,
  }) async {
    // Build the bottomsheet content prior to the route transition to improve
    // performance of trying to do both at the same time
    // https://github.com/flutter/flutter/issues/31059#issuecomment-500961641
    final bottomsheetBody = await Future.microtask(() {
      return ChangeNotifierProxyProvider<UserProvider, ReportProvider>(
        create: (_) => ReportProvider(
          contentToReportID: contentToReportID,
          contentToReportCreatorID: contentToReportCreatorID,
          contentToReportType: contentToReportType,
          contentToReportExcerpt: contentToReportExcerpt,
        ),
        update: (_, userProvider, reportProvider) =>
            reportProvider..handleUserUpdate(user: userProvider.user),
        child: ReportBottomSheet(),
      );
    });

    await showModalBottomSheet<bool>(
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
  _ReportBottomSheetState createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (_, provider, __) {
        final selectedItem = provider.selectedOption != null
            ? ReportBottomSheet.reportItems.firstWhere(
                (element) => element.option == provider.selectedOption,
                orElse: () => null)
            : null;

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 800),
          firstCurve: Curves.fastLinearToSlowEaseIn,
          secondCurve: Curves.fastLinearToSlowEaseIn,
          sizeCurve: Curves.fastLinearToSlowEaseIn,
          firstChild: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      const BottomSheetHeader(
                        label: UIStrings.reportTitle,
                      ),
                      AnimatedOpacity(
                          opacity: provider.status ==
                                  ReportBottomsheetStatus.selecting
                              ? 1.0
                              : 0.5,
                          duration: Constants.fastAnimDuration,
                          child: IgnorePointer(
                            ignoring: provider.status !=
                                ReportBottomsheetStatus.selecting,
                            child: Column(
                              children: ReportBottomSheet.reportItems
                                  .map(
                                    (item) => BottomSheetRadioListItem(
                                      item: item,
                                      groupValue: provider.selectedOption,
                                      onChanged: (option) =>
                                          provider.select(option),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: provider.selectedOption != null ? 64 : 24,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
                bottom: provider.submitButtonVisible
                    ? (24 + MediaQuery.of(context).padding.bottom)
                    : -80,
                right: 24,
                child: FloatingDoneButton(
                  label:
                      provider.selectedOptionIsDestructive ? 'Block' : 'Report',
                  icon: provider.selectedOptionIsDestructive
                      ? const AssetImage('assets/images/icons/24x24/cross.png')
                      : const AssetImage('assets/images/icons/24x24/flag.png'),
                  onPressed: () {
                    provider.submitReport(
                      context: context,
                    );
                  },
                  bgColor: provider.selectedOptionIsDestructive
                      ? Palette.red
                      : Palette.blue,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
                bottom: provider.loadingIndicatorVisible
                    ? (24 + MediaQuery.of(context).padding.bottom)
                    : -80,
                right: 40,
                child: FloatingLoadingIndicator(
                  isDestructive: provider.selectedOptionIsDestructive,
                ),
              ),
            ],
          ),
          secondChild: Stack(
            children: <Widget>[
              // Helps the [AnimatedCrossFade] to determine an initial height
              const SizedBox(
                height: 16,
              ),

              if (provider.status == ReportBottomsheetStatus.success)
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      BottomSheetHeader(
                        label: selectedItem.successTitle,
                      ),
                      ...selectedItem.successSubItems
                          .map((item) => _SubListItem(
                                icon: item.icon,
                                text: item.text,
                                iconColor: item.color,
                              )),
                      Container(
                        height: 80,
                      ),
                    ],
                  ),
                ),

              Positioned(
                bottom: 24 + MediaQuery.of(context).padding.bottom,
                right: 24,
                child: FloatingDoneButton(
                  label: 'Done',
                  icon: const AssetImage('assets/images/icons/24x24/check.png'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          crossFadeState: provider.status == ReportBottomsheetStatus.success
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        );
      },
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
      height: 40,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 16),
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
