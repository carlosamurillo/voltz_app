
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/common/drawer.dart';
import 'package:maketplace/common/header.dart';
import 'package:maketplace/home/home_viewmodel.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked/stacked.dart';

import '../search/search_views.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key,}) : super(key: key,);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) {

        return const Scaffold(
          drawer: MenuDrawer(),
          backgroundColor: CustomColors.WBY,
          // No appBar property provided, only the body.
          body: CustomScrollView(
            // Add the app bar and list of items as slivers in the next steps.
              slivers: <Widget>[
                SliverHeader(),
                SliverToBoxAdapter(
                  child: SizedBox(height: 25,),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 35, horizontal: 35),
                  sliver: SliverToBoxAdapter(
                    child: HowToSearchBanner(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 25,),
                ),
                SliverSearchStatsView(),
                SliverToBoxAdapter(
                  child: SizedBox(height: 25,),
                ),
                SliverClassicSearchView(),
              ]),
        );
      },
    );
  }
}
