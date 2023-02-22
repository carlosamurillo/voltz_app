import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/login/auth_gate_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../search/search_components.dart' deferred as sc;
import '../utils/buttons.dart';
import '../utils/custom_colors.dart';
import '../utils/style.dart';
import 'header_viewmodel.dart';

class Header extends StatelessWidget  {
  const Header({super.key, this.paddingVertical = 14, this.paddingHorizontal = 25});
  final double paddingVertical;
  final double paddingHorizontal;


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HeaderViewModel>.reactive(
      viewModelBuilder: () => HeaderViewModel(),
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;
        return Container(
          padding: media.width >= CustomStyles.desktopBreak ? const EdgeInsets.symmetric(vertical: 14, horizontal: 25) : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: CustomColors.white,
          width: double.infinity,
          height: media.width >= CustomStyles.desktopBreak ? CustomStyles.desktopHeaderHeight : CustomStyles.mobileHeaderHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
              if(!model.isLogged) ...[
                SizedBox(
                  width: 193,
                  child: PrimaryButton(
                    text: 'Iniciar sesión',
                    icon: Icons.account_circle,
                    onPressed: ()=>{},
                  ),
                ),
              ],
            ],
          ),
        );

      },
    );
  }
}

class SliverHeader extends StatelessWidget {
  const SliverHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SliverAppBar(
      pinned: media.width >= CustomStyles.desktopBreak ? true : false,
      snap: true,
      floating: true,
      backgroundColor: CustomColors.white,
      titleSpacing: 0,
      toolbarHeight: media.width >= CustomStyles.desktopBreak ? CustomStyles.desktopHeaderHeight : CustomStyles.mobileHeaderHeight,
      collapsedHeight: media.width >= CustomStyles.desktopBreak ? CustomStyles.desktopHeaderHeight : CustomStyles.mobileHeaderHeight,
      expandedHeight: media.width >= CustomStyles.desktopBreak ? CustomStyles.desktopHeaderHeight : CustomStyles.mobileHeaderHeight,
      title: const Header(),
    );
  }
}

@deprecated
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
