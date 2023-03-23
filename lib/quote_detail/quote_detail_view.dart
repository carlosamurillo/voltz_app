import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/common/drawer.dart';
import 'package:maketplace/common/header.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/quote_detail/dashboard_container_viewmodel.dart';
import 'package:maketplace/quote_detail/quote_detail_viewmodel.dart';
import 'package:maketplace/quote_detail/quote_overview_model.dart';
import 'package:maketplace/search/search_views.dart';
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
          backgroundColor: AppKeys().customColors!.WBY,
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
          color: AppKeys().customColors!.WBY,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(child: _CardGridTemp()),
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

class TemporalStreamWidget extends StatefulWidget {
  @override
  _TemporalStreamState createState() => _TemporalStreamState();
}

class _TemporalStreamState extends State<TemporalStreamWidget> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['full_name']),
                  subtitle: Text(data['company']),
                );
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}

class _CardGridTemp extends StackedHookView<QuoteDetailViewModel> {
  const _CardGridTemp({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteDetailViewModel model,
  ) {
    var media = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: model.quotesTemp,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        var crossAxisCount = ((media.width - 100) / 350).floor() != 0 ? ((media.width - 100) / 350).floor() : 1;
        var itemWidth = (media.width - 50) / crossAxisCount;
        return Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cotizaciones recientes',
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: AppKeys().customColors!.blueVoltz,
                      height: 1.1,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: GridView.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: ((media.width - 100) / 350).floor() != 0 ? ((media.width - 100) / 350).floor() : 1,
                    crossAxisSpacing: 0,
                    childAspectRatio: itemWidth / 120,
                    mainAxisSpacing: 0,

                    // Generate 100 widgets that display their index in the List.
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: _ItemWidget(quoteModel: QuoteOverviewModel.fromJson(data, document.id)),
                          );
                        })
                        .toList()
                        .cast(),
                  ),
                )
              ],
            ));
      },
    );
  }
}
/*

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
*/

class _ItemWidget extends StackedHookView<QuoteDetailViewModel> {
  const _ItemWidget({Key? key, required this.quoteModel}) : super(key: key, reactive: true);
  final QuoteOverviewModel quoteModel;
  @override
  Widget builder(
    BuildContext context,
    QuoteDetailViewModel model,
  ) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppKeys().customColors!.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => model.goToCart(quoteModel.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
            width: 350,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        quoteModel.alias ?? '',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                            color: AppKeys().customColors!.dark,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        "creado a las ${intl.DateFormat("HH:mm, dd/MM", 'es_MX').format(quoteModel.createdAt!.toDate())}",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                            color: AppKeys().customColors!.dark1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      quoteModel.consecutive.toString(),
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: AppKeys().customColors!.dark,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      color: AppKeys().customColors!.yellowVoltz,
                      child: Text(
                        "ASISTIDA",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                            color: AppKeys().customColors!.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
