import 'dart:math';

import 'package:gentle/components/Envelope/envelope_stamp.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';
import 'package:flutter/material.dart';

enum MailVariant {
  plain,
  airmail,
  official,
}

class EnvelopeStyle {
  final MailVariant variant;
  final Color stampColor;
  final Stamp stamp;
  final int stampRotationAngle;
  final Color addressColor;

  /// Stored for any future styles that require the same seed
  final int seed;

  EnvelopeStyle({
    @required this.variant,
    @required this.stampColor,
    @required this.stamp,
    @required this.stampRotationAngle,
    @required this.seed,
    @required this.addressColor,
  })  : assert(variant != null),
        assert(stampColor != null),
        assert(stamp != null),
        assert(stampRotationAngle != null &&
            stampRotationAngle >= -360.0 &&
            stampRotationAngle <= 360.0),
        assert(seed != null),
        assert(addressColor != null);
}

/// Used to deterministically decide (based on firestore ID's) what a
/// piece of mail looks like in the UI. This allows us to avoid storing
/// this theming data on the server.
///
/// We may want to scrap this logic if we decide in the future to let
/// users style their own mail.
class EnvelopeStyleDecider {
  static const List<MailVariant> unavailableVariants = [
    MailVariant.official,
  ];

  static const List<Stamp> unavailableStamps = [
    Stamp.verified,
  ];

  static EnvelopeStyle genEnvelopeStyle(
      {@required String id, @required bool isAdmin}) {
    final seed = id.hashCode;
    final random = Random(seed);
    final rotationAngle = random.nextInt(Constants.stampRotationMax * 2) -
        Constants.stampRotationMax;

    if (isAdmin) {
      return EnvelopeStyle(
        variant: MailVariant.official,
        stampColor: Palette.blue,
        stamp: Stamp.verified,
        stampRotationAngle: rotationAngle,
        seed: seed,
        addressColor: Palette.graySecondary,
      );
    }

    final potentialVariants = MailVariant.values.sublist(0);
    for (final variant in unavailableVariants) {
      potentialVariants.remove(variant);
    }
    final variant = potentialVariants[random.nextInt(potentialVariants.length)];

    final stampColor = EnvelopeStamp
        .stampColors[random.nextInt(EnvelopeStamp.stampColors.length)];

    final potentialStamps = Stamp.values.sublist(0);
    for (final stamp in unavailableStamps) {
      potentialStamps.remove(stamp);
    }
    final stamp = potentialStamps[random.nextInt(potentialStamps.length)];

    return EnvelopeStyle(
      variant: variant,
      stampColor: stampColor,
      stamp: stamp,
      stampRotationAngle: rotationAngle,
      seed: seed,
      addressColor: Palette.grayPrimary,
    );
  }
}
