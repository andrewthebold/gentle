import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/bottomsheet_header.dart';
import 'package:gentle/components/Buttons/floating_done_button.dart';
import 'package:gentle/effects.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/providers/error_bottomsheet_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class ErrorBottomSheet extends StatefulWidget {
  static Future<void> reportAndShow(BuildContext context,
      GentleException exception, dynamic stackTrace) async {
    await Effects.playHapticFailure();

    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Palette.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      builder: (_) => ChangeNotifierProvider<ErrorBottomSheetProvider>(
        create: (_) => ErrorBottomSheetProvider(
            exception: exception, stackTrace: stackTrace),
        child: ErrorBottomSheet(),
      ),
    );
  }

  @override
  _ErrorBottomSheetState createState() => _ErrorBottomSheetState();
}

class _ErrorBottomSheetState extends State<ErrorBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ErrorBottomSheetProvider>(context);
    final exception = provider.exception;
    final random = Random(exception.hashCode);
    final angle = random.nextInt(4) - 2;

    return Stack(
      children: <Widget>[
        SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const BottomSheetHeader(
                label: 'Oh no!',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "We're so sorry, something broke. A bug report was anonymously sent, but you can email us too!",
                  style: GentleText.introBody,
                ),
              ),
              const SizedBox(height: 24),
              Transform.rotate(
                angle: angle * pi / 180,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Palette.graySecondary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Palette.white,
                      boxShadow: const [
                        GentleShadow.basic,
                      ]),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${provider.exception.runtimeType}',
                        style: GentleText.errorReportSubTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(exception.toVisibleString(),
                          style: GentleText.errorReportLabel),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 104,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 24 + MediaQuery.of(context).padding.bottom,
          right: 24,
          child: FloatingDoneButton(
            label: 'Contact Gentle',
            icon: const AssetImage('assets/images/icons/24x24/shield.png'),
            onPressed: () {
              provider.launchEmail();
            },
            bgColor: Palette.offBlack,
          ),
        ),
      ],
    );
  }
}
