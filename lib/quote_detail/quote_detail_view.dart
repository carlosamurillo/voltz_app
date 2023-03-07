import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/common/drawer.dart';
import 'package:maketplace/common/header.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote_detail/dashboard_container_viewmodel.dart';
import 'package:maketplace/quote_detail/quote_detail_viewmodel.dart';
import 'package:maketplace/search/search_views.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class QuoteDetailListView extends StatelessWidget {
  const QuoteDetailListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardContainerViewModel>.reactive(
      viewModelBuilder: () => DashboardContainerViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          endDrawer: model.userSignStatus == UserSignStatus.authenticated ? const MenuDrawer() : null,
          backgroundColor: CustomColors.WBY,
          // No appBar property provided, only the body.
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                const SliverHeader(),
                /*SliverOverlapAbsorber(
                    // This widget takes the overlapping behavior of the SliverAppBar,
                    // and redirects it to the SliverOverlapInjector below. If it is
                    // missing, then it is possible for the nested "inner" scroll view
                    // below to end up under the SliverAppBar even when the inner
                    // scroll view thinks it has not been scrolled.
                    // This is not necessary if the "headerSliverBuilder" only builds
                    // widgets that do not overlap the next sliver.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: const SliverHeader(),
                  ),*/
              ];
            },
            body: Builder(builder: (BuildContext context) {
              if (model.isSearchSelected) {
                return const CustomScrollView(
                    //physics: model.isSearchSelected ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                    // Add the app bar and list of items as slivers in the next steps.
                    slivers: <Widget>[
                      /*SliverToBoxAdapter(
                              child: SizedBox(height: 25,),
                            ),
                            SliverSearchStatsView(),*/
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 25,
                        ),
                      ),
                      SliverProductsSearchResult(),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 25,
                        ),
                      ),
                    ]);
              }
              return const _QuoteDetailListView();
            }),
          ),
        );
      },
    );
  }
}

class _QuoteDetailListView extends StatelessWidget {
  const _QuoteDetailListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuoteDetailViewModel>.reactive(
      viewModelBuilder: () => QuoteDetailViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;

        return Container(
          constraints: BoxConstraints(
            minWidth: CustomStyles.mobileBreak,
          ),
          color: CustomColors.WBY,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(child: _CardGrid()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardGrid extends StackedHookView<QuoteDetailViewModel> {
  const _CardGrid({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteDetailViewModel model,
  ) {
    var media = MediaQuery.of(context).size;
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(right: 25, left: 25),
          child: MasonryGridView.count(
            itemBuilder: (context, index) {
              return _ItemWidget(quoteModel: model.quoteDetailList[index]);
            },
            itemCount: model.quoteDetailList.length,
            mainAxisSpacing: 25,
            crossAxisSpacing: 25,
            crossAxisCount: ((media.width - 50) / 350).floor() != 0 ? ((media.width - 50) / 350).floor() : 1,
          ),
        );
      },
    );
  }
}

class _ItemWidget extends StackedHookView<QuoteDetailViewModel> {
  const _ItemWidget({Key? key, required this.quoteModel}) : super(key: key, reactive: true);
  final QuoteModel quoteModel;
  @override
  Widget builder(
    BuildContext context,
    QuoteDetailViewModel model,
  ) {
    return Container(
      decoration: const BoxDecoration(color: CustomColors.white),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => model.goToCart(quoteModel.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
            width: 350,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(quoteModel.alias ?? ''),
                      Row(
                        children: [
                          Text(
                            "creado a las ${intl.DateFormat("HH:mm, dd/MM", 'es_MX').format(quoteModel.createdAt!.toDate())}",
                          ),
                          const SizedBox(width: 5),
                          // if (model.author?.id != null) //
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            color: CustomColors.yellowVoltz,
                            child: const Text(
                              "ASISTIDO",
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.all(7.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColors.WBY,
                  ),
                  child: Text(quoteModel.consecutive.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
