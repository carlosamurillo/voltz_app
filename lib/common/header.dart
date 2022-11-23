import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/custom_colors.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      color: CustomColors.superVolcanic,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/logo_dark_background.svg',
            width: 122,
            height: 24.5,
          ),
          const Spacer(),
          SvgPicture.asset(
            'assets/svg/help_button.svg',
            width: 74,
            height: 39,
          ),
        ],
      ),
    );
  }
}