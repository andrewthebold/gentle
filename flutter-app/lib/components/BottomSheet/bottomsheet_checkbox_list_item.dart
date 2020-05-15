import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/theme.dart';

class BottomSheetCheckboxListItem extends StatefulWidget {
  final String label;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const BottomSheetCheckboxListItem({
    Key key,
    @required this.label,
    @required this.enabled,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _BottomSheetCheckboxListItemState createState() =>
      _BottomSheetCheckboxListItemState();
}

class _BottomSheetCheckboxListItemState
    extends State<BottomSheetCheckboxListItem> with TickerProviderStateMixin {
  void _handlePress() {
    widget.onChanged(!widget.enabled);
    // widget.onChanged(
    //     widget.groupValue == widget.item.option ? null : widget.item.option);
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.enabled;

    return ScaleButton(
      label: null,
      onPressed: _handlePress,
      child: AnimatedContainer(
        duration: Constants.fastAnimDuration,
        curve: Curves.fastOutSlowIn,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected ? Palette.blueTertiary : Palette.white,
        ),
        child: Row(
          children: <Widget>[
            _CustomRadio(
              selected: selected,
              activeColor: Palette.blue,
              inactiveColor: Palette.grayPrimary,
              additionalConstraints: BoxConstraints.tight(const Size(40, 40)),
              vsync: this,
              onChanged: (value) {
                _handlePress();
              },
            ),
            const SizedBox(width: 8),
            Flexible(child: Text(widget.label, style: GentleText.listLabel)),
          ],
        ),
      ),
    );
  }
}

class _CustomRadio extends LeafRenderObjectWidget {
  const _CustomRadio({
    Key key,
    @required this.selected,
    @required this.activeColor,
    @required this.inactiveColor,
    this.onChanged,
    @required this.additionalConstraints,
    @required this.vsync,
  })  : assert(selected != null),
        assert(activeColor != null),
        assert(inactiveColor != null),
        assert(vsync != null),
        super(key: key);

  final bool selected;
  final Color inactiveColor;
  final Color activeColor;
  final ValueChanged<bool> onChanged;
  final BoxConstraints additionalConstraints;
  final TickerProvider vsync;

  @override
  _RenderCustomRadio createRenderObject(BuildContext context) =>
      _RenderCustomRadio(
        value: selected,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onChanged: onChanged,
        additionalConstraints: additionalConstraints,
        vsync: vsync,
      );

  @override
  void updateRenderObject(
      BuildContext context, _RenderCustomRadio renderObject) {
    renderObject
      ..value = selected
      ..activeColor = activeColor
      ..inactiveColor = inactiveColor
      ..onChanged = onChanged
      ..additionalConstraints = additionalConstraints
      ..vsync = vsync;
  }
}

class _RenderCustomRadio extends RenderToggleable {
  _RenderCustomRadio({
    bool value,
    Color activeColor,
    Color inactiveColor,
    ValueChanged<bool> onChanged,
    BoxConstraints additionalConstraints,
    @required TickerProvider vsync,
  }) : super(
          value: value,
          tristate: false,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onChanged: onChanged,
          additionalConstraints: additionalConstraints,
          vsync: vsync,
        );

  void _drawCheck(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    // As t goes from 0.0 to 1.0, animate the two check mark strokes from the
    // short side to the long side.
    final Path path = Path();
    const Offset start = Offset(16 * 0.15, 16 * 0.45);
    const Offset mid = Offset(16 * 0.4, 16 * 0.7);
    const Offset end = Offset(16 * 0.85, 16 * 0.25);
    if (t < 0.5) {
      final double strokeT = t * 2.0;
      final Offset drawMid = Offset.lerp(start, mid, strokeT);
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
    } else {
      final double strokeT = (t - 0.5) * 2.0;
      final Offset drawEnd = Offset.lerp(mid, end, strokeT);
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
      path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final center = (offset & size).center;

    final paint = Paint()
      ..color = Color.lerp(inactiveColor, activeColor, position.value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, height: 20, width: 20),
        const Radius.circular(4),
      ),
      paint,
    );

    if (!position.isDismissed) {
      paint.style = PaintingStyle.fill;
      paint.color = paint.color.withOpacity(position.value);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            height: 20 * position.value,
            width: 20 * position.value,
          ),
          const Radius.circular(4),
        ),
        paint,
      );

      final Offset origin =
          offset + (size / 2.0 - const Size.square(16) / 2.0 as Offset);

      final strokePaint = Paint()
        ..color = Palette.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      _drawCheck(canvas, origin, position.value, strokePaint);
    }
  }
}
