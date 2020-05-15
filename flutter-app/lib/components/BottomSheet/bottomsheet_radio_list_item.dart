import 'package:flutter/material.dart';
import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/providers/report_provider.dart';
import 'package:gentle/theme.dart';

class BottomSheetRadioListItem extends StatefulWidget {
  final ReportItem item;
  final ReportOption groupValue;
  final ValueChanged<ReportOption> onChanged;

  const BottomSheetRadioListItem({
    Key key,
    @required this.item,
    @required this.groupValue,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _BottomSheetRadioListItemState createState() =>
      _BottomSheetRadioListItemState();
}

class _BottomSheetRadioListItemState extends State<BottomSheetRadioListItem>
    with TickerProviderStateMixin {
  void _handlePress() {
    widget.onChanged(
        widget.groupValue == widget.item.option ? null : widget.item.option);
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.groupValue == widget.item.option;

    return ScaleButton(
      label: null,
      onPressed: _handlePress,
      child: AnimatedContainer(
        duration: Constants.fastAnimDuration,
        height: selected
            ? (56 + (32 * widget.item.subitems.length)).toDouble()
            : 48,
        curve: Curves.fastOutSlowIn,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected
              ? (widget.item.isDestructive
                  ? Palette.redTertiary
                  : Palette.blueTertiary)
              : Palette.white,
        ),
        child: Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            Row(
              children: <Widget>[
                _CustomRadio(
                  selected: selected,
                  activeColor:
                      widget.item.isDestructive ? Palette.red : Palette.blue,
                  inactiveColor: Palette.grayPrimary,
                  additionalConstraints:
                      BoxConstraints.tight(const Size(40, 40)),
                  vsync: this,
                  onChanged: (value) {
                    _handlePress();
                  },
                ),
                const SizedBox(width: 8),
                Flexible(
                    child:
                        Text(widget.item.label, style: GentleText.listLabel)),
              ],
            ),
            Positioned(
              top: 40,
              left: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.item.subitems
                    .map(
                      (item) => _SubListItem(
                        text: item.text,
                        icon: item.icon,
                        isDestructive: widget.item.isDestructive,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubListItem extends StatelessWidget {
  final AssetImage icon;
  final String text;
  final bool isDestructive;

  const _SubListItem(
      {Key key,
      @required this.icon,
      @required this.text,
      @required this.isDestructive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            image: icon,
            height: 24,
            width: 24,
            color: isDestructive ? Palette.red : Palette.blue,
          ),
          const SizedBox(width: 14),
          Flexible(
            fit: FlexFit.loose,
            child: Text(text, style: GentleText.bottomsheetSublistItem),
          )
        ],
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

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final center = (offset & size).center;

    final paint = Paint()
      ..color = Color.lerp(inactiveColor, activeColor, position.value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, 10, paint);

    if (!position.isDismissed) {
      paint.style = PaintingStyle.fill;
      paint.color = paint.color.withOpacity(position.value);
      canvas.drawCircle(center, 8 * position.value, paint);
    }
  }
}
