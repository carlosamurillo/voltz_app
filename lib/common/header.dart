import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/custom_colors.dart';

class Header extends StatelessWidget {
  Header ({ this.paddingVertical = 20, this.paddingHorizontal = 20});
  double paddingVertical;
  double paddingHorizontal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
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

class HeaderMobile extends StatelessWidget {
  HeaderMobile ({ this.paddingVertical = 15, this.paddingHorizontal = 15});
  double paddingVertical;
  double paddingHorizontal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
      color: Colors.white,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/logo_mobile.svg',
            width: 97,
            height: 18,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}