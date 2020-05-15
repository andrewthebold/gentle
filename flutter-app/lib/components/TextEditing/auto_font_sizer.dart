import 'package:gentle/theme.dart';
import 'package:flutter/widgets.dart';

/// Heavily modified version of the package `auto_size_text`, for use with a
/// custom text field widget.
class AutoFontSizer {
  static const double defaultMinFontSize = 0.0;
  static const double defaultMaxFontSize = 18.0;
  static const double stepChangeSize = 1.0;

  // Magic number based on shallow manual testing. Based on some glances
  // at [RenderEditable] and [EditableText]. My best guess without wasting
  // too much time is that there's extra offset added somewhere, and it
  // might be related to the scrolling behavior of [EditableText].
  static const double heightOffset = 16.0;

  static bool _checkTextFits(
    TextSpan text,
    double scale,
    BoxConstraints constraints,
  ) {
    final tp = TextPainter(
      text: text,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      textScaleFactor: scale ?? 1,
      strutStyle: StrutStyle.fromTextStyle(GentleText.requestBody,
          forceStrutHeight: true),
    );

    tp.layout(maxWidth: constraints.maxWidth);

    final textDoesNotFit =
        tp.height > constraints.maxHeight || tp.width > constraints.maxWidth;

    return !textDoesNotFit;
  }

  static double calculateFontSizeForEditableArea({
    BoxConstraints constraints,
    TextStyle style,
    String text,
    double userScale,
    double minFontSize = defaultMinFontSize,
    double maxFontSize = defaultMaxFontSize,
  }) {
    final span = TextSpan(
      style: style,
      text: text,
    );

    // Modify the max height of the area to help ensure that we can't
    // enter a newline to make the text area scrollable
    final modifiedConstraints =
        constraints.copyWith(maxHeight: constraints.maxHeight - heightOffset);

    int left;
    int right;

    final defaultFontSize = style.fontSize.clamp(minFontSize, maxFontSize);
    final defaultScale = defaultFontSize * userScale / style.fontSize;

    // If it fits, just return the current font size
    if (_checkTextFits(span, defaultScale, modifiedConstraints)) {
      return (defaultFontSize * userScale).toDouble();
    }

    left = (minFontSize / stepChangeSize).floor();
    right = (defaultFontSize / stepChangeSize).ceil();

    var lastValueFits = false;

    while (left <= right) {
      final mid = (left + (right - left) / 2).toInt();
      final scale = mid * userScale * stepChangeSize / style.fontSize;

      if (_checkTextFits(span, scale, modifiedConstraints)) {
        left = mid + 1;
        lastValueFits = true;
      } else {
        right = mid - 1;
      }
    }

    if (!lastValueFits) {
      right += 1;
    }

    return right * userScale * stepChangeSize;
  }
}
