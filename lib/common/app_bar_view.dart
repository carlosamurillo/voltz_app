import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/utils/buttons.dart';

class BlueAppBar extends AppBar {
  BlueAppBar({super.key, required this.context, this.isMobile = false});
  final BuildContext context;
  final bool isMobile;
  @override
  Widget? get leading => Padding(
        padding: isMobile ? const EdgeInsets.symmetric(horizontal: 20.0) : const EdgeInsets.symmetric(horizontal: 40.0),
        child: SvgPicture.asset(
          AppKeys().logoWhite!,
          width: 120,
          height: 52,
        ),
      );

  @override
  double? get elevation => 0;

  @override
  double? get leadingWidth => isMobile ? 160 : 200;

  @override
  Color? get backgroundColor => AppKeys().customColors!.blueVoltz;

  @override
  List<Widget>? get actions => [
        Padding(
          padding: isMobile ? const EdgeInsets.symmetric(horizontal: 20.0) : const EdgeInsets.symmetric(horizontal: 40.0),
          child: CustomIconButton(
            icon: Icons.cancel,
            onPressed: () => Navigator.of(context).pop(),
            buttonColor: Colors.transparent,
            backGroundColor: Colors.white,
            borderColor: Colors.transparent,
            weight: 24,
          ),
        ),
      ];
}
