import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/auth/gate_simple_viewmodel.dart';
import 'package:maketplace/common/drawer.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:stacked/stacked.dart';
import '../search/search_components.dart' deferred as sc;
import '../utils/buttons.dart';
import '../utils/custom_colors.dart';
import '../utils/style.dart';

class Header extends StatelessWidget  {
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
              _InitSessionButton(
                onTapMenu: () async {
                  print('Drawer ');
                  Scaffold.of(context).openDrawer();
                } ,),
            ],
          ),
        )
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

class _InitSessionButton extends StatelessWidget {
  const _InitSessionButton({Key? key, required this.onTapMenu}) : super(key: key);
  final Function() onTapMenu;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GateSimpleViewModel>.reactive(
      viewModelBuilder: () => GateSimpleViewModel(),
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;
        return SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints){
                if(constraints.maxWidth >= CustomStyles.desktopBreak){
                  //Button de Inicio de session desktop
                  return model.authSignStatus == UserSignStatus.authenticated ? IconButton(
                    onPressed: () => onTapMenu(),
                    icon: const Icon(Icons.menu, color: CustomColors.dark),
                  ) : ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250, minWidth: 193, maxHeight: 40, minHeight: 40),
                    child: PrimaryButton(
                      text: 'Iniciar sesión',
                      icon: Icons.account_circle,
                      onPressed: () => model.navigateToLogin(),
                    ),
                  );
                } else {
                  //Button de Inicio de session y de menu tableta y mobile
                  return model.authSignStatus == UserSignStatus.authenticated ?  IconButton(
                    onPressed: () => onTapMenu(),
                    icon: const Icon(Icons.menu, color: CustomColors.dark),
                  ) : IconButton(
                    onPressed: () => model.navigateToLogin(),
                    icon: const Icon(Icons.account_circle, color: CustomColors.dark),
                  );
                }
              }
            ),
        );
      },
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
