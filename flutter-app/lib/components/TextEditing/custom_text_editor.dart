import 'package:gentle/components/TextEditing/auto_font_sizer.dart';
import 'package:gentle/components/TextEditing/custom_editable_text.dart';
import 'package:gentle/components/TextEditing/custom_input_formatters.dart';
import 'package:gentle/components/TextEditing/text_field_selection_gesture_detector_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gentle/theme.dart';

import 'package:characters/characters.dart';

class CustomTextEditor extends StatefulWidget {
  final TextEditingController textController;
  final FocusNode focusNode;
  final TextStyle textStyle;

  final int maxLength;
  final int maxNewLines;

  final String placeholder;

  final GlobalKey<EditableTextState> editableTextKey;

  const CustomTextEditor({
    Key key,
    @required this.textController,
    @required this.focusNode,
    @required this.textStyle,
    @required this.maxLength,
    @required this.maxNewLines,
    @required this.placeholder,
    @required this.editableTextKey,
  })  : assert(textController != null),
        assert(focusNode != null),
        assert(textStyle != null),
        assert(maxLength != null && maxLength > 0),
        assert(maxNewLines != null && maxNewLines > 0),
        assert(placeholder != null),
        super(key: key);

  @override
  CustomTextEditorState createState() => CustomTextEditorState();
}

class CustomTextEditorState extends State<CustomTextEditor>
    implements TextSelectionGestureDetectorBuilderDelegate {
  TextEditingController get _effectiveController => widget.textController;
  FocusNode get _effectiveFocusNode => widget.focusNode;
  bool _showSelectionHandles = false;
  TextFieldSelectionGestureDetectorBuilder _selectionGestureDetectorBuilder;
  int get _currentLength => _effectiveController.value.text.characters.length;
  EditableTextState get _editableText => editableTextKey.currentState;

  // API for TextSelectionGestureDetectorBuilderDelegate.
  @override
  bool forcePressEnabled;

  @override
  GlobalKey<EditableTextState> get editableTextKey => widget.editableTextKey;

  @override
  bool get selectionEnabled => true;
  // End of API for TextSelectionGestureDetectorBuilderDelegate.

  @override
  void initState() {
    super.initState();
    _selectionGestureDetectorBuilder =
        TextFieldSelectionGestureDetectorBuilder(state: this);
    _effectiveFocusNode.canRequestFocus = true;
  }

  void requestKeyboard() {
    _editableText?.requestKeyboard();
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    if (cause == SelectionChangedCause.keyboard) return false;
    if (cause == SelectionChangedCause.longPress) return true;
    if (_effectiveController.text.isNotEmpty) return true;

    return false;
  }

  void _handleSelectionChanged(
      TextSelection selection, SelectionChangedCause cause) {
    final willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (cause == SelectionChangedCause.longPress) {
          _editableText?.bringIntoView(selection.base);
        }
        return;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      // Do nothing.
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText.toggleToolbar();
    }
  }

  Widget _addTextDependentAttachments(Widget editableText) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _effectiveController,
      builder: (BuildContext context, TextEditingValue text, Widget child) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  if (text.text.isEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.placeholder,
                        style: widget.textStyle
                            .copyWith(color: Palette.grayPrimary),
                      ),
                    ),
                  child,
                ],
              ),
            ),
          ],
        );
      },
      child: editableText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final keyboardAppearance = themeData.primaryColorBrightness;

    TextSelectionControls textSelectionControls;
    bool paintCursorAboveText;
    bool cursorOpacityAnimates;
    Offset cursorOffset;

    switch (themeData.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        forcePressEnabled = true;
        textSelectionControls = cupertinoTextSelectionControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates = true;
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.of(context).devicePixelRatio, 0);
        break;

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        forcePressEnabled = false;
        textSelectionControls = materialTextSelectionControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        break;
    }

    return LayoutBuilder(
      builder: (context, size) {
        final fontSize = AutoFontSizer.calculateFontSizeForEditableArea(
          constraints: size,
          style: widget.textStyle,
          text: _effectiveController.value.text,
          userScale: MediaQuery.textScaleFactorOf(context),
          minFontSize: 0.0,
          maxFontSize: widget.textStyle.fontSize,
        );

        final adjustedTextStyle = widget.textStyle.copyWith(fontSize: fontSize);

        final Widget child = RepaintBoundary(
          child: CustomEditableText(
            key: editableTextKey,
            showSelectionHandles: _showSelectionHandles,
            controller: _effectiveController,
            focusNode: _effectiveFocusNode,
            style: adjustedTextStyle,
            selectionColor: themeData.textSelectionColor,
            selectionControls: textSelectionControls,
            onSelectionChanged: _handleSelectionChanged,
            onSelectionHandleTapped: _handleSelectionHandleTapped,
            inputFormatters: <TextInputFormatter>[
              CustomWhitelistTextInputFormatter(),
              CustomLengthLimitingTextInputFormatter(widget.maxLength),
              NewLineLimitingTextInputFormatter(widget.maxNewLines),
              NoStartingWhitespaceTextInputFormatter(),
            ],
            cursorOpacityAnimates: cursorOpacityAnimates,
            cursorOffset: cursorOffset,
            paintCursorAboveText: paintCursorAboveText,
            keyboardAppearance: keyboardAppearance,
          ),
        );

        return AnimatedBuilder(
          animation: _effectiveController,
          builder: (BuildContext context, Widget child) {
            return Semantics(
              maxValueLength:
                  null, // TODO: Handle this max length value in semantics
              currentValueLength: _currentLength,
              onTap: () {
                if (!_effectiveController.selection.isValid) {
                  _effectiveController.selection = TextSelection.collapsed(
                      offset: _effectiveController.text.length);
                }
                requestKeyboard();
              },
              child: child,
            );
          },
          child: _selectionGestureDetectorBuilder.buildGestureDetector(
            behavior: HitTestBehavior.translucent,
            child: _addTextDependentAttachments(child),
          ),
        );
      },
    );
  }
}
