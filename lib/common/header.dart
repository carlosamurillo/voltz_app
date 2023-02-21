import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/auth/auth_view_model.dart';
import 'package:maketplace/auth/login/login_view.dart';
import 'package:maketplace/auth/login/login_view_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:provider/provider.dart';

import '../search/search_components.dart' deferred as sc;
import '../utils/custom_colors.dart';
import '../utils/style.dart';

class Header extends StatelessWidget {
  const Header({super.key, this.paddingVertical = 14, this.paddingHorizontal = 25});
  final double paddingVertical;
  final double paddingHorizontal;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        padding: media.width >= CustomStyles.desktopBreak ? const EdgeInsets.symmetric(vertical: 14, horizontal: 25) : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: CustomColors.white,
        width: double.infinity,
        height: media.width >= CustomStyles.desktopBreak ? CustomStyles.desktopHeaderHeight : CustomStyles.mobileHeaderHeight,
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/svg/logo_voltz_white_background.svg',
              width: 120,
              height: 52,
            ),
            const SizedBox(width: 25),
            Expanded(
              child: FutureBuilder(
                future: sc.loadLibrary(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return sc.SearchInputWidget();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            const SizedBox(width: 25),
            const _InitSessionButton(),
          ],
        ),
      ),
    );
  }
}

class _InitSessionButton extends StatelessWidget {
  const _InitSessionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userSignStatus = context.watch<AuthViewModel>().userStatus;
    switch (userSignStatus) {
      case UserSignStatus.authenticated:
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 180, minWidth: 100, maxHeight: 40, minHeight: 40),
          child: PrimaryButton(
            text: "Cerrar sesión",
            onPressed: () {
              context.read<AuthViewModel>().signOut();
            },
          ),
        );
      case UserSignStatus.unauthenticated:
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 180, minWidth: 100, maxHeight: 40, minHeight: 40),
          child: PrimaryButton(
            text: "Iniciar sesión",
            onPressed: () {
              context.read<LoginViewModel>().init();
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LoginView()));
            },
          ),
        );
      default:
        return Container();
    }
  }
}

class HeaderMobile extends StatelessWidget {
  HeaderMobile({super.key, this.paddingVertical = 15, this.paddingHorizontal = 15});
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
