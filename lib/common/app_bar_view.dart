import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/utils/buttons.dart';

class BlueAppBar extends AppBar {
  BlueAppBar({super.key, required this.context});
  final BuildContext context;

  @override
  Widget? get leading => SvgPicture.asset(
        AppKeys().logoWhite!,
        width: 120,
        height: 52,
      );

  @override
  double? get leadingWidth => 120;

  @override
  Color? get backgroundColor => AppKeys().customColors!.blueVoltz;

  @override
  List<Widget>? get actions => [
        CustomIconButton(
          icon: Icons.close,
          onPressed: () => Navigator.of(context).pop(),
          buttonColor: AppKeys().customColors!.white,
          backGroundColor: AppKeys().customColors!.blueVoltz,
          borderColor: AppKeys().customColors!.white,
        ),
      ];
}
