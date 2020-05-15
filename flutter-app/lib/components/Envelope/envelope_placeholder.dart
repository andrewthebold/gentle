import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/theme.dart';

class EnvelopePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: Palette.grayTertiary,
        dashPattern: const [4, 6],
        padding: const EdgeInsets.all(0),
        radius: const Radius.circular(10),
        strokeCap: StrokeCap.round,
        strokeWidth: 1,
        child: Container(
          decoration: const BoxDecoration(
            color: Palette.envelopePlaceholderBG,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
