
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/common/drawer.dart';
import 'package:maketplace/common/header.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/home/home_viewmodel.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:maketplace/search/search_views.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key,}) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          endDrawer: model.userSignStatus == UserSignStatus.authenticated ? const MenuDrawer() : null,
          backgroundColor: CustomColors.WBY,
          // No appBar property provided, only the body.
          body: CustomScrollView(
            // Add the app bar and list of items as slivers in the next steps.
              slivers: <Widget>[
                const SliverHeader(),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 25,),
                ),
                if(media.width >= CustomStyles.desktopBreak) ...[
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 35, horizontal: 35),
                    sliver: SliverToBoxAdapter(
                      child: HowToSearchBanner(),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 25,),
                  ),
                  const SliverSearchStatsView(),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 25,),
                  ),
                ],

                const SliverClassicSearchView(isHomeVersion: true),
              ]),
        );
      },
    );
  }
}

