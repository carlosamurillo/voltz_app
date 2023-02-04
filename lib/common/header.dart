import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import '../pdf_quote/download_button.dart';
import '../utils/custom_colors.dart';

class Header extends StatelessWidget {
  const Header ({super.key,  this.paddingVertical = 14, this.paddingHorizontal = 25});
  final double paddingVertical;
  final double paddingHorizontal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
      color: CustomColors.white,
      width: double.infinity,
      height: 80,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/logo_voltz_white_background.svg',
            width: 120,
            height: 52,
          ),
          const Spacer(),
          const PDFDownloadButton(),
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