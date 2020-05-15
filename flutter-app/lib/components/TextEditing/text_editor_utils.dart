import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

class TextEditorUtils {
  /// Handles moving the text editing caret when a user taps above or below
  /// a given [CustomTextEditor]
  static void moveCursorOnParentTap({
    @required Offset tapGlobalPos,
    @required BuildContext editableTextContext,
    @required EditableTextState editableTextState,
    @required TextEditingController textEditingController,
  }) {
    if (tapGlobalPos == null ||
        editableTextContext == null ||
        editableTextState == null ||
        textEditingController == null) {
      debugPrint(
          'Ignored moving text editing cursor on tap above/below due to null args');
      return;
    }

    final RenderBox editableTextBox =
        editableTextContext.findRenderObject() as RenderBox;

    final tapPosRelativeToTopLeftOfTextEditor =
        editableTextBox.globalToLocal(tapGlobalPos);
    final tapPostRelativeToBottomRightOfTextEditor =
        tapPosRelativeToTopLeftOfTextEditor -
            Offset(editableTextBox.size.width, editableTextBox.size.height);

    // If the user taps on the letter above the text area, move the cursor
    // to the beginning of the writing area. Or if they tap below, move
    // the cursor to the end

    TextEditingValue newTextEditingValue;

    if (tapPosRelativeToTopLeftOfTextEditor.dy < 0) {
      newTextEditingValue = textEditingController.value.copyWith(
        selection: TextSelection.fromPosition(const TextPosition(offset: 0)),
        composing: const TextRange.collapsed(0),
      );
    } else if (tapPostRelativeToBottomRightOfTextEditor.dy > 0) {
      newTextEditingValue = textEditingController.value.copyWith(
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: textEditingController.text.characters.length,
          ),
        ),
        composing:
            TextRange.collapsed(textEditingController.text.characters.length),
      );
    }

    if (newTextEditingValue != null) {
      editableTextState.updateEditingValue(newTextEditingValue);
      textEditingController.selection = newTextEditingValue.selection;
      editableTextState.hideToolbar();
    }
  }
}
