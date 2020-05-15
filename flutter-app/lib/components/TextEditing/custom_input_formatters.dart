import 'dart:math';

import 'package:characters/characters.dart';
import 'package:flutter/services.dart';
import 'package:gentle/sanitizer.dart';

/// A [TextInputFormatter] that prevents the insertion of more than
/// a maximum defined number of newline characters ('\n').
class NoStartingWhitespaceTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.characters.isEmpty) {
      return newValue;
    }

    final trimmed = newValue.text.trimLeft();

    if (!identical(trimmed, newValue.text)) {
      return TextEditingValue(
        text: newValue.text.trimLeft(),
        selection: newValue.selection,
        composing: TextRange.empty,
      );
    }

    return newValue;
  }
}

/// A [TextInputFormatter] that prevents the insertion of more than
/// a maximum defined number of newline characters ('\n').
class NewLineLimitingTextInputFormatter extends TextInputFormatter {
  NewLineLimitingTextInputFormatter(this.maxNewLines) : assert(maxNewLines > 0);

  final int maxNewLines;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (maxNewLines == null || maxNewLines <= 0) {
      return newValue;
    }

    final numLines = '\n'.allMatches(newValue.text).length;
    if (numLines > maxNewLines) {
      // Get the position of the latest character
      final newCharIndex = newValue.selection.start - 1;

      final newSelection = newValue.selection.copyWith(
        baseOffset: newValue.selection.start - 1,
        extentOffset: newValue.selection.end - 1,
      );

      final modifiedText =
          newValue.text.replaceFirst(RegExp(r'\n'), '', newCharIndex);

      return TextEditingValue(
        text: modifiedText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }

    return newValue;
  }
}

class CustomLengthLimitingTextInputFormatter extends TextInputFormatter {
  /// Creates a formatter that prevents the insertion of more characters than a
  /// limit.
  ///
  /// The [maxLength] must be null, -1 or greater than zero. If it is null or -1
  /// then no limit is enforced.
  CustomLengthLimitingTextInputFormatter(this.maxLength)
      : assert(maxLength == null || maxLength == -1 || maxLength > 0);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    final characters = newValue.text.characters;

    if (maxLength != null && maxLength > 0 && characters.length > maxLength) {
      final TextSelection newSelection = newValue.selection.copyWith(
        baseOffset: min(newValue.selection.start, maxLength),
        extentOffset: min(newValue.selection.end, maxLength),
      );

      return TextEditingValue(
        text: newValue.text.characters.take(maxLength).toString(),
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

class CustomWhitelistTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return _selectionAwareTextManipulation(newValue, (String substring) {
      return RegExp(Sanitizer.whitelistRegex, unicode: true)
          .allMatches(substring)
          .map<String>((Match match) => match.group(0))
          .join();
    });
  }
}

TextEditingValue _selectionAwareTextManipulation(
  TextEditingValue value,
  String Function(String substring) substringManipulation,
) {
  final int selectionStartIndex = value.selection.start;
  final int selectionEndIndex = value.selection.end;
  String manipulatedText;
  TextSelection manipulatedSelection;
  if (selectionStartIndex < 0 || selectionEndIndex < 0) {
    manipulatedText = substringManipulation(value.text);
  } else {
    final String beforeSelection =
        substringManipulation(value.text.substring(0, selectionStartIndex));
    final String inSelection = substringManipulation(
        value.text.substring(selectionStartIndex, selectionEndIndex));
    final String afterSelection =
        substringManipulation(value.text.substring(selectionEndIndex));
    manipulatedText = beforeSelection + inSelection + afterSelection;
    if (value.selection.baseOffset > value.selection.extentOffset) {
      manipulatedSelection = value.selection.copyWith(
        baseOffset: beforeSelection.length + inSelection.length,
        extentOffset: beforeSelection.length,
      );
    } else {
      manipulatedSelection = value.selection.copyWith(
        baseOffset: beforeSelection.length,
        extentOffset: beforeSelection.length + inSelection.length,
      );
    }
  }
  return TextEditingValue(
    text: manipulatedText,
    selection:
        manipulatedSelection ?? const TextSelection.collapsed(offset: -1),
    composing:
        manipulatedText == value.text ? value.composing : TextRange.empty,
  );
}
