import 'package:gentle/components/BottomSheet/intro_bottomsheet.dart';
import 'package:gentle/components/Buttons/scale_button.dart';
import 'package:gentle/components/Particles/circle_particle.dart';
import 'package:gentle/components/Particles/dot_particle.dart';
import 'package:gentle/components/Particles/plus_particle.dart';
import 'package:gentle/components/Particles/rect_particle.dart';
import 'package:gentle/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/providers/intro_screen_provider.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

class IntroButton extends StatefulWidget {
  @override
  _IntroButtonState createState() => _IntroButtonState();
}

class _IntroButtonState extends State<IntroButton> {
  Widget _buildBehindParticles() {
    return SizedOverflowBox(
      alignment: Alignment.center,
      size: const Size.square(Constants.floatingButtonDiameter),
      child: SizedBox(
        height: Constants.floatingButtonDiameter + 40,
        width: Constants.floatingButtonDiameter + 40,
        child: Stack(
          children: const <Widget>[
            RectParticle(
              offset: Offset(80.0, 90.0),
              delay: Duration(seconds: 2),
            ),
            CircleParticle(
              offset: Offset(12.0, 85.0),
            ),
            PlusParticle(
              offset: Offset(6.0, 60.0),
              delay: Duration(seconds: 3),
            ),
            DotParticle(
              offset: Offset(5.0, 75.0),
              delay: Duration(seconds: 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInFrontParticles() {
    return SizedOverflowBox(
      alignment: Alignment.center,
      size: const Size.square(Constants.floatingButtonDiameter),
      child: SizedBox(
        height: Constants.floatingButtonDiameter + 40,
        width: Constants.floatingButtonDiameter + 40,
        child: Stack(
          children: const <Widget>[
            RectParticle(
              offset: Offset(14.0, 36.0),
              horizontal: true,
            ),
            CircleParticle(
              offset: Offset(102.0, 46.0),
              delay: Duration(seconds: 5),
            ),
            PlusParticle(
              offset: Offset(104.0, 104.0),
            ),
            DotParticle(
              offset: Offset(110.0, 72.0),
            ),
            DotParticle(
              offset: Offset(88.0, 110.0),
              delay: Duration(seconds: 5),
            ),
            DotParticle(
              offset: Offset(28.0, 27.0),
              delay: Duration(seconds: 1),
            ),
            DotParticle(
              offset: Offset(110.0, 32.0),
              delay: Duration(seconds: 9),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IntroScreenProvider>(context);

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _buildBehindParticles(),
        ScaleButton(
          onPressed: () {
            IntroBottomSheet.show(context: context, provider: provider);
          },
          label: UIStrings.createRequest,
          child: Container(
            height: Constants.floatingButtonDiameter,
            width: Constants.floatingButtonDiameter,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Constants.floatingButtonDiameter / 2),
              boxShadow: const [GentleShadow.basic],
              color: Palette.blue,
            ),
            child: const Image(
              height: 32,
              width: 32,
              image: AssetImage('assets/images/icons/32x32/right.png'),
              color: Palette.white,
            ),
          ),
        ),
        _buildInFrontParticles(),
      ],
    );
  }
}
