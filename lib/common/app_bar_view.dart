
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/custom_colors.dart';

class BlueAppBar extends AppBar {
  BlueAppBar({super.key, required this.context });
  final BuildContext context;

  @override
  Widget? get leading => SvgPicture.asset(
    'assets/svg/logo_voltz_white.svg',
    width: 120,
    height: 52,
  );

  @override
  double? get leadingWidth => 120;

  @override
  Color? get backgroundColor => CustomColors.blueVoltz;

  @override
  List<Widget>? get actions => [
    CustomIconButton(
      icon: Icons.close,
      onPressed: () => Navigator.of(context).pop(),
      buttonColor: CustomColors.white,
      backGroundColor: CustomColors.blueVoltz,
      borderColor: CustomColors.white,
    ),
  ];
}