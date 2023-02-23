import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/auth/gate_simple_viewmodel.dart';
import 'package:maketplace/common/header_viewmodel.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:maketplace/search/search_components.dart' deferred as sc;


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
        return SafeArea(
            child: Container(
              padding: media.width >= CustomStyles.desktopBreak ? const EdgeInsets.only(top: 14, bottom: 14, left: 25, right: 10) : const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 5),
              color: CustomColors.white,
              width: double.infinity,
              height: media.width >= CustomStyles.desktopBreak ? CustomStyles.desktopHeaderHeight : CustomStyles.mobileHeaderHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(media.width >= CustomStyles.desktopBreak) ...[
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
                    if(model.authSignStatus != UserSignStatus.authenticated) ...[
                      const SizedBox(width: 25),
                      SizedBox(
                        width: 180,
                        height: 40,
                        child: PrimaryButton(
                          text: 'Iniciar sesión',
                          icon: Icons.account_circle,
                          onPressed: () => model.navigateToLogin(),
                        ),
                      ),
                    ],
                  ] else ...[ //Para cuando es desde Mobile
                    if(model.isSearchOpened) ...[
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
                    ] else ...[
                      SvgPicture.asset(
                        'assets/svg/logo_voltz_white_background.svg',
                        width: 120,
                        height: 52,
                      ),
                      const Spacer(),
                      CustomIconButton(
                        onPressed: () => model.showSearchWidget(),
                        buttonColor: CustomColors.white,
                        backGroundColor: CustomColors.dark,
                        icon: Icons.search,
                        borderColor: CustomColors.WBY,
                      ),
                      if(model.authSignStatus != UserSignStatus.authenticated) ...[
                        const SizedBox(width: 5),
                        CustomIconButton(
                          onPressed: () => model.navigateToLogin(),
                          buttonColor: CustomColors.dark,
                          backGroundColor: Colors.white,
                          icon: Icons.account_circle,
                          borderColor: CustomColors.WBY,
                        ),
                      ],
                    ],
                  ],
                ],
              ),
            )
        );
      },
    );
  }
}

class SliverHeader extends StatelessWidget {
  const SliverHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GateSimpleViewModel>.reactive(
      viewModelBuilder: () => GateSimpleViewModel(),
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;
        return SliverAppBar(
          iconTheme: const IconThemeData(color: CustomColors.dark),
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
      },
    );
  }
}

class _InitSessionButton extends StatelessWidget {
  const _InitSessionButton({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GateSimpleViewModel>.reactive(
      viewModelBuilder: () => GateSimpleViewModel(),
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;
        return SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
                if (model.authSignStatus != UserSignStatus.authenticated) {
                  if (constraints.maxWidth >= CustomStyles.desktopBreak) {
                    //Button de Inicio de session desktop
                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 250,
                          minWidth: 193,
                          maxHeight: 40,
                          minHeight: 40),
                      child: PrimaryButton(
                        text: 'Iniciar sesión',
                        icon: Icons.account_circle,
                        onPressed: () => model.navigateToLogin(),
                      ),
                    );
                  } else {
                    //Button de Inicio de session y de menu tableta y mobile
                    return IconButton(
                      onPressed: () => model.navigateToLogin(),
                      icon: const Icon(
                          Icons.account_circle, color: CustomColors.dark),
                    );
                  }
                } else {
                  return const SizedBox();
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
