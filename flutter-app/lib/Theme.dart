import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

ThemeData gentleTheme = ThemeData(
  primaryColor: Palette.blue,
  accentColor: Palette.offBlack,
  textSelectionColor: Palette.blueSecondary,
  fontFamily: 'Inter',
  primaryColorBrightness: Brightness.light,
);

abstract class Palette {
  // 78% = C7
  // 50% = 80
  // 10% = 1A
  //  8% = 14

  static const white = Color(0xffffffff);
  static const offBlack = Color(0xff252526);
  static const offBlack10 = Color(0x1a252526);
  static const offBlack50 = Color(0x80252526);

  static const grayPrimary = Color(0xff8E8E93);
  static const graySecondary = Color(0xffC7C7CC);
  static const grayTertiary = Color(0xffE5E5EA);

  static const blue = Color(0xff007CFF);
  static const blueSecondary = Color(0xffC1DBF7);
  static const blueTertiary = Color(0xc7E3F2FF);
  static const red = Color(0xffFD7471);
  static const redTertiary = Color(0xffFFF2F6);
  static const green = Color(0xff2DC98B);
  static const yellow = Color(0xffFBD46A);

  static const gradientBG = Color(0xFFECF5FF);
  static const blurBG = Color(0xC7ffffff);

  static const envelopePlaceholderBG = Color(0x45F0F0F0);

  static const dividerBG = Color(0xffEAEAEA);
  static const dividerBGTransparent = Color(0x00EAEAEA);
  static const dividerBGBorder = Color(0xffDADADA);

  static const transparent = Color(0x00000000);

  static const shimmerDark = Color(0xffEEEEF1);
  static const shimmerLight = Color(0xffF9F9FA);
}

// ignore: avoid_classes_with_only_static_members
abstract class GentleText {
  static const appBarDefaultButtonLabel = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static const appBarAccentButtonLabel = TextStyle(
    color: Palette.blue,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static const appBarDestructiveButtonLabel = TextStyle(
    color: Palette.red,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static const introBody = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const navbarLabel = TextStyle(
    color: Palette.white,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const cardLabelSmall = TextStyle(
    color: Palette.offBlack,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.24,
  );

  static const cardLabel = TextStyle(
    color: Palette.offBlack,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.24,
  );

  static const listLabel = TextStyle(
    color: Palette.offBlack,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: -0.24,
  );

  static const listSecondaryLabel = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const headlineText = TextStyle(
    color: Palette.offBlack,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const subHeadlineText = TextStyle(
    color: Palette.offBlack,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const requestBody = TextStyle(
    color: Palette.offBlack,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const requestPlaceholder = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const editorButtonLabel = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );

  static const wordCount = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle floatingWordCount = TextStyle(
    color: Palette.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFeatures: [FontFeature.stylisticSet(1)],
  );

  static TextStyle requestStackCount = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.stylisticSet(1)],
  );

  static const letterBody = TextStyle(
    color: Palette.offBlack,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const letterAttribution = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );

  static const floatingButton = TextStyle(
    color: Palette.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const floatingNextButton = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const emptyStateTitle = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );

  static const errorStateDescription = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static const endOfListTitle = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.25,
  );

  static const sectionLabel = TextStyle(
    color: Palette.offBlack,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ===========================================================================
  // Bottomsheet
  // ===========================================================================
  static const bottomsheetTitle = TextStyle(
    color: Palette.offBlack,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const bottomsheetSublistItem = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  // ===========================================================================
  // Error Handling
  // ===========================================================================
  static const errorReportSubTitle = TextStyle(
    color: Palette.red,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  static const errorReportLabel = TextStyle(
    color: Palette.offBlack,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );

  // ===========================================================================
  // Tip Card
  // ===========================================================================
  static const tipCardTitle = TextStyle(
    color: Palette.blue,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  static const tipCardAttribution = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  // ===========================================================================
  // Reactions
  // ===========================================================================
  static const reactionLabel = TextStyle(
    color: Palette.grayPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}

abstract class GentleShadow {
  static const mini = BoxShadow(
    blurRadius: 3,
    color: Palette.offBlack10,
    offset: Offset(0, 1),
  );

  static const basic = BoxShadow(
    blurRadius: 6,
    color: Palette.offBlack10,
    offset: Offset(0, 2),
  );

  static const basicReverse = BoxShadow(
    blurRadius: 6,
    color: Palette.offBlack10,
    offset: Offset(0, -2),
  );

  static const large = BoxShadow(
    blurRadius: 10,
    color: Palette.offBlack10,
    offset: Offset(0, 2),
  );
}
